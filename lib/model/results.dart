//MODEL OF A EXPLORER RESULT//
import 'package:flutter/foundation.dart';

class Result {
  final String id;
  final DateTime date;
  final String title;
  final  content;
  final String link;
  bool isVideo;

  Result(this.id, this.date, this.title, this.content, this.link, this.isVideo);
}

//MODEL OF FILTERED EXPLORER RESULT//
class FER {
  final String id;
  final  content;

  FER(this.id, this.content);
}

//MODEL OF WP CONTENT//
class Resultat {
  final String title;
  final String link;
  final String slug;
  final DateTime date;
  final String content;
  final String type;

  Resultat({this.title, this.link, this.date, this.content, this.slug, this.type});
}