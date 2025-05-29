import 'package:flutter/material.dart';
import 'package:two/services/auth_service.dart';

class LoginProvider extends ChangeNotifier {
  String? email = '';
  String? senha = '';
  bool isLoading = false;
  String? errorMessage;

  void setEmail(String? value) {
    email = value;
    notifyListeners();
  }

  void setSenha(String? value) {
    senha = value;
    notifyListeners();
  }

  Future<bool> login() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await AuthService.login(
      email: email ?? '',
      senha: senha ?? '',
    );

    isLoading = false;
    if (result['statusCode'] == 200) {
      notifyListeners();
      return true;
    } else {
      errorMessage = result['body']['error'] ?? 'Erro ao fazer login';
      notifyListeners();
      return false;
    }
  }

  void reset() {
    email = '';
    senha = '';
    errorMessage = null;
    isLoading = false;
    notifyListeners();
  }
}
