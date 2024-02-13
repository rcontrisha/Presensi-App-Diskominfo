import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  static const String apiUrl = 'http://10.10.111.85:8000/api/login';

  static Future<Map<String, dynamic>> getUsers(
      String nip, String deviceId) async {
    final response = await http.post(
      Uri.parse('$apiUrl'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'nip': nip,
        'device_id': deviceId,
      }),
    );

    if (response.statusCode == 200) {
      // Jika respons sukses, kembalikan respons JSON
      return jsonDecode(response.body);
    } else {
      // Jika respons tidak sukses, lemparkan pengecualian
      throw Exception('Failed to login');
    }
  }
}
