import 'package:flutter/material.dart';
import 'package:wallpaper/pages/homepage.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wallpaper Application',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
