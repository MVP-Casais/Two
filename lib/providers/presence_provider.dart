import 'package:flutter/material.dart';
import 'package:two/presentation/screens/baseScreen/presenceMode/realPresenceMode/real_presence_mode.dart';

class PresenceProvider extends ChangeNotifier {
  final RealPresenceMode realPresenceMode = RealPresenceMode();

  Future<void> fetchHistory(int casalId) async {
    await realPresenceMode.fetchHistory(casalId);
    notifyListeners();
  }

  Future<void> saveSession({required int casalId}) async {
    await realPresenceMode.deactivateMode(casalId: casalId);
    notifyListeners();
  }

  void setSessionDuration(int seconds) {
    realPresenceMode.setSessionDuration(seconds);
    notifyListeners();
  }
}
