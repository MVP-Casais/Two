import 'package:flutter/material.dart';
import '../services/casais_service.dart';

class CasaisProvider extends ChangeNotifier {
  List<dynamic> _casais = [];
  bool _loading = false;
  String? _error;

  List<dynamic> get casais => _casais;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> fetchCasais() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _casais = await CasaisService.fetchCasais();
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }
}
