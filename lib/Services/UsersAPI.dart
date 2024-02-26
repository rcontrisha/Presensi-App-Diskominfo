import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  static const String apiUrl = 'http://192.168.1.6:8000/api';

  static Future<Map<String, dynamic>> getUsersToken(
      String nip, String deviceId) async {
    final response = await http.post(
      Uri.parse('$apiUrl/login'),
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

  static Future<Map<String, dynamic>> getUsersByNipAndDeviceId(
      String nip) async {
    final response = await http.get(
      Uri.parse('$apiUrl/pegawai?nip=$nip'),
    );

    if (response.statusCode == 200) {
      // Jika respons sukses, kembalikan respons JSON
      return jsonDecode(response.body);
    } else {
      // Jika respons tidak sukses, lemparkan pengecualian
      throw Exception('Failed to fetch users');
    }
  }

  static Future<String> getUserImage(String nip) async {
    final response = await http.get(
      Uri.parse('$apiUrl/image-url/$nip.png'),
    );

    if (response.statusCode == 200) {
      // Jika respons sukses, kembalikan URL gambar dari JSON
      Map<String, dynamic> data = jsonDecode(response.body);
      return data["image_url"];
    } else {
      // Jika respons tidak sukses, lemparkan pengecualian
      throw Exception('Failed to fetch user image');
    }
  }
}
