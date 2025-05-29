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

  // Novo: gerar código de conexão
  static Future<String?> generateConnectionCode() async {
    final token = await TokenService().getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/generate-code'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['code']?.toString();
    }
    return null;
  }

  // Novo: conectar usando código
  static Future<String?> connectWithCode(String code) async {
    final token = await TokenService().getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/connect-with-code'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({"code": code}),
    );
    if (response.statusCode == 200) {
      return null; // sucesso
    }
    try {
      final data = jsonDecode(response.body);
      if (data is Map && data['error'] != null) {
        return data['error'];
      }
    } catch (_) {}
    return 'Erro ao conectar com código.';
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
      // O campo retornado é coupleId (id da tabela couples)
      return data['coupleId'];
    }
    return null;
  }

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
      if (data['partner'] != null) {
        return Partner(
          name: data['partner']['name'] ?? '',
          username: data['partner']['username'] ?? '',
          avatarUrl: data['partner']['avatarUrl'] ?? '',
          coupleId: data['coupleId'],
        );
      }
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
