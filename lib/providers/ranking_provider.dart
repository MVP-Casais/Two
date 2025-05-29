import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RankingProvider extends ChangeNotifier {
    static String baseUrl = dotenv.env['API_RANKING_URL']!;

  List<dynamic>? _ranking;
  bool _loading = false;
  String? _error;

  List<dynamic>? get ranking => _ranking ?? [];
  bool get loading => _loading;
  String? get error => _error;

  Future<void> fetchRanking() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        _ranking = json.decode(response.body);
      } else {
        _error = 'Erro ao buscar ranking';
      }
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }
}
