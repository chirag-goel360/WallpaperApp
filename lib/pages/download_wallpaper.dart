import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:url_launcher/url_launcher.dart';

class CompleteImage extends StatefulWidget {
  final String image;

  CompleteImage({
    @required this.image,
  });

  @override
  _CompleteImageState createState() => _CompleteImageState();
}

class _CompleteImageState extends State<CompleteImage> {
  dynamic filePath;

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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Hero(
            tag: widget.image,
            child: Container(
              height: size.height,
              width: size.width,
              child: kIsWeb
                  ? Image.network(
                      widget.image,
                      fit: BoxFit.cover,
                    )
                  : CachedNetworkImage(
                      imageUrl: widget.image,
                      placeholder: (context, url) {
                        return Container(
                          color: Color(0xFFF5F8FD),
                        );
                      },
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Container(
            height: size.height,
            width: size.width,
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    if (kIsWeb) {
                      launchURL(
                        widget.image,
                      );
                    } else {
                      save(widget.image);
                    }
                  },
                  child: Stack(
                    children: [
                      Container(
                        width: size.width / 2,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color(0xFF1C1B1B).withOpacity(0.8),
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      Container(
                        width: size.width / 2,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white24,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(40),
                          gradient: LinearGradient(
                            colors: [
                              Color(0x36FFFFFF),
                              Color(0x0FFFFFFF),
                            ],
                            begin: FractionalOffset.topLeft,
                            end: FractionalOffset.bottomRight,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Set Wallpaper",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 1,
                            ),
                            Text(
                              kIsWeb
                                  ? "Image will open in new tab to download"
                                  : "Image will be saved in gallery",
                              style: TextStyle(
                                fontSize: 8,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  save(String image) async {
    try {
      var imageId = await ImageDownloader.downloadImage(
        image,
      );
      print(imageId);
      print(image);
      if (imageId == null) {
        return;
      }
    } on PlatformException catch (error) {
      print(error);
    }
  }
}
