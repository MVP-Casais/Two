import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  String? nome;
  String? email;
  String? username;
  String? genero;
  String? _imageUrl;
  String? get imageUrl => _imageUrl;

  int? idCasal;

  void setIdCasal(int? value) {
    idCasal = value;
    notifyListeners();
  }

  void setImageUrl(String? url) {
    _imageUrl = url;
    notifyListeners();
  }

  void setNome(String? value) {
    nome = value;
    notifyListeners();
  }

  void setEmail(String? value) {
    email = value;
    notifyListeners();
  }

  void setUsername(String? value) {
    username = value;
    notifyListeners();
  }

  void setGenero(String? value) {
    genero = value;
    notifyListeners();
  }

  void reset() {
    nome = null;
    email = null;
    username = null;
    genero = null;
    notifyListeners();
  }
}
