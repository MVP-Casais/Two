import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:io';

class HttpService {
  static const Duration timeoutDuration = Duration(seconds: 30);

  static Future<Map<String, dynamic>> post({
    required String url,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: headers ?? {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(timeoutDuration);

      return _buildResponse(response);
    } on TimeoutException {
      return _timeoutResponse();
    } catch (e) {
      return _errorResponse(e);
    }
  }

  static Future<Map<String, dynamic>> get({
    required String url,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http
          .get(
            Uri.parse(url),
            headers: headers ?? {'Content-Type': 'application/json'},
          )
          .timeout(timeoutDuration);

      return _buildResponse(response);
    } on TimeoutException {
      return _timeoutResponse();
    } catch (e) {
      return _errorResponse(e);
    }
  }

  static Future<Map<String, dynamic>> put({
    required String url,
    required Map<String, String> headers,
    required Map<String, dynamic> body,
  }) async {
    try {
      final uri = Uri.parse(url);
      final response = await http
          .put(uri, headers: headers, body: jsonEncode(body))
          .timeout(timeoutDuration);

      return _buildResponse(response);
    } on TimeoutException {
      return _timeoutResponse();
    } catch (e) {
      return _errorResponse(e);
    }
  }

  static Future<Map<String, dynamic>> putMultipart({
    required String url,
    required Map<String, String> fields,
    Map<String, String>? headers,
    File? file,
    String fileFieldName = 'image',
  }) async {
    try {
      var uri = Uri.parse(url);
      var request = http.MultipartRequest('PUT', uri);

      if (headers != null) {
        request.headers.addAll(headers);
      }

      request.fields.addAll(fields);

      if (file != null) {
        var stream = http.ByteStream(file.openRead());
        var length = await file.length();
        var multipartFile = http.MultipartFile(fileFieldName, stream, length,
            filename: file.path.split('/').last);
        request.files.add(multipartFile);
      }

      final streamedResponse = await request.send().timeout(timeoutDuration);

      final response = await http.Response.fromStream(streamedResponse);

      return _buildResponse(response);
    } on TimeoutException {
      return _timeoutResponse();
    } catch (e) {
      return _errorResponse(e);
    }
  }

  static Future<Map<String, dynamic>> delete({
    required String url,
    required Map<String, String> headers,
    Map<String, dynamic>? body,
  }) async {
    try {
      final uri = Uri.parse(url);
      final request = http.Request('DELETE', uri)..headers.addAll(headers);

      if (body != null) {
        request.body = jsonEncode(body);
      }

      final streamedResponse = await request.send().timeout(timeoutDuration);
      final response = await http.Response.fromStream(streamedResponse);

      return _buildResponse(response);
    } on TimeoutException {
      return _timeoutResponse();
    } catch (e) {
      return _errorResponse(e);
    }
  }

  static Map<String, dynamic> _buildResponse(http.Response response) {
    try {
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      return {'statusCode': response.statusCode, 'body': decoded};
    } catch (e) {
      return {
        'statusCode': response.statusCode,
        'body': {'error': 'Resposta inválida: ${response.body}'}
      };
    }
  }

  static Map<String, dynamic> _timeoutResponse() {
    return {
      'statusCode': 408,
      'body': {'error': 'Tempo de requisição excedido.'},
    };
  }

  static Map<String, dynamic> _errorResponse(Object e) {
    return {
      'statusCode': 500,
      'body': {'error': 'Erro de conexão: $e'},
    };
  }
}
