import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<Map<String, dynamic>> fetchMathQuestion() async {
    final response = await http.get(Uri.parse('https://api.mathjs.org/v4/?expr=2+2'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load question');
    }
  }
}