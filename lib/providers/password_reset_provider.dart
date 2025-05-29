import 'package:flutter/material.dart';
import 'package:two/services/password_reset_service.dart';

class PasswordResetProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  bool codeSent = false;
  bool verified = false;

  Future<bool> sendCode(String email) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    final result = await PasswordResetService.sendCode(email);
    isLoading = false;
    codeSent = result;
    if (!result) {
      errorMessage = 'Erro ao enviar código de recuperação para o e-mail.';
    }
    notifyListeners();
    return result;
  }

  Future<bool> verifyCode(String email, String code) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    final result = await PasswordResetService.verifyCode(email, code);
    isLoading = false;
    verified = result;
    if (!result) {
      errorMessage = 'Código inválido.';
    }
    notifyListeners();
    return result;
  }

  Future<bool> resetPassword(String email, String newPassword) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    final result = await PasswordResetService.resetPassword(email, newPassword);
    isLoading = false;
    if (!result) {
      errorMessage = 'Erro ao redefinir a senha.';
    }
    notifyListeners();
    return result;
  }

  void reset() {
    isLoading = false;
    errorMessage = null;
    codeSent = false;
    verified = false;
    notifyListeners();
  }
}
