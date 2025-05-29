import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class PasswordResetService {
  static String baseUrl = dotenv.env['API_RESET_URL']!;

  static Future<bool> sendCode(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/send-code'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    return response.statusCode == 200;
  }

  static Future<bool> verifyCode(String email, String code) async {
    final response = await http.post(
      Uri.parse('$baseUrl/verify-code'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'code': code}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['verified'] == true;
    }
    return false;
  }

  static Future<bool> resetPassword(String email, String newPassword) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reset'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'newPassword': newPassword}),
    );
    return response.statusCode == 200;
  }
}
