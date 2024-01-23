import 'dart:convert';
import 'package:http/http.dart' as http;

class PresenceService {
  static const String baseUrl = "http://10.10.111.116/presenceAPI";

  Future<List<Map<String, dynamic>>> fetchData() async {
    final response = await http.get(Uri.parse('$baseUrl/view.php'));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<Map<String, dynamic>> data = List.from(jsonResponse['data']);
      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> postData(Map<String, dynamic> data) async {
    try {
      _convertDateTimesToStrings(data);

      final response = await http.post(
        Uri.parse('$baseUrl/post.php'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      print('HTTP Response: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        print(jsonResponse['message']);
      } else {
        print('Failed to post data. Server returned ${response.statusCode}');
      }
    } catch (e) {
      print('Error posting data: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getPresenceByUser(String? nip) async {
    final response =
        await http.get(Uri.parse('$baseUrl/history_user.php?nip=$nip'));

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      final data = json.decode(response.body);
      if (data['data'] != null) {
        return List<Map<String, dynamic>>.from(data['data']);
      } else {
        throw Exception("No data available");
      }
    } else {
      throw Exception("Failed to load presence history");
    }
  }

  // Recursive function to convert DateTime objects to strings
  void _convertDateTimesToStrings(Map<String, dynamic> data) {
    data.forEach((key, value) {
      if (value is DateTime) {
        data[key] = value.toIso8601String();
      } else if (value is Map<String, dynamic>) {
        _convertDateTimesToStrings(value);
      } else if (value is List) {
        for (int i = 0; i < value.length; i++) {
          if (value[i] is Map<String, dynamic>) {
            _convertDateTimesToStrings(value[i]);
          }
        }
      }
    });
  }
}
