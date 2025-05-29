import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:two/providers/memories_provider.dart';
import 'package:two/services/token_service.dart';
import 'package:two/services/connection_service.dart'; // Importante para pegar o coupleId correto

class MemoriesService {
  static final String baseUrl = dotenv.env['API_MEMORIES_URL']!;
  static final TokenService _tokenService = TokenService();

  static Future<List<MemoryPost>> fetchMemories() async {
    final token = await _tokenService.getToken();
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((item) => MemoryPost(
        id: (item['id'] is int) ? item['id'] : int.tryParse(item['id']?.toString() ?? '') ?? 0,
        title: item['title'],
        description: item['description'],
        imageUrl: item['imageUrl'],
        date: item['date'],
      )).toList();
    }
    return [];
  }

  static Future<MemoryPost?> addMemory({
    required String title,
    required String description,
    required File imageFile,
  }) async {
    final token = await _tokenService.getToken();
    // Busque o coupleId correto do backend antes de enviar a memória
    final coupleId = await ConnectionService.getConnectedCoupleId();
    if (coupleId == null) {
      print('Erro: Não foi possível obter o coupleId do casal conectado.');
      return null;
    }

    final uri = Uri.parse(baseUrl);
    final request = http.MultipartRequest('POST', uri);

    request.headers['Authorization'] = 'Bearer $token';

    request.fields['titulo'] = title;
    request.fields['descricao'] = description;
    request.fields['coupleId'] = coupleId.toString(); // Sempre envie o coupleId correto

    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        filename: 'memory_${DateTime.now().millisecondsSinceEpoch}.jpg',
      ),
    );

    print('Enviando memória: ${request.fields}');

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    print('Status code memória: ${response.statusCode}');
    print('Body memória: ${response.body}');

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return MemoryPost(
        id: (data['id'] is int) ? data['id'] : int.tryParse(data['id']?.toString() ?? '') ?? 0,
        title: data['title'],
        description: data['description'],
        imageUrl: data['imageUrl'],
        date: data['date'],
      );
    } else {
      print('Erro ao adicionar memória: ${response.body}');
    }
    return null;
  }

  static Future<MemoryPost?> editMemory({
    required int id,
    required String title,
    required String description,
  }) async {
    final token = await _tokenService.getToken();
    // Busque o coupleId correto do backend antes de editar a memória
    final coupleId = await ConnectionService.getConnectedCoupleId();
    if (coupleId == null) {
      print('Erro: Não foi possível obter o coupleId do casal conectado.');
      return null;
    }
    final uri = Uri.parse('$baseUrl/$id');
    final response = await http.put(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "titulo": title,
        "descricao": description,
        "coupleId": coupleId, // Sempre envie o coupleId correto
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return MemoryPost(
        id: (data['id'] is int) ? data['id'] : int.tryParse(data['id']?.toString() ?? '') ?? 0,
        title: data['title'],
        description: data['description'],
        imageUrl: data['imageUrl'],
        date: data['date'],
      );
    }
    return null;
  }

  static Future<bool> deleteMemory({required int id}) async {
    final token = await _tokenService.getToken();
    final uri = Uri.parse('$baseUrl/$id');
    final response = await http.delete(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    return response.statusCode == 200;
  }
}
