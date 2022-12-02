import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'dart:async';


class Post {

  final  id;
  final  title;
  final  slug;
  final  date;
  final  content;
  final  category;
  final  category_id;
  final  image;
  final  link;

  Post({
        this.content,
        this.id,
        this.title,
        this.slug,
        this.date,
        this.image,
        this.link,
        this.category,
        this.category_id
      });

  factory Post.fromJSON(Map<String, dynamic> json) {
    bool isImage =false;
        if(json["_embedded"]["wp:featuredmedia"]!=null){isImage=true;} else {isImage=false;}
    return Post(
        id: json['id'],
        title: parse(json['title']['rendered']).documentElement.text,
        content: json['content']['rendered'],
        date: json['date'],
        image:isImage?json["_embedded"]["wp:featuredmedia"][0]["source_url"]:null,
        //thumbnail: json["_embedded"]["wp:featuredmedia"][0]["media_details"]["sizes"]["medium"]["source_url"],
        category: json["_embedded"]["wp:term"][0][0]["name"],
        category_id: json["categories"][0],
        link: json['link'],
        slug: json['slug'],
        );
  }
}


