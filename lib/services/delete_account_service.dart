import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:two/services/http_service.dart';
import 'package:two/services/token_service.dart';

class DeleteAccountService {
  static final String baseUrl = dotenv.env['API_USERS_URL']!;

  static Future<bool> deleteAccount({required String password}) async {
    final token = await TokenService().getToken();
    if (token == null) {
      return false;
    }

    final response = await HttpService.delete(
      url: '$baseUrl/delete-account',
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: {
        'password': password,
      },
    );

    return response['statusCode'] == 200;
  }
}
