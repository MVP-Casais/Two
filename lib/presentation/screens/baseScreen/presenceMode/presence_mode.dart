import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:two/core/themes/app_colors.dart';

class SessionHistoryEntry {
  final DateTime date;
  final int points;
  final String formattedTime;

  SessionHistoryEntry(this.date, this.points, this.formattedTime);
}

class QualityTimeTracker {
  Timer? _timer;
  int _seconds = 0;
  int _maxDuration = 0;
  Function? onTick;

  void setMaxDuration(int seconds) {
    _maxDuration = seconds;
  }

  void startTimer() {
    _seconds = 0;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _seconds++;
      if (onTick != null) onTick!();
      if (_maxDuration > 0 && _seconds >= _maxDuration) {
        stopTimer();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  int get totalSeconds => _seconds;

  String get formattedTime {
    int minutes = _seconds ~/ 60;
    int seconds = _seconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}

class ConnectionScore {
  int _points = 0;

  void addPoints(int minutes) {
    _points += minutes;
  }

  int get points => _points;

  void resetPoints() {
    _points = 0;
  }
}

class RealPresenceMode {
  final QualityTimeTracker timeTracker = QualityTimeTracker();
  final ConnectionScore connectionScore = ConnectionScore();
  bool _isActive = false;
  final List<SessionHistoryEntry> _history = [];

  final List<String> _challenges = [
    "Olhem nos olhos por 2 minutos sem falar nada.",
    "Façam um elogio sincero um para o outro.",
    "Relembrem juntos uma memória engraçada.",
    "Contem um segredo que nunca disseram.",
    "Façam uma mini dança juntos, mesmo sem música.",
  ];
  String _currentChallenge = "";

  void pickRandomChallenge() {
    _currentChallenge = (_challenges..shuffle()).first;
  }

  String get currentChallenge => _currentChallenge;

  void setSessionDuration(int seconds) {
    timeTracker.setMaxDuration(seconds);
  }

  Future<void> activateMode() async {
    _isActive = true;
    timeTracker.startTimer();
    pickRandomChallenge();
    await _blockNotifications();
  }

  Future<void> deactivateMode() async {
    _isActive = false;
    timeTracker.stopTimer();
    await _unblockNotifications();
    int minutes = timeTracker.totalSeconds ~/ 60;
    connectionScore.addPoints(minutes);
    _history.add(SessionHistoryEntry(
      DateTime.now(),
      minutes,
      timeTracker.formattedTime,
    ));
  }

  Future<void> _blockNotifications() async {
    var status = await Permission.notification.request();
    if (status.isGranted) {
      print("Notificações bloqueadas");
    }
  }

  Future<void> _unblockNotifications() async {
    var status = await Permission.notification.request();
    if (status.isGranted) {
      print("Notificações desbloqueadas");
    }
  }

  bool get isActive => _isActive;
  int get currentPoints => connectionScore.points;
  void resetPoints() => connectionScore.resetPoints();
  List<SessionHistoryEntry> get history => List.unmodifiable(_history);
}

class PresenceModeScreen extends StatefulWidget {
  @override
  _PresenceModeScreenState createState() => _PresenceModeScreenState();
}

class _PresenceModeScreenState extends State<PresenceModeScreen> {
  final RealPresenceMode _realPresenceMode = RealPresenceMode();
  late Timer _timer;
  int _selectedDuration = 30;

  @override
  void initState() {
    super.initState();
    _realPresenceMode.timeTracker.onTick = () => setState(() {});
    _startUIUpdateTimer();
  }

  void _startUIUpdateTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_realPresenceMode.isActive) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStatusCard(),
                  const SizedBox(height: 30),
                  _buildDurationDropdown(),
                  const SizedBox(height: 20),
                  _buildActionButtons(screenWidth, screenHeight),
                  const SizedBox(height: 40),
                  _buildStatusIndicator(screenHeight),
                  const SizedBox(height: 30),
                  _buildSessionHistory(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.neutral.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            _realPresenceMode.isActive ? "Modo Ativo" : "Modo Desativado",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.titlePrimary,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.timer, color: AppColors.icons, size: 30),
              const SizedBox(width: 10),
              Text(
                _realPresenceMode.timeTracker.formattedTime,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: AppColors.titlePrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 30),
              const SizedBox(width: 10),
              Text(
                "${_realPresenceMode.currentPoints} pontos",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: AppColors.titlePrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_realPresenceMode.isActive)
            Text(
              'Desafio: ${_realPresenceMode.currentChallenge}',
              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }

  Widget _buildDurationDropdown() {
    return DropdownButton<int>(
      value: _selectedDuration,
      items: [5, 10, 15, 30, 60].map((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text('$value minutos'),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _selectedDuration = newValue!;
          _realPresenceMode.setSessionDuration(_selectedDuration * 60);
        });
      },
    );
  }

  Widget _buildActionButtons(double screenWidth, double screenHeight) {
    final buttonWidth = screenWidth * 0.35;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: _realPresenceMode.isActive
              ? null
              : () async {
                  _realPresenceMode.setSessionDuration(_selectedDuration * 60);
                  await _realPresenceMode.activateMode();
                  setState(() {});
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            fixedSize: Size(buttonWidth, screenHeight * 0.06), 
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Ativar',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.neutral,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: _realPresenceMode.isActive
              ? () async {
                  await _realPresenceMode.deactivateMode();
                  setState(() {});
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            fixedSize: Size(buttonWidth, screenHeight * 0.06), // Define o tamanho fixo
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Desativar',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.neutral,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusIndicator(double screenHeight) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: screenHeight * 0.2,
      width: screenHeight * 0.2,
      decoration: BoxDecoration(
        color: _realPresenceMode.isActive
            ? Colors.greenAccent.withOpacity(0.8)
            : Colors.redAccent.withOpacity(0.8),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          _realPresenceMode.isActive ? Icons.check : Icons.close,
          color: AppColors.neutral,
          size: 50,
        ),
      ),
    );
  }

  Widget _buildSessionHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Histórico de Sessões',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.titlePrimary),
        ),
        const SizedBox(height: 10),
        ..._realPresenceMode.history.map((entry) {
          final String formattedDate =
              "${entry.date.day.toString().padLeft(2, '0')}/"
              "${entry.date.month.toString().padLeft(2, '0')}/"
              "${entry.date.year}";
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Tempo: ${entry.formattedTime} | Pontos: ${entry.points}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.titlePrimary),
                  ),
                ),
                Text(
                  formattedDate,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondarylight,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}
