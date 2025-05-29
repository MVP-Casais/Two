import 'package:flutter/material.dart';
import 'package:two/services/change_password_service.dart';

enum ChangePasswordStatus { idle, loading, success, error }

class ChangePasswordProvider extends ChangeNotifier {
  ChangePasswordStatus _status = ChangePasswordStatus.idle;
  ChangePasswordStatus get status => _status;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    _status = ChangePasswordStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await ChangePasswordService.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );

    if (result['statusCode'] == 200) {
      _status = ChangePasswordStatus.success;
      notifyListeners();
      return true;
    } else {
      _status = ChangePasswordStatus.error;
      _errorMessage = result['body']['error'] ?? 'Erro ao alterar senha.';
      notifyListeners();
      return false;
    }
  }
}
