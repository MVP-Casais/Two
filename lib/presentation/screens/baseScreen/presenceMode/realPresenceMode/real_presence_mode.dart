import 'dart:async';
import 'package:flutter/material.dart';

class RealPresenceMode {
  final TimeTracker timeTracker = TimeTracker();
  final List<PresenceSession> history = [];
  bool isActive = false;
  int currentPoints = 0;

  void setSessionDuration(int seconds) {
    timeTracker.setDuration(seconds);
  }

  Future<void> activateMode() async {
    isActive = true;
    currentPoints = 0;
    timeTracker.start();
  }

  Future<void> deactivateMode() async {
    isActive = false;
    timeTracker.stop();
    currentPoints = calculatePoints(timeTracker.elapsedSeconds);
    history.insert(0, PresenceSession(
      duration: timeTracker.elapsedSeconds,
      points: currentPoints,
      date: DateTime.now(),
    ));
  }

  int calculatePoints(int seconds) {
    return (seconds / 60).floor();
  }
}

class TimeTracker {
  late Timer _timer;
  int totalSeconds = 1800;
  int elapsedSeconds = 0;
  VoidCallback? onTick;

  void setDuration(int seconds) {
    totalSeconds = seconds;
    elapsedSeconds = 0;
  }

  String get formattedTime {
    int remaining = totalSeconds - elapsedSeconds;
    int minutes = remaining ~/ 60;
    int seconds = remaining % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void start() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      elapsedSeconds++;
      if (elapsedSeconds >= totalSeconds) {
        stop();
      }
      if (onTick != null) onTick!();
    });
  }

  void stop() {
    _timer.cancel();
  }
}

class PresenceSession {
  final int duration;
  final int points;
  final DateTime date;

  PresenceSession({
    required this.duration,
    required this.points,
    required this.date,
  });

  String get formattedTime {
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
