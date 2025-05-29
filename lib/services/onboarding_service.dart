import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OnboardingService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> markSeen() async {
    await _storage.write(key: 'seen_onboarding', value: 'true');
  }

  Future<bool> hasSeen() async {
    final seen = await _storage.read(key: 'seen_onboarding');
    return seen == 'true';
  }
}
