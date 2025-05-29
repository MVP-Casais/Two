import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AppUsageService {
  static String baseUrl = dotenv.env['API_GRAPH_URL']!; 
  static Future<Map<String, int>> getWeeklyUsage() async {
    final response = await http.get(Uri.parse('$baseUrl/daily'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final Map<String, int> result = {
        "Seg": 0, "Ter": 0, "Qua": 0, "Qui": 0, "Sex": 0, "Sáb": 0, "Dom": 0
      };
      for (final item in data) {
        final date = DateTime.parse(item['date']);
        final weekday = date.weekday; 
        final dias = ["Seg", "Ter", "Qua", "Qui", "Sex", "Sáb", "Dom"];
        final count = item['count'];
        if (count != null) {
          // Garante que count é int
          result[dias[weekday - 1]] = (result[dias[weekday - 1]] ?? 0) + (count is int ? count : (count as num).toInt());
        }
      }
      return result;
    }
    return {};
  }
}
