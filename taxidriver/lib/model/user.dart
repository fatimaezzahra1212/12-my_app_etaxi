import 'package:flutter/cupertino.dart';

class User {
  final String imagePath;
  final String name;
  final String email;
  final String about;
  final bool isDarkMode;

  const User({
    this.imagePath = "assets/image/mem.jpg",
    required this.name,
    required this.email,
    required this.about,
    required this.isDarkMode,
  });
}
