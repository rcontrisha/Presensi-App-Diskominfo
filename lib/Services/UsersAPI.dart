import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  static const String apiUrl =
      'https://771546f4-d1b7-45f7-9454-46251d44ff65.mock.pstmn.io/get';

  static Future<List<dynamic>> getUsers() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> users = responseData['args']['data'];
      return users;
    } else {
      throw Exception('Failed to load users');
    }
  }
}
