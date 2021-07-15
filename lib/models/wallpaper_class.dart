class WallPaperClass {
  String imageURL;
  String photographer;
  ImageClass image;

  WallPaperClass({
    this.imageURL,
    this.photographer,
    this.image,
  });

  factory WallPaperClass.fromMap(Map<String, dynamic> jsonData) {
    return WallPaperClass(
      imageURL: jsonData["url"],
      photographer: jsonData["photographer"],
      image: ImageClass.fromMap(
        jsonData["src"],
      ),
    );
  }
}

class ImageClass {
  String portrait;
  String landscape;

  ImageClass({
    this.portrait,
    this.landscape,
  });

  factory ImageClass.fromMap(Map<String, dynamic> jsonData) {
    return ImageClass(
      portrait: jsonData["portrait"],
      landscape: jsonData["landscape"],
    );
  }
}
