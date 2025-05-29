import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:two/providers/connection_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:two/services/token_service.dart';

class ConnectionService {
  static String baseUrl = dotenv.env['API_CONNECTION_URL']!;

  static Future<Partner> connect() async {
    final response = await http.post(
      Uri.parse('$baseUrl/request'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "partnerId": 2
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Partner(
        name: data['name'] ?? "Parceiro",
        username: data['username']!,
        avatarUrl: data['avatarUrl']!
      );
    } else {
      throw Exception('Erro ao conectar parceiro');
    }
  }

  static Future<void> disconnect() async {
    final token = await TokenService().getToken();
    await http.delete(
      Uri.parse('$baseUrl/disconnect'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  static Future<bool> getConnectionStatus() async {
    final response = await http.get(Uri.parse('$baseUrl/status'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['status'] == 'conectado';
    }
    return false;
  }

  static Future<Partner?> sendConnectionRequest(String username) async {
    final token = await TokenService().getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/request'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "username": username
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      // Corrija para aceitar tanto 'username' quanto 'name' e 'avatarUrl'
      if (data is Map && data['username'] != null) {
        return Partner(
          name: data['name'] ?? "Parceiro",
          username: data['username'],
          avatarUrl: data['avatarUrl'] ?? '',
          coupleId: data['coupleId'],
        );
      }
      // Caso backend retorne erro, mostre mensagem
      if (data is Map && data['error'] != null) {
        throw Exception(data['error']);
      }
      return null;
    } else {
      // Mostra mensagem de erro detalhada do backend
      try {
        final data = jsonDecode(response.body);
        if (data is Map && data['error'] != null) {
          throw Exception(data['error']);
        }
      } catch (_) {}
      throw Exception('Erro ao enviar convite: ${response.statusCode}');
    }
  }

  static Future<List<String>> searchUsernames(String query) async {
    final token = await TokenService().getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/search?username=$query'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        return data.map<String>((e) => e.toString()).toList();
      }
    }
    return [];
  }

  static Future<int?> getConnectedCoupleId() async {
    final token = await TokenService().getToken();
    final response = await http.get(
      Uri.parse('${baseUrl}/connected-couple'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['coupleId'];
    }
    return null;
  }

  // Novo: busca o parceiro conectado do backend ao iniciar o app
  static Future<Partner?> getCurrentPartner() async {
    final token = await TokenService().getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/connected-couple'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Você pode retornar mais dados do parceiro se o backend fornecer
      if (data['partner'] != null) {
        return Partner(
          name: data['partner']['name'] ?? '',
          username: data['partner']['username'] ?? '',
          avatarUrl: data['partner']['avatarUrl'] ?? '',
          coupleId: data['coupleId'],
        );
      }
      // Caso só venha o coupleId, busque o parceiro pelo username se necessário
    }
    return null;
  }

  /// Busca os dados do parceiro do casal pelo coupleId (deve ser implementado no backend)
  static Future<Partner?> getPartnerByCoupleId(int coupleId) async {
    // Exemplo de chamada para o endpoint do backend que retorna o parceiro do casal
    // Ajuste a URL conforme sua API
    final token = await TokenService().getToken();
    final url = Uri.parse('${dotenv.env['API_CONNECTION_URL']}/partner-by-couple/$coupleId');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data != null && data['partner'] != null) {
        return Partner.fromMap(data['partner']);
      }
    }
    return null;
  }
}
