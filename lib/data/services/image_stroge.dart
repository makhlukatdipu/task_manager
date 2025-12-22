import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class ImageStorage {
  static const String _userPhotoKey = 'user_photo_base64';

  static Future<void> saveUserPhoto(XFile imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userPhotoKey, base64Image);

      print('Image saved to local storage');
    } catch (e) {
      print('Error saving image: $e');
    }
  }


  static Future<Widget?> getUserPhotoWidget({double size = 100}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final base64Image = prefs.getString(_userPhotoKey);

      if (base64Image != null && base64Image.isNotEmpty) {
        final bytes = base64Decode(base64Image);
        return ClipOval(
          child: Image.memory(
            bytes,
            width: size,
            height: size,
            fit: BoxFit.cover,
          ),
        );
      }
      return null;
    } catch (e) {
      print('Error loading image: $e');
      return null;
    }
  }


  static Future<String?> getUserPhotoBase64() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userPhotoKey);
  }


  static Future<void> deleteUserPhoto() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userPhotoKey);
  }
}