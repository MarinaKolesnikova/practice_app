import 'dart:convert';
import 'package:pract_app/services/database_provider.dart';

ApiProduct apiProductFromJson(String str) => ApiProduct.fromJson(json.decode(str));

String apiProductToJson(ApiProduct data) => json.encode(data.toJson());

class ApiProduct {
  ApiProduct({
    required this.id,
    required this.img,
    required this.text,
    required this.title,
  });

  int id;
  String img;
  String text;
  String title;

  factory ApiProduct.fromJson(Map<String, dynamic> json) => ApiProduct(
    id: json["id"],
    img: json["img"],
    text: json["text"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "img": img,
    "text": text,
    "title": title,
  };

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.COLUMN_ID: id,
      DatabaseProvider.COLUMN_TITLE: title,
      DatabaseProvider.COLUMN_DESCRIPTION: text,
      DatabaseProvider.COLUMN_PHOTO: img
    };

    if (id.isFinite) {
      map[DatabaseProvider.COLUMN_ID] = id;
    }
    return map;
  }

  factory ApiProduct.fromMap(Map<String, dynamic> map){
    return ApiProduct(
        id: map[DatabaseProvider.COLUMN_ID],
        title: map[DatabaseProvider.COLUMN_TITLE],
        text: map[DatabaseProvider.COLUMN_DESCRIPTION],
        img: map[DatabaseProvider.COLUMN_PHOTO]);
  }
}