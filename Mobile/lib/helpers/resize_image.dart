import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

Future<Uint8List> resizeImage(String base64String) async {
    // Decode base64 string to bytes
    final bytes = base64Decode(base64String.replaceFirst(
        RegExp(r'data:image\/[a-zA-Z]+;base64,'), ''));

    // Decode image using the image package
    img.Image? image = img.decodeImage(Uint8List.fromList(bytes));

    // Check if the image is valid
    if (image == null) {
      throw Exception("Could not decode image");
    }

    // Resize the image (you can adjust width and height as needed)
    img.Image resizedImage =
        img.copyResize(image, width: 100); // Change width and height as needed

    // Convert the resized image back to bytes
    return Uint8List.fromList(
        img.encodeJpg(resizedImage)); // Use encodePng if you want a PNG format
  }