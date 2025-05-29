import 'package:flutter/material.dart';

class RegisterProvider extends ChangeNotifier {
  String? nome = '';
  String? username = '';
  String? email = '';
  String? senha = '';
  String? genero = '';

  void setNome(String? value) {
    nome = value;
    notifyListeners();
  }

  void setUsername(String? value) {
    username = value;
    notifyListeners();
  }

  void setEmail(String? value) {
    email = value;
    notifyListeners();
  }

  void setSenha(String? value) {
    senha = value;
    notifyListeners();
  }

  void setGenero(String? value) {
    genero = value;
    notifyListeners();
  }

  void reset() {
    nome = '';
    username = '';
    email = '';
    senha = '';
    genero = '';
    notifyListeners();
  }
}
