import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:two/providers/profile_provider.dart';
import 'package:two/services/token_service.dart';
import 'package:two/services/http_service.dart';

enum Status { idle, loading, success, error }

class UpdateProfileProvider extends ChangeNotifier {
  String? nome;
  String? username;
  String? genero;
  String? imageUrl;

  Status _status = Status.idle;
  Status get status => _status;

  String? errorMessage;

  void setNome(String? newNome) {
    nome = newNome;
    notifyListeners();
  }

  void setUsername(String? newUsername) {
    username = newUsername;
    notifyListeners();
  }

  void setGenero(String? newGenero) {
    genero = newGenero;
    notifyListeners();
  }

  void setImageUrl(String? newImageUrl) {
    imageUrl = newImageUrl;
    notifyListeners();
  }

  void loadFromProfileProvider(ProfileProvider profile) {
    nome = profile.nome;
    username = profile.username;
    genero = profile.genero;
    imageUrl = profile.imageUrl;
    notifyListeners();
  }

  Future<bool> updateProfile({
    required String nome,
    required String username,
    required String genero,
    File? imageFile,
  }) async {
    if (nome.isEmpty || username.isEmpty || genero.isEmpty) {
      _status = Status.error;
      errorMessage = 'Preencha todos os campos obrigatórios';
      notifyListeners();
      return false;
    }

    _status = Status.loading;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await ProfileService.updateProfile(
        nome: nome,
        username: username,
        genero: genero,
        imageFile: imageFile,
      );

      if (result['statusCode'] == 200) {
        final data = result['body'];
        this.nome = data['nome'] ?? nome;
        this.username = data['username'] ?? username;
        this.genero = data['genero'] ?? genero;
        this.imageUrl = data['foto_perfil'] ?? imageUrl;

        _status = Status.success;
        notifyListeners();
        return true;
      } else {
        _status = Status.error;
        errorMessage = result['body']['error']?.toString() ??
            result['body']['message']?.toString() ??
            'Erro ao atualizar perfil';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = Status.error;
      errorMessage = 'Erro na conexão: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }
}

class ProfileService {
  static final TokenService _tokenService = TokenService();
  static final String baseUrlProfile = dotenv.env['API_USERS_URL']!;

  static Future<Map<String, dynamic>> fetchProfile() async {
    final token = await _tokenService.getToken();
    if (token == null) {
      return {
        'statusCode': 401,
        'body': {'error': 'Token não encontrado.'},
      };
    }

    final headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };

    final response = await HttpService.get(
      url: baseUrlProfile,
      headers: headers,
    );
    return response;
  }

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

    final headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };

    final fields = {
      'nome': nome,
      'username': username,
      'genero': genero,
    };

    // Usa o HttpService.putMultipart para enviar o arquivo e os campos
    final result = await HttpService.putMultipart(
      url: baseUrlProfile,
      fields: fields,
      headers: headers,
      file: imageFile,
      fileFieldName: 'foto_perfil',
    );

    return result;
  }
}
