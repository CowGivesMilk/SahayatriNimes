import 'dart:convert';
import 'dart:typed_data'; // For handling binary data in web uploads
import 'package:flutter/foundation.dart' show kIsWeb; // Check if running on web
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.1.67:3000';

  // Login function
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw jsonDecode(response.body)['error'];
    }
  }

  // Sign up function
  static Future<String> signup(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['message'];
    } else {
      throw jsonDecode(response.body)['error'];
    }
  }

  // Update profile picture function (Supports Web and Mobile)
  static Future<void> updateProfilePicture(String userId, dynamic picture) async {
    final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/updateProfilePicture'));
    request.fields['userId'] = userId;

    if (kIsWeb) {
      // For Web: Handle Uint8List for binary data
      request.files.add(http.MultipartFile.fromBytes(
        'picture',
        picture,
        filename: 'profile_picture.jpg',
      ));
    } else {
      // For Mobile: Handle File from dart:io
      request.files.add(await http.MultipartFile.fromPath('picture', picture.path));
    }

    final response = await http.Response.fromStream(await request.send());
    if (response.statusCode != 200) {
      throw jsonDecode(response.body)['error'];
    }
  }
}
