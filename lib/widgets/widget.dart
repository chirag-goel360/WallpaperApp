import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper/models/wallpaper_class.dart';
import 'package:wallpaper/pages/download_wallpaper.dart';

Widget loadWallpapers(List<WallPaperClass> listPhotos, context) {
  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: 10,
    ),
    child: !kIsWeb
        ? GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 0.6,
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.all(4),
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
            children: listPhotos.map((WallPaperClass wallpaperClass) {
              return GridTile(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return CompleteImage(
                            image: wallpaperClass.image.portrait,
                          );
                        },
                      ),
                    );
                  },
                  child: Hero(
                    tag: wallpaperClass.image.portrait,
                    child: Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          wallpaperClass.image.portrait,
                          height: 80,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          )
        : GridView.count(
            crossAxisCount: 4,
            childAspectRatio: 0.6,
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.all(4),
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
            children: listPhotos.map((WallPaperClass wallpaperClass) {
              return GridTile(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return CompleteImage(
                            image: wallpaperClass.image.portrait,
                          );
                        },
                      ),
                    );
                  },
                  child: Hero(
                    tag: wallpaperClass.image.portrait,
                    child: Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: CachedNetworkImage(
                          imageUrl: wallpaperClass.image.portrait,
                          placeholder: (context, url) {
                            return Container(
                              color: Color(0xFFF5F8FD),
                            );
                          },
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
  );
}
