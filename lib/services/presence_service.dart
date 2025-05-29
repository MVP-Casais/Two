import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:two/presentation/screens/baseScreen/presenceMode/realPresenceMode/real_presence_mode.dart';

class PresenceService {
  static String baseUrl = dotenv.env['API_PRESENCE_URL']!;

  static Future<void> saveSession(PresenceSession session) async {
    await http.post(
      Uri.parse('$baseUrl/start'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(session.toJson()),
    );
  }

  static Future<List<PresenceSession>> fetchHistory(int casalId) async {
    final response = await http.get(Uri.parse('$baseUrl/history?casal_id=$casalId'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => PresenceSession.fromJson(e)).toList();
    }
    return [];
  }
}
