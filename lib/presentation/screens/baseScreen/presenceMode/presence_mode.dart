import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:confetti/confetti.dart';
import 'package:two/core/themes/app_colors.dart';
import 'package:two/presentation/screens/baseScreen/presenceMode/realPresenceMode/real_presence_mode.dart';
import 'package:two/presentation/widgets/custom_button.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:provider/provider.dart';
import 'package:two/providers/presence_provider.dart';
import 'package:two/services/connection_service.dart';

class PresenceModeScreen extends StatefulWidget {
  const PresenceModeScreen({super.key});

  @override
  _PresenceModeScreenState createState() => _PresenceModeScreenState();
}

@pragma('vm:entry-point')
class _PresenceModeScreenState extends State<PresenceModeScreen>
    with SingleTickerProviderStateMixin {
  final RealPresenceMode _realPresenceMode = RealPresenceMode();
  Timer? _timer;
  Duration _selectedDuration = const Duration(hours: 1); // Agora é Duration
  late AnimationController _animationController;
  late ConfettiController _confettiController;
  bool _isTimeSelected = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: _selectedDuration,
    )..addListener(() async {
        if (mounted) setState(() {});
        if (_animationController.isCompleted && _realPresenceMode.isActive) {
          await _handleSessionComplete();
        }
      });

    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));

    _realPresenceMode.timeTracker.onTick = () {
      if (mounted) setState(() {});
    };

    _initializeBackgroundService();

    final service = FlutterBackgroundService();
    service.on('tick').listen((event) {
      final remaining = event?['remaining'] ?? 0;
      setState(() {
        _realPresenceMode.timeTracker.totalSeconds =
            remaining + _realPresenceMode.timeTracker.elapsedSeconds;
      });
      if (remaining == 0 && _realPresenceMode.isActive) {
        _handleSessionComplete();
      }
    });

    service.on('sessionComplete').listen((event) {
      _handleSessionComplete();
    });

    Future.microtask(() async {
      final casalId = await ConnectionService.getConnectedCoupleId();
      if (!mounted) return;
      if (casalId != null) {
        final presenceProvider =
            Provider.of<PresenceProvider>(context, listen: false);
        await presenceProvider.fetchHistory(casalId);
        if (!mounted) return;
      }
    });
  }

  Future<void> _handleSessionComplete() async {
    if (_realPresenceMode.isActive) {
      await _realPresenceMode.deactivateMode();
      _animationController.reset();
      _confettiController.play();
      await _showCompletionDialog(_realPresenceMode.currentPoints);
      setState(() {
        _isTimeSelected = false;
      });
    }
  }

  Future<void> _initializeBackgroundService() async {
    final service = FlutterBackgroundService();
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: _onBackgroundServiceStart,
        isForegroundMode: true,
        autoStart: false,
      ),
      iosConfiguration: IosConfiguration(
        onForeground: _onBackgroundServiceStart,
        autoStart: false,
      ),
    );
  }

  Future<void> startTimerInBackground(Duration duration) async {
    final service = FlutterBackgroundService();
    if (!(await service.isRunning())) {
      await service.startService();
    }
    service.invoke('startSession', {'duration': duration.inMinutes});
  }

  Future<void> stopTimerInBackground() async {
    final service = FlutterBackgroundService();
    if (await service.isRunning()) {
      service.invoke('stopSession');
    }
  }

  @pragma('vm:entry-point')
  static void _onBackgroundServiceStart(ServiceInstance service) {
    DartPluginRegistrant.ensureInitialized();

    int remainingMinutes = 0;
    bool isSessionActive = false;

    service.on('startSession').listen((event) {
      remainingMinutes = event?['duration'] ?? 0;
      isSessionActive = true;
    });

    service.on('stopSession').listen((event) {
      isSessionActive = false;
      remainingMinutes = 0;
      service.invoke('stopped');
    });

    Timer.periodic(const Duration(minutes: 1), (timer) async {
      if (!isSessionActive || remainingMinutes <= 0) {
        if (remainingMinutes <= 0 && isSessionActive) {
          isSessionActive = false;
          service.invoke('sessionComplete');
        }
        return;
      }
      remainingMinutes--;
      service.invoke('tick', {'remaining': remainingMinutes});
    });
  }

  Future<void> _stopBackgroundService() async {
    final service = FlutterBackgroundService();
    if (await service.isRunning()) {
      service.invoke('stop');
    }
  }

  @override
  void dispose() {
    _stopBackgroundService();
    _timer?.cancel();
    _animationController.dispose();
    _confettiController.dispose();
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_isTimeSelected) _buildTimePicker(),
                if (_isTimeSelected) _buildProgressCircle(screenHeight),
                const SizedBox(height: 20),
                _buildActionButtons(screenWidth, screenHeight),
                const SizedBox(height: 40),
                _buildSessionHistory(),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              maxBlastForce: 20,
              minBlastForce: 5,
              emissionFrequency: 0.05,
              numberOfParticles: 30,
              gravity: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCircle(double screenHeight) {
    final double circleSize = MediaQuery.of(context).size.width * 0.8;
    int remaining = _realPresenceMode.timeTracker.totalSeconds -
        _realPresenceMode.timeTracker.elapsedSeconds;
    if (remaining < 0) remaining = 0;
    int hours = remaining ~/ 60;
    int minutes = remaining % 60;

    String timeText = '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}';

    return Container(
      height: circleSize,
      width: circleSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withAlpha(50),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: circleSize,
            width: circleSize,
            child: CircularProgressIndicator(
              value: 1.0 -
                  (_realPresenceMode.timeTracker.elapsedSeconds /
                      (_realPresenceMode.timeTracker.totalSeconds == 0
                          ? 1
                          : _realPresenceMode.timeTracker.totalSeconds)),
              strokeWidth: 16.0,
              backgroundColor: AppColors.neutral.withAlpha(50),
              valueColor:
                  AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                timeText,
                style: const TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.bold,
                  color: AppColors.titlePrimary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Tempo restante',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondarylight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimePicker() {
    return CupertinoTimerPicker(
      mode: CupertinoTimerPickerMode.hm,
      initialTimerDuration: _selectedDuration,
      onTimerDurationChanged: (Duration newDuration) {
        setState(() {
          _selectedDuration = newDuration;
          if (!_realPresenceMode.isActive) {
            _realPresenceMode
                .setSessionDuration(newDuration.inMinutes);
            _animationController.duration = newDuration;
            _animationController.reset();
          }
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
          onPressed: !_realPresenceMode.isActive
              ? () async {
                  if (!_isTimeSelected) {
                    setState(() {
                      _isTimeSelected = true;
                      _realPresenceMode
                          .setSessionDuration(_selectedDuration.inMinutes);
                      _animationController.duration = _selectedDuration;
                      _animationController.reset();
                    });
                  }
                  await _showDndSuggestionDialog();
                  await _realPresenceMode.activateMode();
                  await startTimerInBackground(_selectedDuration);
                  if (mounted) {
                    _animationController.reset();
                    _animationController.forward();
                  }
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            fixedSize: Size(buttonWidth, screenHeight * 0.06),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Começar',
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
                  _animationController.reset();
                  setState(() {
                    _isTimeSelected = false;
                  });
                  _confettiController.play();
                  await _showCompletionDialog(
                      _realPresenceMode.currentPoints);
                  await stopTimerInBackground();
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.success,
            fixedSize: Size(buttonWidth, screenHeight * 0.06),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Concluir',
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

  Widget _buildSessionHistory() {
    final presenceProvider = Provider.of<PresenceProvider>(context);
    final history = presenceProvider.realPresenceMode.history;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Histórico de Sessões',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.titlePrimary,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _realPresenceMode.history.clear();
                  });
                },
                child: const Text(
                  'Apagar histórico',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondarylight,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final entry = history[index];
                final String formattedDate =
                    "${entry.date.day.toString().padLeft(2, '0')}/${entry.date.month.toString().padLeft(2, '0')}/${entry.date.year}";
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      'Tempo: ${entry.formattedTime}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.titlePrimary,
                      ),
                    ),
                    subtitle: Text(
                      'Pontos: ${entry.points}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondarylight,
                      ),
                    ),
                    trailing: Text(
                      formattedDate,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondarylight,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showCompletionDialog(int points) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Parabéns!',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.titlePrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Icon(Icons.favorite, color: AppColors.primary, size: 48),
                const SizedBox(height: 12),
                const Text(
                  'Vocês passaram um tempo de qualidade juntos',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondarylight,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Pontos ganhos: $points',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.titlePrimary,
                  ),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  onPressed: () => Navigator.of(context).pop(),
                  text: "Fechar",
                  backgroundColor: AppColors.primary,
                  textColor: AppColors.neutral,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showDndSuggestionDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Ative o "Não Perturbe"',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.titlePrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Icon(Icons.notifications_off,
                    color: AppColors.primary, size: 48),
                const SizedBox(height: 12),
                const Text(
                  'Para aproveitar melhor o momento, ative o modo "Não Perturbe" no seu celular. Isso ajuda a evitar interrupções e focar totalmente na experiência.',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondarylight,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                CustomButton(
                  onPressed: () => Navigator.of(context).pop(),
                  text: "Fechar",
                  backgroundColor: AppColors.primary,
                  textColor: AppColors.neutral,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
