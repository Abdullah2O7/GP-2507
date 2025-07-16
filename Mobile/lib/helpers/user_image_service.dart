//import 'dart:math';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

class UserImageService {
  static Future<Uint8List?> fetchUserImage(String token) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://gpappapis.azurewebsites.net/api/user/profile'),
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['picture'] != null) {
          String base64Image = data['picture'];
          if (base64Image.startsWith('data:image/')) {
            base64Image = base64Image.substring(base64Image.indexOf(',') + 1);
          }
          print(base64Image);
          return base64Decode(base64Image);
        }
      }
      return null;
    } catch (e) {
      print('Error fetching user image: $e');
      return null;
    }
  }
}
