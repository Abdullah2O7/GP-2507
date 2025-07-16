


import 'package:shared_preferences/shared_preferences.dart';

class ImageStorage {
  static const _imageKey = 'cachedImage';

  /// Save the image as a Base64 string in SharedPreferences
  static Future<void> saveImage(String image) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_imageKey, image);
  }
// save the image as a Base64 string in SharedPreferences

  /// Retrieve the image from SharedPreferences
  static Future<String?> getImage() async {
    final prefs = await SharedPreferences.getInstance();
    final base64String = prefs.getString(_imageKey);
    return base64String;
  }
  //   if (base64String != null) {
  //     final bytes = base64Decode(base64String);
  //   // data:image/jpeg;base64,$base64Image
  //   final filePath='';
  //     final file = File(filePath);
  //     await file.writeAsBytes(bytes);
  //     return file;
  //   }
  //   return null;
  // }
}
