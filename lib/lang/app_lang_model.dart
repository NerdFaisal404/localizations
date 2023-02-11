// To parse this JSON data, do
//
//     final appLangModel = appLangModelFromMap(jsonString);

import 'dart:convert';

class AppLangModel {
  AppLangModel({
    required this.appbar,
    required this.drawer,

  });

  Appbar appbar;
  Drawer drawer;


  factory AppLangModel.fromJson(String str) =>
      AppLangModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AppLangModel.fromMap(Map<String, dynamic> json) => AppLangModel(
      appbar: Appbar.fromMap(json["appbar"]),
      drawer: Drawer.fromMap(json["drawer"]));

  Map<String, dynamic> toMap() => {
        "appbar": appbar.toMap(),
        "drawer": drawer.toMap()
      };
}

class Appbar {
  Appbar({
    required this.title,
  });

  String title;

  factory Appbar.fromJson(String str) => Appbar.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Appbar.fromMap(Map<String, dynamic> json) => Appbar(
        title: json["title"],
      );

  Map<String, dynamic> toMap() => {
        "title": title,
      };
}

class Drawer {
  Drawer({
    required this.drawerTitle
  });

  String drawerTitle;

  factory Drawer.fromJson(String str) => Drawer.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Drawer.fromMap(Map<String, dynamic> json) => Drawer(
        drawerTitle: json["drawerTitle"]
      );

  Map<String, dynamic> toMap() => {
        "drawerTitle": drawerTitle,
      };
}
