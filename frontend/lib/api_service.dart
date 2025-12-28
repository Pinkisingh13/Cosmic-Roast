import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {

  static const String baseUrl = 'https://cosmic-roast.onrender.com';

  static Future<Map<String, dynamic>?> getRoast({
    required String day,
    required String month,
    required String year,
  }) async {
    final url = Uri.parse('$baseUrl/roast-me');
    
    debugPrint('📡 API Call: POST $url');
    debugPrint('📤 Request: day=$day, month=$month, year=$year');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'date': day,
          'month': month,
          'year': year,
        }),
      );

      debugPrint('📥 Response Status: ${response.statusCode}');
      debugPrint('📥 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint('✅ Success! Roast received.');
        return {
          'roast': data['roast'] ?? 'The stars are silent.',
          'mulank': data['mulank']?.toString() ?? '0',
        };
      }
      debugPrint('❌ Server Error: Status ${response.statusCode}');
      debugPrint('❌ Error Body: ${response.body}');
      return null;
      
    } catch (e) {
    
      debugPrint('❌ Error: $e');
      return null;
    }
  }
}
