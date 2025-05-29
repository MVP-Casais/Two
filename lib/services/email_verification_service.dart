import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class EmailVerificationService {
  static String baseUrl = dotenv.env['API_VERIFICATION_URL']!;

  static Future<bool> sendCode(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/send'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    return response.statusCode == 200;
  }

  static Future<bool> verifyCode(String email, String code) async {
    final response = await http.post(
      Uri.parse('$baseUrl/verify'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'code': code}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['verified'] == true;
    }
    return false;
  }
}
