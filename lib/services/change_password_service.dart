import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:two/services/http_service.dart';
import 'package:two/services/token_service.dart';

class ChangePasswordService {
  static final String baseUrl = dotenv.env['API_USERS_URL']!;

  static Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final token = await TokenService().getToken();
    if (token == null) {
      return {
        'statusCode': 401,
        'body': {'error': 'Token não encontrado.'},
      };
    }

    return await HttpService.put(
      url: "$baseUrl/change-password",
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      },
    );
  }
}
