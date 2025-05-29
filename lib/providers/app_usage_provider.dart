import 'package:flutter/material.dart';
import 'package:two/services/app_usage_service.dart';

class AppUsageProvider extends ChangeNotifier {
  Map<String, int> _weeklyUsage = {};

  Map<String, int> get weeklyUsage => _weeklyUsage;

  Future<void> fetchWeeklyUsage() async {
    final usage = await AppUsageService.getWeeklyUsage();
    _weeklyUsage = usage;
    notifyListeners();
  }
}
