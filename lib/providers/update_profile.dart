import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:two/services/token_service.dart';
import 'dart:convert';

class ProfileService {
  static final String baseUrlProfile = dotenv.env['API_USERS_URL']!;
  static final TokenService _tokenService = TokenService();

  static Future<Map<String, dynamic>> updateProfile({
    required String nome,
    required String username,
    required String genero,
    File? imageFile,
  }) async {
    final token = await _tokenService.getToken();
    if (token == null) {
      return {
        'statusCode': 401,
        'body': {'error': 'Token não encontrado.'},
      };
    }

    try {
      var uri = Uri.parse('$baseUrlProfile/me');
      var request = http.MultipartRequest('PUT', uri);
      
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';
      
      request.fields['nome'] = nome;
      request.fields['username'] = username;
      request.fields['genero'] = genero;

      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image', 
            imageFile.path,
            filename: 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg',
          ),
        );
      }

      var streamedResponse = await request.send().timeout(Duration(seconds: 15));
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return {'statusCode': 200, 'body': body};
      } else {
        final body = jsonDecode(response.body);
        return {
          'statusCode': response.statusCode, 
          'body': body ?? {'error': 'Erro desconhecido'}
        };
      }
    } catch (e) {
      return {
        'statusCode': 500,
        'body': {'error': 'Erro na conexão: ${e.toString()}'},
      };
    }
  }
}