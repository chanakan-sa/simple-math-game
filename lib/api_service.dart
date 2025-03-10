import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<int> fetchMathQuestion(String expression) async {
    final url = Uri.parse('https://api.mathjs.org/v4/?expr=${Uri.encodeComponent(expression)}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return int.tryParse(response.body) ?? 0; // แปลงค่าเป็นตัวเลข ถ้าไม่ได้ให้เป็น 0
    } else {
      throw Exception('Failed to load question');
    }
  }
}
