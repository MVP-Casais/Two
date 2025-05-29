import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class CasaisService {
  static String baseUrl = dotenv.env['API_RANKING_URL']!;

  static Future<List<dynamic>> fetchCasais() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erro ao buscar casais');
    }
  }
}
