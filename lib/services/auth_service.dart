import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:two/services/http_service.dart';
import 'package:two/services/token_service.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final String baseUrl = dotenv.env['API_BASE_URL']!;
  static final String baseUrlProfile = dotenv.env['API_USERS_URL']!;
  static final TokenService _tokenService = TokenService();

  static Future<Map<String, dynamic>> register({
    required String nome,
    required String username,
    required String email,
    required String senha,
    required String genero,
  }) async {
    return await HttpService.post(
      url: '$baseUrl/register',
      body: {
        'nome': nome,
        'username': username,
        'email': email,
        'senha': senha,
        'genero': genero,
      },
    );
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String senha,
  }) async {
    final result = await HttpService.post(
      url: '$baseUrl/login',
      body: {
        'email': email,
        'senha': senha,
      },
    );

    if (result['statusCode'] == 200 && result['body']['token'] != null) {
      await _tokenService.saveToken(result['body']['token']);
    }

    return result;
  }

  static Future<Map<String, dynamic>> loginWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
        serverClientId: dotenv.env['GOOGLE_CLIENT_ID'],
      );
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return {
          'statusCode': 400,
          'body': {'error': 'Login cancelado pelo usuário.'},
        };
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        return {
          'statusCode': 400,
          'body': {'error': 'Token do Google não encontrado. Verifique o clientId e a configuração do OAuth no Google Cloud.'},
        };
      }

      final result = await HttpService.post(
        url: '$baseUrl/login-google',
        body: {'idToken': idToken},
      );

      if (result['statusCode'] == 200 && result['body']['token'] != null) {
        await _tokenService.saveToken(result['body']['token']);
      }

      return result;
    } catch (e) {
      return {
        'statusCode': 500,
        'body': {'error': 'Erro ao fazer login com Google: $e'},
      };
    }
  }

  static Future<Map<String, dynamic>> getProfile() async {
    final token = await _tokenService.getToken();

    if (token == null) {
      return {
        'statusCode': 401,
        'body': {'error': 'Token não encontrado.'},
      };
    }

    return await HttpService.get(
      url: baseUrlProfile,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }

  static Future<void> removerToken() async {
    await _tokenService.deleteToken();
  }
}


