import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper/helper/category_data.dart';
import 'package:wallpaper/models/wallpaper_class.dart';
import 'package:wallpaper/widgets/widget.dart';

class CategoryScreen extends StatefulWidget {
  final String category;

  CategoryScreen({
    @required this.category,
  });

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<WallPaperClass> wallpapers = [];

  getCategoryWallpapers() async {
    String url = "https://api.pexels.com/v1/search?query=";
    url = url + widget.category + "&per_page=40";
    await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": key,
      },
    ).then((value) {
      Map<String, dynamic> jsonData = jsonDecode(
        value.body,
      );
      jsonData["photos"].forEach((element) {
        WallPaperClass wallpaperClass = WallPaperClass();
        wallpaperClass = WallPaperClass.fromMap(element);
        wallpapers.add(
          wallpaperClass,
        );
      });
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    getCategoryWallpapers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Wall',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                  color: Colors.blueGrey,
                  letterSpacing: 0.5,
                ),
              ),
              TextSpan(
                text: 'Paper',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                  color: Colors.blue,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: loadWallpapers(
          wallpapers,
          context,
        ),
      ),
    );
  }
}
