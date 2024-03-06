import 'dart:convert';
import 'package:http/http.dart' as http;

class PresenceService {
  static const String baseUrl = "http://10.10.111.11:8000/api";

  // Token bearer
  final String token;

  PresenceService(this.token);

  Future<List<Map<String, dynamic>>> fetchData() async {
    final response = await http.get(
      Uri.parse('$baseUrl/presences'),
      headers: {
        'Authorization': 'Bearer $token'
      }, // Include bearer token in the header
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse =
          json.decode(response.body); // Parse the response as a list
      List<Map<String, dynamic>> data =
          List.from(jsonResponse); // Convert the list to a list of maps
      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> fetchPresenceById(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/presences/$id'),
      headers: {
        'Authorization': 'Bearer $token'
      }, // Include bearer token in the header
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse =
          json.decode(response.body); // Parse the response as a map
      return jsonResponse;
    } else {
      throw Exception('Failed to load presence data');
    }
  }

  Future<void> postData(Map<String, dynamic> data) async {
    try {
      _convertDateTimesToStrings(data);

      final response = await http.post(
        Uri.parse('$baseUrl/post'),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token', // Tambahkan token bearer ke header
        },
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

  Future<Map<String, dynamic>> fetchKantorData() async {
    final response = await http.get(
      Uri.parse('$baseUrl/kantor'),
      headers: {
        'Authorization': 'Bearer $token'
      }, // Include bearer token in the header
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse =
          json.decode(response.body); // Parse the response as a map
      return jsonResponse;
    } else {
      throw Exception('Failed to load kantor data');
    }
  }

  // Future<List<Map<String, dynamic>>> getPresenceByUser(String? nip) async {
  //   final response = await http.get(
  //     Uri.parse('$baseUrl/history_user.php?nip=$nip'),
  //     headers: {'Authorization': 'Bearer $token'}, // Tambahkan token bearer ke header
  //   );

  //   if (response.statusCode == 200) {
  //     // If server returns an OK response, parse the JSON
  //     final data = json.decode(response.body);
  //     if (data['data'] != null) {
  //       return List<Map<String, dynamic>>.from(data['data']);
  //     } else {
  //       throw Exception("No data available");
  //     }
  //   } else {
  //     throw Exception("Failed to load presence history");
  //   }
  // }

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
