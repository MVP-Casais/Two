import 'package:flutter/material.dart';
import 'package:two/services/email_verification_service.dart';

class EmailVerificationProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  bool codeSent = false;
  bool verified = false;

  Future<bool> sendCode(String email) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    final result = await EmailVerificationService.sendCode(email);
    isLoading = false;
    codeSent = result;
    if (!result) {
      errorMessage = 'Erro ao enviar código para o e-mail.';
    }
    notifyListeners();
    return result;
  }

  Future<bool> verifyCode(String email, String code) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    final result = await EmailVerificationService.verifyCode(email, code);
    isLoading = false;
    verified = result;
    if (!result) {
      errorMessage = 'Código inválido.';
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
