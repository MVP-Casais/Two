import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:two/core/themes/app_colors.dart';
import 'package:two/services/token_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:two/services/connection_service.dart';

class PlannerService {
  static final String baseUrl = dotenv.env['API_PLANNER_URL']!;
  static final TokenService _tokenService = TokenService();

  // Ajuste: converte nome da categoria para cor, incluindo todas as cores possíveis
  static Color _categoryToColor(String category) {
    final Map<String, Color> categoryColorMap = {
      'série/filme': AppColors.categoryOne,
      'jantar': AppColors.categoryTwo,
      'atividade física': AppColors.categoryThree,
      'trabalho': AppColors.categoryFour,
      'família': AppColors.categoryFive,
      'encontro': AppColors.categorySix,
      'estudo': AppColors.categorySeven,
      'lazer': AppColors.categoryEight,
      'outros': AppColors.categoryNine,
      'viagem': AppColors.categoryTen,
    };

    // Busca por nome exato (case-insensitive)
    final lower = category.toLowerCase();
    if (categoryColorMap.containsKey(lower)) {
      return categoryColorMap[lower]!;
    }

    // Se não for padrão, tenta converter cor hex salva no backend (caso usuário adicionou)
    // Espera que o backend salve a cor como string hex, ex: "#FF0000"
    if (category.startsWith('#') && category.length == 7) {
      try {
        return Color(int.parse(category.replaceFirst('#', '0xff')));
      } catch (_) {}
    }

    // Se não encontrar, retorna cor padrão
    return Colors.grey;
  }

  static Future<Map<DateTime, List<Map<String, dynamic>>>?> fetchEvents() async {
    final token = await _tokenService.getToken();
    // Busca o coupleId do backend
    final coupleId = await ConnectionService.getConnectedCoupleId();
    if (coupleId == null) return null;
    final url = Uri.parse('$baseUrl?coupleId=$coupleId');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      Map<DateTime, List<Map<String, dynamic>>> events = {};
      for (var item in data) {
        final date = DateTime.parse(item['dataEvento']);
        final category = item['categoria'] ?? '';
        events[DateTime(date.year, date.month, date.day)] ??= [];
        events[DateTime(date.year, date.month, date.day)]!.add({
          "id": item['id'],
          "title": item['nomeEvento'],
          "description": item['descricao'],
          "startTime": item['horaInicio'],
          "endTime": item['horaTermino'],
          "category": category,
          "categoryColor": _categoryToColor(category),
        });
      }
      return events;
    }
    return null;
  }

  static Future<bool> createEvent({
    required String title,
    required String description,
    required String startTime,
    required String endTime,
    required String category,
    required Color categoryColor,
    required DateTime date,
    required int coupleId,
  }) async {
    final token = await _tokenService.getToken();
    final url = Uri.parse(baseUrl);
    final String dataEvento = "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "nomeEvento": title,
        "descricao": description,
        "dataEvento": dataEvento,
        "horaInicio": startTime,
        "horaTermino": endTime,
        "categoria": category,
        "coupleId": coupleId,
      }),
    );
    if (response.statusCode != 201) {
      print('Erro ao criar evento: ${response.body}');
      return false;
    }
    return true;
  }

  static Future<bool> updateEvent({
    required Map<String, dynamic> event,
    required String title,
    required String description,
    required String startTime,
    required String endTime,
    required String category,
    required Color categoryColor,
  }) async {
    final token = await _tokenService.getToken();
    final url = Uri.parse('$baseUrl/event/${event['id']}');
    final response = await http.put(url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "nomeEvento": title,
        "descricao": description,
        "horaInicio": startTime,
        "horaTermino": endTime,
        "categoria": category,
      }),
    );
    return response.statusCode == 200;
  }

  static Future<bool> deleteEvent(Map<String, dynamic> event) async {
    final token = await _tokenService.getToken();
    final url = Uri.parse('$baseUrl/event/${event['id']}');
    final response = await http.delete(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });
    return response.statusCode == 200;
  }
}
