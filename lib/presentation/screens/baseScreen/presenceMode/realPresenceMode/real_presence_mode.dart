import 'dart:async';
import 'package:flutter/material.dart';
import 'package:two/services/presence_service.dart';

class RealPresenceMode {
  final TimeTracker timeTracker = TimeTracker();
  final List<PresenceSession> history = [];
  bool isActive = false;
  int currentPoints = 0;

  void setSessionDuration(int minutes) {
    if (!isActive) {
      timeTracker.setDuration(minutes);
    }
  }

  Future<void> activateMode() async {
    isActive = true;
    currentPoints = 0;
    timeTracker.resetElapsed();
    timeTracker.start();
  }

  Future<void> deactivateMode({int? casalId}) async {
    isActive = false;
    timeTracker.stop();

    int elapsedMinutes = (timeTracker.elapsedSeconds / 60)
        .ceil(); // Arredonda segundos pra minutos
    currentPoints = calculatePoints(elapsedMinutes);

    final session = PresenceSession(
      durationMinutes: elapsedMinutes,
      points: currentPoints,
      date: DateTime.now(),
      casalId: casalId,
    );

    history.insert(0, session);
    if (casalId != null) {
      await PresenceService.saveSession(session);
    }
  }

  int calculatePoints(int minutes) {
    return minutes; // 1 ponto por minuto
  }

  Future<void> fetchHistory(int casalId) async {
    final backendHistory = await PresenceService.fetchHistory(casalId);
    history
      ..clear()
      ..addAll(backendHistory);
  }
}

class TimeTracker {
  Timer? _timer;
  int totalSeconds = 3600; // padrão: 1 hora = 3600 segundos
  int elapsedSeconds = 0;
  VoidCallback? onTick;

  void setDuration(int minutes) {
    totalSeconds = minutes * 60;
    elapsedSeconds = 0;
  }

  void resetElapsed() {
    elapsedSeconds = 0;
  }

  String get formattedTime {
    int remaining = totalSeconds - elapsedSeconds;
    if (remaining < 0) remaining = 0;
    int hours = remaining ~/ 3600;
    int minutes = (remaining % 3600) ~/ 60;
    int seconds = remaining % 60;

    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  void start() {
    stop();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      elapsedSeconds += 1; // Agora conta corretamente em segundos reais
      if (elapsedSeconds >= totalSeconds) {
        stop();
      }
      if (onTick != null) onTick!();
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  int get elapsedMinutes => elapsedSeconds ~/ 60;

  void dispose() {
    stop();
    onTick = null;
  }
}

class PresenceSession {
  final int durationMinutes;
  final int points;
  final DateTime date;
  final int? casalId;

  PresenceSession({
    required this.durationMinutes,
    required this.points,
    required this.date,
    this.casalId,
  });

  String get formattedTime {
    final hours = durationMinutes ~/ 60;
    final minutes = durationMinutes % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  factory PresenceSession.fromJson(Map<String, dynamic> json) {
    return PresenceSession(
      durationMinutes: json['tempo_em_minutos'] ?? 0,
      points: json['pontos'] ?? 0,
      date: DateTime.parse(
          json['iniciado_em'] ?? DateTime.now().toIso8601String()),
      casalId: json['casal_id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'casal_id': casalId,
        'tempo_em_minutos': durationMinutes,
        'pontos': points,
        'iniciado_em': date.toIso8601String(),
      };
}
