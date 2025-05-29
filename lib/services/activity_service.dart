// Novo arquivo para consumir as rotas do backend de atividades
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:two/presentation/screens/baseScreen/activities/reproduction/reproduction_screen.dart';

class ActivityService {
  static String baseUrl = dotenv.env['API_ACTIVITY_URL']!;

  static Future<List<Atividade>> fetchActivitiesByCategoria(String categoria) async {
    final response = await http.get(Uri.parse('$baseUrl/activities?categoria=$categoria'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Atividade.fromJson(json)).toList();
    }
    return [];
  }

  static Future<List<Atividade>> fetchSavedActivities(String categoria) async {
    final response = await http.get(Uri.parse('$baseUrl/saved?categoria=$categoria'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Atividade.fromJson(json)).toList();
    }
    return [];
  }

  static Future<void> saveActivity(String activityId) async {
    await http.post(
      Uri.parse('$baseUrl/save'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'activityId': activityId}),
    );
  }

  static Future<void> unsaveActivity(String activityId) async {
    await http.post(
      Uri.parse('$baseUrl/unsave'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'activityId': activityId}),
    );
  }

  static Future<void> markAsDone(String activityId) async {
    await http.post(
      Uri.parse('$baseUrl/done'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'activityId': activityId}),
    );
  }
}
