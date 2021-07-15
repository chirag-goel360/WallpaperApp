import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:wallpaper/helper/category_data.dart';
import 'package:wallpaper/models/category_class.dart';
import 'package:wallpaper/models/wallpaper_class.dart';
import 'package:wallpaper/pages/category_wallpaper.dart';
import 'package:wallpaper/pages/search_wallpaper.dart';
import 'package:wallpaper/widgets/widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CategoryClass> categories = [];
  List<WallPaperClass> wallpapers = [];
  TextEditingController controller = TextEditingController();

  getWallpapers() async {
    String url = "https://api.pexels.com/v1/curated?per_page=40&page=1";
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
    getWallpapers();
    categories = getCategory();
  }

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
      );
    } else {
      throw 'Could Not Launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(30),
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: "Search",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (controller.text != "") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return SearchedWallpaper(
                                  search: controller.text,
                                );
                              },
                            ),
                          );
                        }
                      },
                      child: Container(
                        child: Icon(
                          Icons.search,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 80,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  itemCount: categories.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return CategoryTile(
                      imageURL: categories[index].imageURL,
                      category: categories[index].name,
                    );
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              loadWallpapers(
                wallpapers,
                context,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Photos provided By ",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 20,
                      fontFamily: 'Hello-Pirates',
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      launchURL(
                        "https://www.pexels.com/",
                      );
                    },
                    child: Container(
                      child: Text(
                        "Pexels",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                          fontFamily: 'Hello-Pirates',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final String imageURL;
  final String category;

  CategoryTile({
    @required this.imageURL,
    @required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return CategoryScreen(
                category: category,
              );
            },
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(
          right: 8,
        ),
        child: kIsWeb
            ? Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: kIsWeb
                        ? Image.network(
                            imageURL,
                            height: 50,
                            width: 100,
                            fit: BoxFit.cover,
                          )
                        : CachedNetworkImage(
                            imageUrl: imageURL,
                            height: 50,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Container(
                    width: 100,
                    alignment: Alignment.center,
                    child: Text(
                      category,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Hello-Pirates',
                      ),
                    ),
                  ),
                ],
              )
            : Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: kIsWeb
                        ? Image.network(
                            imageURL,
                            height: 80,
                            width: 100,
                            fit: BoxFit.cover,
                          )
                        : CachedNetworkImage(
                            imageUrl: imageURL,
                            height: 80,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                  ),
                  Container(
                    height: 80,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  Container(
                    height: 80,
                    width: 100,
                    alignment: Alignment.center,
                    child: Text(
                      category ?? "",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Hello-Pirates',
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
