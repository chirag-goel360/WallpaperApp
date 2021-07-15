import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper/helper/category_data.dart';
import 'package:wallpaper/models/wallpaper_class.dart';
import 'package:wallpaper/widgets/widget.dart';

class SearchedWallpaper extends StatefulWidget {
  final String search;

  SearchedWallpaper({
    @required this.search,
  });

  @override
  _SearchedWallpaperState createState() => _SearchedWallpaperState();
}

class _SearchedWallpaperState extends State<SearchedWallpaper> {
  List<WallPaperClass> wallpapers = [];
  TextEditingController controller = TextEditingController();

  getSearchedWallpaper(String searchQuery) async {
    String url = "https://api.pexels.com/v1/search?query=";
    url = url + searchQuery + "&per_page=40";
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
    getSearchedWallpaper(
      widget.search,
    );
    controller.text = widget.search;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
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
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              loadWallpapers(
                wallpapers,
                context,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
