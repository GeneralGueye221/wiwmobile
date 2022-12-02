
class Tweeet {
  final  id_tweets;
  //final  jsonTweet;
  //final  date;
  //final  type;
  //final  src;

  Tweeet({
    this.id_tweets,
    //this.jsonTweet,
    //this.type,
    //this.date,
    //this.src
  });

  factory Tweeet.fromJson(Map<String, dynamic> json) {
    String id = json['response']['timeline'][0]['tweet']['id'];
    return Tweeet (
      id_tweets: json['response']['timeline'][0]['tweet']['id'] as String,
    );
  }
}

class ImageSlider {
  String id;
  String link;
  int h;
  int l;

  ImageSlider(this.id, this.link, this.h, this.l);
}