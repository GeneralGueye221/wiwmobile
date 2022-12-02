import 'dart:convert';
import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:http/http.dart';
import 'package:share/share.dart';
import 'package:tweet_webview/tweet_webview.dart';
import 'package:twitter_api/twitter_api.dart';
import 'package:wiwmedia_wiwsport_v3/model/post.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';

import 'package:wiwmedia_wiwsport_v3/model/results.dart';
import 'package:wiwmedia_wiwsport_v3/model/tweet.dart';
import 'package:wiwmedia_wiwsport_v3/model/youtube/channel_info.dart';
import 'package:wiwmedia_wiwsport_v3/model/youtube/videos_list.dart';
import 'package:wiwmedia_wiwsport_v3/reusable/code_api.dart';
import 'package:wiwmedia_wiwsport_v3/reusable/players/twitter.dart';
import 'package:wiwmedia_wiwsport_v3/reusable/redirections/ExplorerBasketPage.dart';
import 'package:wiwmedia_wiwsport_v3/reusable/redirections/ExplorerCombatPage.dart';
import 'package:wiwmedia_wiwsport_v3/reusable/redirections/ExplorerFootPage.dart';
import 'package:wiwmedia_wiwsport_v3/screens/PostCardExp.dart';
import 'package:wiwmedia_wiwsport_v3/screens/PostCardExpYT.dart';
import 'package:wiwmedia_wiwsport_v3/services/service_youtube.dart';

import '../ExplorerPage.dart';


bool isVideo =false;

class LandingPageNews extends StatefulWidget {
  LandingPageNews({Key key}): super(key: key);
  @override
  _LandingPageNewsState createState() => _LandingPageNewsState();
}

class _LandingPageNewsState extends State<LandingPageNews> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  ScrollController _scrollController =new ScrollController();

  static const _adUnitID = "ca-app-pub-9120523919163473/1283696274";

//VARIABLES
  List<Result> resultats = List();
  List<Result> Fresults = List();
  List<FER> tmp = List();
  List<Widget> results = List();
  bool isLoadingWP = true;
  bool isLoadingTWT = true;
  bool isLoadingYT = true;
  //Rsultats Woordpress
  List<Result> results_wp = List();
  //Resultat youtube
  List<Result> results_yt_autre= List ();
  List<Result> results_yt_foot= List ();
  List<Result> results_yt_basket= List ();
  List<Result> results_yt_combat= List ();
  //Resultats Twitter
  List<Result> results_twt_autre= List ();
  List<Result> results_twt_foot= List ();
  List<Result> results_twt_basket= List ();
  List<Result> results_twt_combat= List ();

//CHARGEMENT DES DONNEES
  _FetchData() {
    resultats = new List();
    _getDataWp();
    _getChannelInfo();
    _getDataYt();
    _getDataTwitter();

  }
  //---> CHARGEMENT WP
  String url = "https://wiwsport.com/wp-json/wp/v2/posts?_embed&per_page=100&_fields=id,title,slug,content,date,categories,link,_links.wp:featuredmedia,_links.wp:term";
  List<Post> posts = List();
  int cpt=0;


  Future<void> _getDataWp() async {

    final response = await http.get(url);
    if(response.statusCode == 200) {
      posts =(json.decode(response.body) as List).map((data){
        return Post.fromJSON(data);
      }).toList();

      for(int i=0; i<posts.length; i++) {
        if(posts[i].content.contains("jeg_video_container")) {
          DateTime date = DateTime.parse(posts[i].date);
          String title = posts[i].title;
          String _type = "Youtube";
          var content = PostCardExp(post: posts[i], type: _type);
          String link = posts[i].link;
          String  tag  = "<iframe";
          String end_tag = "</iframe>";
          int startIndex = posts[i].content.indexOf(tag);
          int endIndex = posts[i].content.indexOf(end_tag)+end_tag.length;
          String _iframe = posts[i].content.substring(startIndex, endIndex);
          //print("---------------->iframe : $_iframe");
          String debut_src = "/embed/";
          int index_debut_src = _iframe.indexOf(debut_src)+debut_src.length;
          String fin_src ="?feature";
          int index_fin_src = _iframe.indexOf(fin_src);
          String src;

          if(index_fin_src != -1) {
            src = _iframe.substring(index_debut_src, index_fin_src);
          } else {
            src= "defaultID"+cpt.toString();
            cpt++;
          }
          //print("---------------->SRC: $src");
          var res = Result(src,date,title,content,link, true);
          bool isdoublon = false;
          for (int i =0; i<results_wp.length; i++){
            if(src == results_wp[i].id) {
              isdoublon =true;
            }
          }
          if(isdoublon == false){
            results_wp.add(res);
          }
        }
        if(posts[i].content.contains('twitter-tweet')) {
          DateTime date = DateTime.parse(posts[i].date);
          String title = posts[i].title;
          String link = posts[i].link;
          String  tag  = "<blockquote";
          String end_tag = "</blockquote>";
          int startIndex = posts[i].content.indexOf(tag);
          int endIndex = posts[i].content.indexOf(end_tag)+end_tag.length;
          String _blockquote = posts[i].content.substring(startIndex, endIndex);

          String debut_src = "/status/";
          int index_debut_src = _blockquote.indexOf(debut_src)+debut_src.length;
          String _bq = _blockquote.substring(index_debut_src);
          RegExp re = RegExp(r'(\d+)');
          String src =re.stringMatch(_bq);
          var content = TwitterCardPlus(id:src, isExplorer: true, title: posts[i].title);
          isVideo = content.isExplorerVideo;
          //print("---------------->SRC: $src");
          var res = Result(src,date,title,content,link, true);
          bool isdoublon = false;
          for (int i =0; i<results_wp.length; i++){
            if(src == results_wp[i].id) {
              isdoublon =true;
            }
          }
          if(isdoublon == false){
            results_wp.add(res);
          }
        }
        if(posts[i].content.contains("instagram-media")) {
          DateTime date = DateTime.parse(posts[i].date);
          String title = posts[i].title;
          String _type = "Instagram";
          var content = PostCardExp(post: posts[i], type: _type);
          String link = posts[i].link;
          String id="fakeID"+cpt.toString();
          cpt++;
          var res = Result(id,date,title,content,link, false);
          results_wp.add(res);
        }
        if (posts[i].content.contains('video.php')) {
          DateTime date = DateTime.parse(posts[i].date);
          String title = posts[i].title;
          String _type = "Facebook";
          String  tag  = "<iframe";
          String end_tag = "</iframe>";
          int startIndex = posts[i].content.indexOf(tag);
          int endIndex = posts[i].content.indexOf(end_tag)+end_tag.length;
          String _iframe = posts[i].content.substring(startIndex, endIndex);
          print("_IFRAME: $_iframe");

          String link = posts[i].link;
          String id="faceID"+cpt.toString();
          cpt++;
          var content = _iframeDisplayer(_iframe, title, _type, posts[i].date, link);
          var res = Result(id,date,title,content,link, true);
          bool isdoublon = false;
          for (int i =0; i<results_wp.length; i++){
            if(id == results_wp[i].id) {
              isdoublon =true;
            }
          }
          if(isdoublon == false){
            results_wp.add(res);
          }
        }
      }


      //resultats = resultats + results_wp;
      print('taille -> '+results_wp.length.toString());
      for(int i =0; i<results_wp.length; i++) {
        print("index -> $i");
        print('id -> '+results_wp[i].id.toString());
        for(int j =0; j<resultats.length; j++) {
          if(results_wp[i].id==resultats[j].id) {
            results_wp.removeWhere((item) => item.id==results_wp[i].id);
          }
        }
      }

      setState(() {
        resultats = resultats + results_wp;
        resultats.sort((b, a) => a.date.compareTo(b.date));
        isLoadingWP=false;
      });
    }
  }

  //---> CHARGEMENT TWITTER
  List tweets = List();
  List jsonFromTwitterAPI = List();

  Future _getDataTwitter() async {

    String consumerApiKey = "3hEda6a5H4hGr93fv8xKzIBte";
    String consumerApiSecret = "twkcvEDH8cHG6Uaja6VMDs9lsdPgDIzNDOatMWO8uItZQQChAk";
    String accessToken = "1486817757853372416-m7bveHgXbbK5vaInGvSkv83XccvPcS";
    String accessTokenSecret = "uLNvCRWvyQj4jyxWqNyVPCNwRejz7SoO6PuMGkpxAxXZx";

    final _twitterOauth = new twitterApi(
        consumerKey: consumerApiKey,
        consumerSecret: consumerApiSecret,
        token: accessToken,
        tokenSecret: accessTokenSecret
    );


    Future twitterRequest_autre = _twitterOauth.getTwitterRequest(
      "GET",
      "collections/entries.json",
      options: {
        "id": "custom-1294204346956210176",
        "count": "100",
        "tweet_mode":"extended",
      },
    );

    Future twitterRequest_foot = _twitterOauth.getTwitterRequest(
      "GET",
      "collections/entries.json",
      options: {
        "id": "custom-1366833082079326221",
        "count": "100",
        "tweet_mode":"extended",
      },
    );

    Future twitterRequest_basket = _twitterOauth.getTwitterRequest(
      "GET",
      "collections/entries.json",
      options: {
        "id": "custom-1366833135124643854",
        "count": "100",
        "tweet_mode":"extended",
      },
    );

    Future twitterRequest_combat = _twitterOauth.getTwitterRequest(
      "GET",
      "collections/entries.json",
      options: {
        "id": "custom-1366833200937512969",
        "count": "100",
        "tweet_mode":"extended",
      },
    );

    var res_autre = await twitterRequest_autre;
    var res_foot = await twitterRequest_foot;
    var res_basket = await twitterRequest_basket;
    var res_combat = await twitterRequest_combat;

    if (res_autre.statusCode == 200) {
      var _id;
      String _txt;
      DateTime _date;
      var _content;
      String _url;
      String video_img;
      String _link;
      String _type;
      List<ImageSlider> images = List();
      bool isCaroussel = false;

      String user_id;
      String user_image;
      String user_name;
      String user_screename;


      var data =json.decode(res_autre.body);
      var _taille =data['response']['timeline'].length;

      for (int i=0; i<_taille; i++) {
        _id =data['response']['timeline'][i]['tweet']['id'].toString();
        var date = data['objects']['tweets'][_id]['created_at'];
        _date = FormatTwitterDate(date);
        String toRemove;
        int indexToRemove;
        var media = data['objects']['tweets'][_id]['extended_entities'];
        if(media != null){
          _type = data['objects']['tweets'][_id]['extended_entities']['media'][0]['type'];
          _link = data['objects']['tweets'][_id]['extended_entities']['media'][0]['expanded_url'];
          int size = data['objects']['tweets'][_id]['extended_entities']['media'].length;
          if(_type=="photo"){
            isVideo = false;
            if(size>1) {
              isCaroussel = true;
              images = new List();
              print("******caroussell de $_id");
              print("**************SIZE: "+size.toString());
              for(int i = 0; i<size; i++) {
                var lien = data['objects']['tweets'][_id]['extended_entities']['media'][i]['media_url_https'];
                int hauteur = data['objects']['tweets'][_id]['extended_entities']['media'][i]['sizes']['large']['h'];
               // print("HAUTEUR IMG -> "+hauteur.toString());
                var largeur= data['objects']['tweets'][_id]['extended_entities']['media'][i]['sizes']['large']['w'];
               // print("LARGEUR IMG -> "+largeur.toString());

                ImageSlider _img = ImageSlider(_id, lien, hauteur, largeur);
                images.add(_img);
              }

            }
            else {
              isCaroussel =false;
              //images = new List();
              _url = data['objects']['tweets'][_id]['extended_entities']['media'][0]['media_url_https'];
            }
          }
          else if (_type=="video") {
            isVideo = true;
            video_img = data['objects']['tweets'][_id]['extended_entities']['media'][0]['media_url_https'];
            _url = data['objects']['tweets'][_id]['extended_entities']['media'][0]['video_info']['variants'][1]["url"];
          }
          else {
            isVideo = false;
            video_img = "";
            _url = "";
          }
          toRemove = data['objects']['tweets'][_id]['extended_entities']['media'][0]['url'];
        }
        String txt = data['objects']['tweets'][_id]['full_text'];
        if(toRemove!=null) {
          indexToRemove = txt.indexOf(toRemove);
          _txt = txt.substring(0, indexToRemove);
        } else {
          //int x = txt.length-23;
          _txt = txt;
        }

        user_id = data['objects']['tweets'][_id]['user']['id_str'];
        user_image = data['objects']['users'][user_id]['profile_image_url_https'];
        user_name = data['objects']['users'][user_id]['name'];
        user_screename = data['objects']['users'][user_id]['screen_name'];


        var link ="https://twitter.com/$user_screename/status/$_id";
        if(data['objects']['tweets'][_id]['entities']['media'] == null)  {
          _content =  TwitterCard(id: _id, date:_date, txt: _txt, media_url: _url, type: _type,usr_img: user_image, usr_name: user_name, usr_scrname: user_screename,caroussel: images,isSlider: isCaroussel, isCard: true,link: link,);
          print("**************TAILLE: "+images.length.toString());
        }
        else {
          if(data['objects']['tweets'][_id]['extended_entities']==null) {
            _content= Container();
          }
          else {
            _content =  TwitterCard(id: _id, date:_date, txt: _txt, media_url: _url, type: _type,usr_img: user_image, usr_name: user_name, usr_scrname: user_screename,caroussel: images,isSlider: isCaroussel, isCard: false, link: link,);
            print("**************TAILLE: "+images.length.toString());
          }
        }

        Result result = Result(_id,_date, '', _content, _link,isVideo);
        results_twt_autre.add(result);
        images=new List();
        _content=null;

      }
      for(int i =0; i<results_twt_autre.length; i++) {
        for (int j = 0; j < resultats.length; j++) {
          if (results_twt_autre[i].id == resultats[j].id) {
            results_twt_autre.removeWhere((item) =>
            item.id == results_twt_autre[i].id);
          }
        }
      }
    setState(() {
      resultats = resultats + results_twt_autre;
    });
    }  else {
      print(">>>>>>>>>>>>> NOUS AVONS UNE ERREUR DE CHARGEMENT TWIITER");
      print(res_autre.statusCode);
    }

    if (res_foot.statusCode == 200) {
      var _id;
      String _txt;
      DateTime _date;
      var _content;
      String _url;
      String video_img;
      String _link;
      String _type;
      List<ImageSlider> images = List();
      bool isCaroussel = false;

      String user_id;
      String user_image;
      String user_name;
      String user_screename;


      var data =json.decode(res_foot.body);
      var _taille =data['response']['timeline'].length;

      for (int i=0; i<_taille; i++) {
        _id =data['response']['timeline'][i]['tweet']['id'].toString();
        var date = data['objects']['tweets'][_id]['created_at'];
        _date = FormatTwitterDate(date);
        String toRemove;
        int indexToRemove;
        var media = data['objects']['tweets'][_id]['extended_entities'];
        if(media != null){

          _type = data['objects']['tweets'][_id]['extended_entities']['media'][0]['type'];
          _link = data['objects']['tweets'][_id]['extended_entities']['media'][0]['expanded_url'];
          int size = data['objects']['tweets'][_id]['extended_entities']['media'].length;
          if(_type=="photo"){
            isVideo = false;
            if(size>1) {
              isCaroussel = true;
              print("******caroussell de $_id");
              print("**************SIZE: "+size.toString());
              for(int i = 0; i<size; i++) {
                var lien = data['objects']['tweets'][_id]['extended_entities']['media'][i]['media_url_https'];
                int hauteur = data['objects']['tweets'][_id]['extended_entities']['media'][i]['sizes']['large']['h'];
                //print("HAUTEUR IMG -> "+hauteur.toString());
                var largeur= data['objects']['tweets'][_id]['extended_entities']['media'][i]['sizes']['large']['w'];
                //print("LARGEUR IMG -> "+largeur.toString());

                ImageSlider _img = ImageSlider(_id,lien, hauteur, largeur);
                images.add(_img);

              }
            }
            else {
              isCaroussel =false;
              images = new List();
              _url = data['objects']['tweets'][_id]['extended_entities']['media'][0]['media_url_https'];
            }
          }
          else if (_type=="video") {
            isVideo = true;
            video_img = data['objects']['tweets'][_id]['extended_entities']['media'][0]['media_url_https'];
            _url = data['objects']['tweets'][_id]['extended_entities']['media'][0]['video_info']['variants'][1]["url"];
          }
          else {
            isVideo = false;
            video_img = "";
            _url = "";
          }
          toRemove = data['objects']['tweets'][_id]['extended_entities']['media'][0]['url'];
        }
        String txt = data['objects']['tweets'][_id]['full_text'];
        if(toRemove!=null) {
          indexToRemove = txt.indexOf(toRemove);
          _txt = txt.substring(0, indexToRemove);
        } else {
          //int x = txt.length-23;
          _txt = txt;
        }

        user_id = data['objects']['tweets'][_id]['user']['id_str'];
        user_image = data['objects']['users'][user_id]['profile_image_url_https'];
        user_name = data['objects']['users'][user_id]['name'];
        user_screename = data['objects']['users'][user_id]['screen_name'];


        var link ="https://twitter.com/$user_screename/status/$_id";
        if(data['objects']['tweets'][_id]['entities']['media'] == null)  {
          print("**************TAILLE: "+images.length.toString());
          _content =  TwitterCard(id: _id, date:_date, txt: _txt, media_url: _url, type: _type,usr_img: user_image, usr_name: user_name, usr_scrname: user_screename,caroussel: images,isSlider: isCaroussel, isCard: true,link: link,);
          images =new List();
        }
        else {
          if(data['objects']['tweets'][_id]['extended_entities']==null) {
            _content= Container();
          }
          else {
            print("**************TAILLE: "+images.length.toString());
            _content =  TwitterCard(id: _id, date:_date, txt: _txt, media_url: _url, type: _type,usr_img: user_image, usr_name: user_name, usr_scrname: user_screename,caroussel: images,isSlider: isCaroussel, isCard: false, link: link,);
            images = new List();
          }
        }

        Result result = Result(_id,_date, '', _content, _link,isVideo);
        results_twt_foot.add(result);

      }
      for(int i =0; i<results_twt_foot.length; i++) {
        for (int j = 0; j < resultats.length; j++) {
          if (results_twt_foot[i].id == resultats[j].id) {
            results_twt_foot.removeWhere((item) =>
            item.id == results_twt_foot[i].id);
          }
        }
      }
      setState(() {
        resultats = resultats + results_twt_foot;
      });
    }  else {
      print(">>>>>>>>>>>>> NOUS AVONS UNE ERREUR DE CHARGEMENT TWIITER");
      print(res_foot.statusCode);
    }


    if (res_basket.statusCode == 200) {
      var _id;
      String _txt;
      DateTime _date;
      var _content;
      String _url;
      String video_img;
      String _link;
      String _type;
      List<ImageSlider> images = List();
      List<String> H = List();
      List<String> L = List();
      bool isCaroussel = false;

      String user_id;
      String user_image;
      String user_name;
      String user_screename;


      var data =json.decode(res_basket.body);
      var _taille =data['response']['timeline'].length;

      for (int i=0; i<_taille; i++) {
        _id =data['response']['timeline'][i]['tweet']['id'].toString();
        var date = data['objects']['tweets'][_id]['created_at'];
        _date = FormatTwitterDate(date);
        String toRemove;
        int indexToRemove;
        var media = data['objects']['tweets'][_id]['extended_entities'];
        if(media != null){
          _type = data['objects']['tweets'][_id]['extended_entities']['media'][0]['type'];
          _link = data['objects']['tweets'][_id]['extended_entities']['media'][0]['expanded_url'];
          int size = data['objects']['tweets'][_id]['extended_entities']['media'].length;
          if(_type=="photo"){
            isVideo = false;
            if(size>1) {
              isCaroussel = true;
              print("******caroussell de $_id");
              print("**************SIZE: "+size.toString());
              for(int i = 0; i<size; i++) {
                var lien = data['objects']['tweets'][_id]['extended_entities']['media'][i]['media_url_https'];
                int hauteur = data['objects']['tweets'][_id]['extended_entities']['media'][i]['sizes']['large']['h'];
                print("HAUTEUR IMG -> "+hauteur.toString());
                var largeur= data['objects']['tweets'][_id]['extended_entities']['media'][i]['sizes']['large']['w'];
                print("LARGEUR IMG -> "+largeur.toString());

                ImageSlider _img = ImageSlider(_id,lien, hauteur, largeur);
                images.add(_img);
              }
            }
            else {
              isCaroussel =false;
              images = new List();
              _url = data['objects']['tweets'][_id]['extended_entities']['media'][0]['media_url_https'];
            }
          }
          else if (_type=="video") {
            isVideo = true;
            video_img = data['objects']['tweets'][_id]['extended_entities']['media'][0]['media_url_https'];
            _url = data['objects']['tweets'][_id]['extended_entities']['media'][0]['video_info']['variants'][1]["url"];
          }
          else {
            isVideo = false;
            video_img = "";
            _url = "";
          }
          toRemove = data['objects']['tweets'][_id]['extended_entities']['media'][0]['url'];
        }
        var fav_count = data['objects']['tweets'][_id]['favorite_count'];
        String txt = data['objects']['tweets'][_id]['full_text'];
        if(toRemove!=null) {
          indexToRemove = txt.indexOf(toRemove);
          _txt = txt.substring(0, indexToRemove);
        } else {
          //int x = txt.length-23;
          _txt = txt;
        }

        user_id = data['objects']['tweets'][_id]['user']['id_str'];
        user_image = data['objects']['users'][user_id]['profile_image_url_https'];
        user_name = data['objects']['users'][user_id]['name'];
        user_screename = data['objects']['users'][user_id]['screen_name'];

        var link ="https://twitter.com/$user_screename/status/$_id";
        if(data['objects']['tweets'][_id]['entities']['media'] == null)  {
          _content =  TwitterCard(id: _id, date:_date, txt: _txt, media_url: _url, type: _type,usr_img: user_image, usr_name: user_name, usr_scrname: user_screename,caroussel: images,isSlider: isCaroussel, isCard: true,link: link,);
          images=List();
        }
        else {
          if(data['objects']['tweets'][_id]['extended_entities']==null) {
            _content= Container();
          }
          else {
            _content =  TwitterCard(id: _id, date:_date, txt: _txt, media_url: _url, type: _type,usr_img: user_image, usr_name: user_name, usr_scrname: user_screename,caroussel: images,isSlider: isCaroussel, isCard: false, link: link,);
            images=List();
          }
        }



        Result result = Result(_id,_date, '', _content, _link,isVideo);
        results_twt_basket.add(result);

      }
      setState(() {
        resultats = resultats + results_twt_basket;
      });
    }  else {
      print(">>>>>>>>>>>>> NOUS AVONS UNE ERREUR DE CHARGEMENT TWIITER");
      print(res_basket.statusCode);
    }

    if (res_combat.statusCode == 200) {
      var _id;
      String _txt;
      DateTime _date;
      var _content;
      String _url;

      String _link;
      String _type;
      List<ImageSlider> images = List();
      List<String> H = List();
      List<String> L = List();
      bool isCaroussel = false;

      String user_id;
      String user_image;
      String user_name;
      String user_screename;


      var data =json.decode(res_combat.body);
      var _taille =data['response']['timeline'].length;

      for (int i=0; i<_taille; i++) {
        _id =data['response']['timeline'][i]['tweet']['id'].toString();
        var date = data['objects']['tweets'][_id]['created_at'];
        _date = FormatTwitterDate(date);
        String toRemove;
        int indexToRemove;
        var media = data['objects']['tweets'][_id]['extended_entities'];
        if(media != null){
          _type = data['objects']['tweets'][_id]['extended_entities']['media'][0]['type'];
          _link = data['objects']['tweets'][_id]['extended_entities']['media'][0]['expanded_url'];
          int size = data['objects']['tweets'][_id]['extended_entities']['media'].length;
          if(_type=="photo"){
            isVideo = false;
            if(size>1) {
              isCaroussel = true;
              print("******caroussell de $_id");
              print("**************SIZE: "+size.toString());
              for(int i = 0; i<size; i++) {
                var lien = data['objects']['tweets'][_id]['extended_entities']['media'][i]['media_url_https'];
                int hauteur = data['objects']['tweets'][_id]['extended_entities']['media'][i]['sizes']['large']['h'];
                print("HAUTEUR IMG -> "+hauteur.toString());
                var largeur= data['objects']['tweets'][_id]['extended_entities']['media'][i]['sizes']['large']['w'];
                print("LARGEUR IMG -> "+largeur.toString());

                ImageSlider _img = ImageSlider(_id,lien, hauteur, largeur);
                images.add(_img);
              }
            }
            else {
              isCaroussel =false;
              images = new List();
              _url = data['objects']['tweets'][_id]['extended_entities']['media'][0]['media_url_https'];
            }
          }
          else if (_type=="video") {
            isVideo = true;
            _url = data['objects']['tweets'][_id]['extended_entities']['media'][0]['video_info']['variants'][1]["url"];
          }
          else {
            isVideo = false;
            _url = "";
          }
          toRemove = data['objects']['tweets'][_id]['extended_entities']['media'][0]['url'];
        }
        var fav_count = data['objects']['tweets'][_id]['favorite_count'];
        String txt = data['objects']['tweets'][_id]['full_text'];
        if(toRemove!=null) {
          indexToRemove = txt.indexOf(toRemove);
          _txt = txt.substring(0, indexToRemove);
        } else {
          //int x = txt.length-23;
          _txt = txt;
        }

        user_id = data['objects']['tweets'][_id]['user']['id_str'];
        user_image = data['objects']['users'][user_id]['profile_image_url_https'];
        user_name = data['objects']['users'][user_id]['name'];
        user_screename = data['objects']['users'][user_id]['screen_name'];

        _content =  TwitterCard(id: _id, date:_date, txt: _txt, media_url: _url, type: _type,usr_img: user_image, usr_name: user_name, usr_scrname: user_screename,caroussel: images,isSlider: isCaroussel);
        images = [];
        Result result = Result(_id,_date, '', _content, _link,isVideo);
        results_twt_combat.add(result);

      }
      for(int i =0; i<results_twt_combat.length; i++) {
        for (int j = 0; j < resultats.length; j++) {
          if (results_twt_combat[i].id == resultats[j].id) {
            results_twt_combat.removeWhere((item) =>
            item.id == results_twt_combat[i].id);
          }
        }
      }
      setState(() {
        resultats = resultats + results_twt_combat;
        //isLoadingTWT = false;
      });
    }  else {
      print(">>>>>>>>>>>>> NOUS AVONS UNE ERREUR DE CHARGEMENT TWIITER");
      print(res_combat.statusCode);
    }

    setState(() {
      resultats.sort((b, a) => a.date.compareTo(b.date));
      isLoadingTWT = false;
    });
  }

  //---> CHARGEMENT YOUTUBE
  static const _baseUrl = 'www.googleapis.com';

  _getDataYt() async {

    await loadsYTVideo_Autre();
    await loadsYTVideo_Basket();
    await loadsYTVideo_Foot();
    await loadsYTVideo_Combat();

    setState(() {
      resultats = resultats + results_yt_autre;
      resultats = resultats + results_yt_foot;
      resultats = resultats + results_yt_basket;
      resultats = resultats + results_yt_combat;
      resultats.sort((b, a) => a.date.compareTo(b.date));
      isLoadingYT = false;
    });
  }
  loadsYTVideo_Autre () async {

    Map<String, String> parameters = {
      'part': 'snippet',
      'playlistId': "PL68y_RTVo0AdcuhVtC_vFnNBEXZnwtlSv",
      'maxResults': '11',
      'key': Constants.KEY_YT,
    };
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/playlistItems',
      parameters,
    );
    Response response = await http.get(uri, headers: headers);
    var data = json.decode(response.body);

    if(response.statusCode==200) {

      var _date1 = data['items'][0]["snippet"]["publishedAt"];
      DateTime date = DateTime.parse(_date1);
      var id_1 = data['items'][0]["snippet"]["resourceId"]["videoId"];
      var title_1 = data['items'][0]["snippet"]["title"];
      var link_1 = "https://www.youtube.com/watch?v=$id_1";
      var content_1 = PostCardExpYT(VideoItemId: id_1, VideoItemDate: date, VideoItemTitle: title_1, VideoItemLink: link_1);
      var res_1 = Result(id_1,date,title_1,content_1,link_1, true);

      var _date2 = data['items'][1]["snippet"]["publishedAt"];
      DateTime date2 = DateTime.parse(_date2);
      var id_2 = data['items'][1]["snippet"]["resourceId"]["videoId"];
      var title_2 = data['items'][1]["snippet"]["title"];
      var link_2 = "https://www.youtube.com/watch?v=$id_1";
      var content_2 = PostCardExpYT(VideoItemId: id_2, VideoItemDate: date, VideoItemTitle: title_2, VideoItemLink: link_2);
      var res_2 = Result(id_2,date2,title_2,content_2,link_2, true);

      var _date3 = data['items'][2]["snippet"]["publishedAt"];
      DateTime date3 = DateTime.parse(_date3);
      var id_3 = data['items'][2]["snippet"]["resourceId"]["videoId"];
      var title_3 = data['items'][2]["snippet"]["title"];
      var link_3 = "https://www.youtube.com/watch?v=$id_2";
      var content_3 = PostCardExpYT(VideoItemId: id_3, VideoItemDate: date3, VideoItemTitle: title_3, VideoItemLink: link_3);
      var res_3 = Result(id_3,date3,title_3,content_3,link_3, true);

      results_yt_autre.add(res_1);
      results_yt_autre.add(res_2);
      results_yt_autre.add(res_3);

      for(int i =0; i<results_yt_autre.length; i++) {
        print("index -> $i");
        print('id -> ' + results_yt_autre[i].id.toString());
        for (int j = 0; j < resultats.length; j++) {
          if (results_yt_autre[i].id == resultats[j].id) {
            results_yt_autre.removeWhere((item) =>
            item.id == results_yt_autre[i].id);
          }
        }
      }
    }
    else {
      print(">>>>>>>>>>>>> NOUS AVONS UNE ERREUR DE CHARGEMENT YOUTUBE");
      print(response.statusCode);
    }
  }
  loadsYTVideo_Foot () async {
    Map<String, String> parameters = {
      'part': 'snippet, contentDetails',
      'playlistId': "PL68y_RTVo0Acw4zEfI-0aG78NcSejOzpt",
      'maxResults': '11',
      'key': Constants.KEY_YT,
    };
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/playlistItems',
      parameters,
    );
    Response response = await http.get(uri, headers: headers);
    if(response.statusCode==200) {
      var data = json.decode(response.body);
      var _date1 = data['items'][0]["contentDetails"]["videoPublishedAt"];
      DateTime date = DateTime.parse(_date1);
      var id_1 = data['items'][0]["snippet"]["resourceId"]["videoId"];
      var title_1 = data['items'][0]["snippet"]["title"];
      var link_1 = "https://www.youtube.com/watch?v=$id_1";
      var content_1 = PostCardExpYT(VideoItemId: id_1, VideoItemDate: date, VideoItemTitle: title_1, VideoItemLink: link_1);
      var res_1 = Result(id_1,date,title_1,content_1,link_1, true);

      var _date2 = data['items'][1]["snippet"]["publishedAt"];
      DateTime date2 = DateTime.parse(_date2);
      var id_2 = data['items'][1]["snippet"]["resourceId"]["videoId"];
      var title_2 = data['items'][1]["snippet"]["title"];
      var link_2 = "https://www.youtube.com/watch?v=$id_2";
      var content_2 = PostCardExpYT(VideoItemId: id_2, VideoItemDate: date, VideoItemTitle: title_2, VideoItemLink: link_2);
      var res_2 = Result(id_2,date2,title_2,content_2,link_2, true);

      var _date3 = data['items'][2]["snippet"]["publishedAt"];
      DateTime date3 = DateTime.parse(_date3);
      var id_3 = data['items'][2]["snippet"]["resourceId"]["videoId"];
      var title_3 = data['items'][2]["snippet"]["title"];
      var link_3 = "https://www.youtube.com/watch?v=$id_3";
      var content_3 = PostCardExpYT(VideoItemId: id_3, VideoItemDate: date3, VideoItemTitle: title_3, VideoItemLink: link_3);
      var res_3 = Result(id_3,date3,title_3,content_3,link_3, true);

      results_yt_foot.add(res_1);
      results_yt_foot.add(res_2);
      results_yt_foot.add(res_3);

      for(int i =0; i<results_yt_foot.length; i++) {
        for (int j = 0; j < resultats.length; j++) {
          if (results_yt_foot[i].id == resultats[j].id) {
            results_yt_foot.removeWhere((item) =>
            item.id == results_yt_foot[i].id);
          }
        }
      }
    }
    else {
      print(">>>>>>>>>>>>> NOUS AVONS UNE ERREUR DE CHARGEMENT YOUTUBE");
      print(response.statusCode);
    }

  }
  loadsYTVideo_Basket () async {
    //PL68y_RTVo0AejKQQAIGEaps3Uw_nMbuVm
    Map<String, String> parameters = {
      'part': 'snippet, contentDetails',
      'playlistId': "PL68y_RTVo0AejKQQAIGEaps3Uw_nMbuVm",
      'maxResults': '11',
      'key': Constants.KEY_YT,
    };
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/playlistItems',
      parameters,
    );
    Response response = await http.get(uri, headers: headers);
    if(response.statusCode==200) {
      var data = json.decode(response.body);
      var _date1 = data['items'][0]["contentDetails"]["videoPublishedAt"];
      DateTime date = DateTime.parse(_date1);
      var id_1 = data['items'][0]["snippet"]["resourceId"]["videoId"];
      var title_1 = data['items'][0]["snippet"]["title"];
      var link_1 = "https://www.youtube.com/watch?v=$id_1";
      var content_1 = PostCardExpYT(VideoItemId: id_1, VideoItemDate: date, VideoItemTitle: title_1, VideoItemLink: link_1);
      var res_1 = Result(id_1,date,title_1,content_1,link_1, true);

      var _date2 = data['items'][1]["snippet"]["publishedAt"];
      DateTime date2 = DateTime.parse(_date2);
      var id_2 = data['items'][1]["snippet"]["resourceId"]["videoId"];
      var title_2 = data['items'][1]["snippet"]["title"];
      var link_2 = "https://www.youtube.com/watch?v=$id_2";
      var content_2 = PostCardExpYT(VideoItemId: id_2, VideoItemDate: date, VideoItemTitle: title_2, VideoItemLink: link_2);
      var res_2 = Result(id_2,date2,title_2,content_2,link_2, true);

      var _date3 = data['items'][2]["snippet"]["publishedAt"];
      DateTime date3 = DateTime.parse(_date3);
      var id_3 = data['items'][2]["snippet"]["resourceId"]["videoId"];
      var title_3 = data['items'][2]["snippet"]["title"];
      var link_3 = "https://www.youtube.com/watch?v=$id_3";
      var content_3 = PostCardExpYT(VideoItemId: id_3, VideoItemDate: date3, VideoItemTitle: title_3, VideoItemLink: link_3);
      var res_3 = Result(id_3,date3,title_3,content_3,link_3, true);

      results_yt_basket.add(res_1);
      results_yt_basket.add(res_2);
      results_yt_basket.add(res_3);

      for(int i =0; i<results_yt_basket.length; i++) {
        for (int j = 0; j < resultats.length; j++) {
          if (results_yt_basket[i].id == resultats[j].id) {
            results_yt_basket.removeWhere((item) =>
            item.id == results_yt_basket[i].id);
          }
        }
      }
    }
    else {
      print(">>>>>>>>>>>>> NOUS AVONS UNE ERREUR DE CHARGEMENT YOUTUBE");
      print(response.statusCode);
    }

  }
  loadsYTVideo_Combat () async {
    //PL68y_RTVo0Af9J76u1q7dabSbBlWA-hgO
    Map<String, String> parameters = {
      'part': 'snippet',
      'playlistId': "PL68y_RTVo0Af9J76u1q7dabSbBlWA-hgO",
      'maxResults': '11',
      'key': Constants.KEY_YT,
    };
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/playlistItems',
      parameters,
    );
    Response response = await http.get(uri, headers: headers);
    if(response.statusCode==200) {
      var data = json.decode(response.body);
      var _date1 = data['items'][0]["snippet"]["publishedAt"];
      DateTime date = DateTime.parse(_date1);
      var id_1 = data['items'][0]["snippet"]["resourceId"]["videoId"];
      var title_1 = data['items'][0]["snippet"]["title"];
      var link_1 = "https://www.youtube.com/watch?v=$id_1";
      var content_1 = PostCardExpYT(VideoItemId: id_1, VideoItemDate: date, VideoItemTitle: title_1, VideoItemLink: link_1);
      var res_1 = Result(id_1,date,title_1,content_1,link_1, true);

      var _date2 = data['items'][1]["snippet"]["publishedAt"];
      DateTime date2 = DateTime.parse(_date2);
      var id_2 = data['items'][1]["snippet"]["resourceId"]["videoId"];
      var title_2 = data['items'][1]["snippet"]["title"];
      var link_2 = "https://www.youtube.com/watch?v=$id_1";
      var content_2 = PostCardExpYT(VideoItemId: id_2, VideoItemDate: date, VideoItemTitle: title_2, VideoItemLink: link_2);
      var res_2 = Result(id_2,date2,title_2,content_2,link_2, true);

      var _date3 = data['items'][2]["snippet"]["publishedAt"];
      DateTime date3 = DateTime.parse(_date3);
      var id_3 = data['items'][2]["snippet"]["resourceId"]["videoId"];
      var title_3 = data['items'][2]["snippet"]["title"];
      var link_3 = "https://www.youtube.com/watch?v=$id_2";
      var content_3 = PostCardExpYT(VideoItemId: id_3, VideoItemDate: date3, VideoItemTitle: title_3, VideoItemLink: link_3);
      var res_3 = Result(id_3,date3,title_3,content_3,link_3, true);

      results_yt_combat.add(res_1);
      results_yt_combat.add(res_2);
      results_yt_combat.add(res_3);

      for(int i =0; i<results_yt_combat.length; i++) {
        for (int j = 0; j < resultats.length; j++) {
          if (results_yt_combat[i].id == resultats[j].id) {
            results_yt_combat.removeWhere((item) =>
            item.id == results_yt_combat[i].id);
          }
        }
      }
    }
    else {
      print(">>>>>>>>>>>>> NOUS AVONS UNE ERREUR DE CHARGEMENT YOUTUBE");
      print(response.statusCode);
    }
  }

  ChannelInfo _channelInfo;
  VideosList _videosList;
  Item _item;
  String _playListId;
  String _nextPageToken;
  _getChannelInfo() async {
    _channelInfo = await Youtube_Service.getChannelInfo();
    _item = _channelInfo.items[0];
    _playListId = _item.contentDetails.relatedPlaylists.uploads;
    print('_playListId $_playListId');
    await _loadVideos();

    for(int i = 0; i<_videosList.videos.length; i++) {
      var date = _videosList.videos[i].video.publishedAt;
      var id = _videosList.videos[i].video.resourceId.videoId;
      var title = _videosList.videos[i].video.title;
      var link = "https://www.youtube.com/watch?v=$id";

      var content = PostCardExpYT(VideoItemId: id, VideoItemDate: date, VideoItemTitle: title, VideoItemLink: link);

      var res = Result(id,date,title,content,link, true);
      resultats.add(res);
      //results.add(resultats[i].content);
    }
  }
  _loadVideos() async {
    VideosList tempVideosList = await Youtube_Service.getVideosList(
      playListId: _playListId,
      pageToken: _nextPageToken,
    );
    _nextPageToken = tempVideosList.nextPageToken;
    _videosList.videos.addAll(tempVideosList.videos);
    //print('videos: ${_videosList.videos.length}');
    //print('_nextPageToken $_nextPageToken');

    setState(() {});
  }

  //REFRESH PAGE
  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    return  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (content) {
            return ExplorerPage();
          }
      )
    );

  }

  @override
  void initState() {
    _nextPageToken = '';
    _scrollController = ScrollController();
    _videosList = VideosList();
    _videosList.videos = List();
    _FetchData();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  //RESULTATS
  @override
  Widget build(BuildContext context) {
    //print("RES'BASKET ->"+resultats.length.toString());
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child:   this.isLoadingWP | isLoadingYT | isLoadingTWT
          ? Center(
        child: Image.asset(
          'assets/gifs/green_style.gif', height: 25, width: 25,),
      )
          : InViewNotifierList(
        isInViewPortCondition: (double deltaTop, double deltaBottom, double viewPortDimension) {
          return deltaTop < (0.5 * viewPortDimension) &&
              deltaBottom > (0.5 * viewPortDimension);
        },
        itemCount: resultats.length,
        builder: (BuildContext context, int index) {
          return InViewNotifierWidget(
              id: '$index',
              builder: (BuildContext context, bool inView, Widget child) {
                if(index == 0 ){
                  return Column(
                    children: [
                      SizedBox(height: 20,),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: AdmobBanner(
                          adUnitId: 'ca-app-pub-9120523919163473/2499635678',
                          adSize: AdmobBannerSize.LARGE_BANNER,
                        ),
                      ),
                      resultats[index].content,
                    ],
                  );
                }
                else if(index != 0 && index%4 ==0) {
                  return Column(
                    children: [
                      SizedBox(height: 20,),
                      resultats[index].content,
                      Container(
                        padding: EdgeInsets.all(5),
                        child: AdmobBanner(
                          adUnitId: 'ca-app-pub-9120523919163473/2499635678',
                          adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                        ),
                      ),
                    ],
                  );
                }
                else {
                  return Column(
                    children: [
                      SizedBox(height: 20,),
                      resultats[index].content
                    ],
                  );
                }
              }
          );
        },
      ),
    );
    RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: this.isLoadingWP | isLoadingYT | isLoadingTWT
          ? Center(
        child: Image.asset(
          'assets/gifs/green_style.gif', height: 25, width: 25,),
      )
          : ListView.builder(
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        itemCount: resultats.length,
        itemBuilder: (BuildContext context, int index) {
          if(index == 0 ){
            return Column(
              children: [
                SizedBox(height: 20,),
                Container(
                  padding: EdgeInsets.all(5),
                  child: AdmobBanner(
                    adUnitId: 'ca-app-pub-9120523919163473/2499635678',
                    adSize: AdmobBannerSize.LARGE_BANNER,
                  ),
                ),
                resultats[index].content,
              ],
            );
          }
          else if(index != 0 && index%4 ==0) {
            return Column(
              children: [
                SizedBox(height: 20,),
                resultats[index].content,
                Container(
                  padding: EdgeInsets.all(5),
                  child: AdmobBanner(
                    adUnitId: 'ca-app-pub-9120523919163473/2499635678',
                    adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                  ),
                ),
              ],
            );
          }
          else {
            return Column(
              children: [
                SizedBox(height: 20,),
                resultats[index].content
              ],
            );
          }
        },
      ),
    );
    RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: this.isLoadingWP | isLoadingYT | isLoadingTWT
            ? Center(
          child: Image.asset(
            'assets/gifs/green_style.gif', height: 25, width: 25,),
        )
            : ListView(
          children: <Widget>[
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: results
            )
          ],
        )
    );
  }

}

//------------------------------------------------------------------------------//

class LandingPageBuzz extends StatefulWidget {
  LandingPageBuzz({Key key}): super(key: key);

  @override
  LandingPageBuzzState createState() => LandingPageBuzzState();
}

class LandingPageBuzzState extends State<LandingPageBuzz> with SingleTickerProviderStateMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();
  var  _json;

  ScrollController scrollController =new ScrollController();

  static const _adUnitID = "ca-app-pub-9120523919163473/1283696274";

  //VARIABLES
  ChannelInfo _channelInfo;
  VideosList _videosList;
  Item _item;
  bool isLoading = true;
  String _playListId;
  String _nextPageToken;

  //Resultat youtube
  List<Widget> results = List ();
  List<Result> resultats = List ();
  String pageToken = "";

  //CHARGEMENT DATA

  Future _getOneDataTwitter(String idTweet) async {
    setState(() {
      isLoading = true;
    });

    String consumerApiKey = "3hEda6a5H4hGr93fv8xKzIBte";
    String consumerApiSecret = "twkcvEDH8cHG6Uaja6VMDs9lsdPgDIzNDOatMWO8uItZQQChAk";
    String accessToken = "1486817757853372416-m7bveHgXbbK5vaInGvSkv83XccvPcS";
    String accessTokenSecret = "uLNvCRWvyQj4jyxWqNyVPCNwRejz7SoO6PuMGkpxAxXZx";

    final _twitterOauth = new twitterApi(
        consumerKey: consumerApiKey,
        consumerSecret: consumerApiSecret,
        token: accessToken,
        tokenSecret: accessTokenSecret
    );
    Future twitterRequest = _twitterOauth.getTwitterRequest(
      "GET",
      "statuses/show.json",
      options: {
        "id": idTweet,
        "include_entities": "true",
        "tweet_mode":"extended",
      },
    );

    var response = await twitterRequest;
    var data;
    var id;
    String txt;
    DateTime date;
    var _content;
    String media_url;
    String link;
    String type;
    List<Widget> caroussel = List();
    bool isCaroussel = false;

    String usr_id;
    String usr_img;
    String usr_name;
    String usr_scrname;

    if (response.statusCode == 200) {
      data =json.decode(response.body);
      _json = data;
      print("JSON -> $data");

      id = data['id'].toString();
      String _date = data['created_at'];
      date = FormatTwitterDate(_date);
      var media = data['entities']['media'];
      if(media == null) {
        var index_url = data['full_text'].toString().length-23;
        txt = data['full_text'].toString().substring(0, index_url);
      }
      else {
        var url = data['extended_entities']['media'][0]['url'];
        var index_url = data['full_text'].toString().indexOf(url);
        txt = data['full_text'].toString().substring(0, index_url);
        type = data['extended_entities']['media'][0]['type'];
        var size = data['extended_entities']['media'].length;
        // print("SIZE: $size");
        if(type=="photo") {
          if(size>1) {
            isCaroussel = true;
            for(int i = 0; i<size; i++) {
              caroussel.add(Image.network(data['extended_entities']['media'][i]['media_url_https']));
            }
          }
          else {
            isCaroussel =false;
            media_url = data['extended_entities']['media'][0]['media_url_https'];
          }
        }
        else {
          media_url =data['extended_entities']['media'][0]['video_info']['variants'][1]["url"];
          print("****************VIDEO URL: $media_url");
        }
      }
      link ="https://twitter.com/status/$id?ref_src=twsrc%5Etfw";

      usr_img = data['user']['profile_image_url_https'];
      usr_name = data['user']['name'];
      if(usr_name.length > 27) {
        usr_name = usr_name.split(" ")[0];
      }
      usr_scrname= data['user']['screen_name'];

      setState(() {
        isLoading = false;
      });

    } else {
      print(">>>>>>>>>>>>> NOUS AVONS UNE ERREUR DE CHARGEMENT TWIITER");
      print(response.statusCode);
    }
  }

  _getChannelInfo() async {
    _channelInfo = await Youtube_Service.getChannelInfo();
    _item = _channelInfo.items[0];
    _playListId = _item.contentDetails.relatedPlaylists.uploads;
    print('_playListId $_playListId');
    await _loadVideos();

    for(int i = 0; i<_videosList.videos.length; i++) {
      var date = _videosList.videos[i].video.publishedAt;
      var id = _videosList.videos[i].video.resourceId.videoId;
      var title = _videosList.videos[i].video.title;
      var link = "https://www.youtube.com/watch?v=$id";

      var content = PostCardExpYT(VideoItemId: id, VideoItemDate: date, VideoItemTitle: title, VideoItemLink: link);

      var res = Result(id,date,title,content,link, true);
      resultats.add(res);
      //results.add(resultats[i].content);
    }
    setState(() {
      isLoading = false;
    });
  }
  _loadVideos() async {
    VideosList tempVideosList = await Youtube_Service.getVideosList(
      playListId: _playListId,
      pageToken: _nextPageToken,
    );
    _nextPageToken = tempVideosList.nextPageToken;
    _videosList.videos.addAll(tempVideosList.videos);
    //print('videos: ${_videosList.videos.length}');
    //print('_nextPageToken $_nextPageToken');

    setState(() {});
  }



  @override
  void initState() {
    super.initState();
    isLoading = true;
    _nextPageToken = '';
    scrollController = ScrollController();
    _videosList = VideosList();
    _videosList.videos = List();
    //_getChannelInfo();
    //_getOneDataTwitter("1382389446058856455"); //CARD
    //_getOneDataTwitter("1386419433330167812"); //FAKE CARD
    //_getOneDataTwitter("1382632080954232838"); //TEXT
    //_getOneDataTwitter("1389356712935759872"); //TWEET SUPPRIMER
    _getOneDataTwitter("1383765438874587138"); // TWEET VIDEO SUPRIMER
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
  }

  //RESULTATS
  @override
  Widget build(BuildContext context) {
    return
      RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: this.isLoading
            ? Center(
          child: Image.asset(
            'assets/gifs/green_style.gif', height: 25, width: 25,),
        )
            : ListView.builder(
            controller: scrollController,
            itemCount: 1,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return SelectableText(_json.toString());
            }
        ),
      );
    RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: this.isLoading
            ? Center(
          child: Image.asset(
            'assets/gifs/green_style.gif', height: 25, width: 25,),
        )
            : ListView.builder(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          controller: scrollController,
          itemCount: resultats.length,
          itemBuilder: (BuildContext context, int index) {
            if(index == 0 ){
              return Column(
                children: [
                  SizedBox(height: 20,),
                  Container(
                    padding: EdgeInsets.all(5),
                    child: AdmobBanner(
                      adUnitId: 'ca-app-pub-9120523919163473/5738781727',
                      adSize: AdmobBannerSize.LARGE_BANNER,
                    ),
                  ),
                  resultats[index].content,
                ],
              );
            }
            else if(index != 0 && index%4 ==0) {
              return Column(
                children: [
                  SizedBox(height: 20,),
                  resultats[index].content,
                  Container(
                    padding: EdgeInsets.all(5),
                    child: AdmobBanner(
                      adUnitId: 'ca-app-pub-9120523919163473/6172909881',
                      adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                    ),
                  ),
                ],
              );
            }
            else {
              return Column(
                children: [
                  SizedBox(height: 20,),
                  resultats[index].content
                ],
              );
            }
          },
        ),
      );
      TwitterCardPlus(id: "1382389446058856455");

      RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: this.isLoading
          ? Center(
        child: Image.asset(
          'assets/gifs/green_style.gif', height: 25, width: 25,),
      )
          : ListView.builder(
        itemCount: resultats.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              resultats[index].content
            ],
          );
        },
      ),
    );
      RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: this.isLoading
          ? Center(
        child: Image.asset(
          'assets/gifs/green_style.gif', height: 25, width: 25,),
      )
          : ListView.builder(
          controller: scrollController,
          itemCount: 1,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return SelectableText(_json.toString());
          }
      ),
    );
    Center(child: Image.asset("assets/bug_img.jpeg"));
  }

  //REFRESH PAGE
  Future<Null> _refresh() async {
    //resultats = new List();
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      isLoading = true;
    });
    return _getChannelInfo();

  }
}

//------------------------------------------------------------------------------//
class LandingPageFoot extends StatefulWidget {
  @override
  _LandingPageFootState createState() => _LandingPageFootState();
}

class _LandingPageFootState extends State<LandingPageFoot> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  ScrollController _scrollController =new ScrollController();

  static const _adUnitID = "ca-app-pub-9120523919163473/1283696274";

//VARIABLES
  List<Result> resultats = List();
  List<FER> tmp = List();
  bool isLoadingWP=true;
  bool isLoadingTWT=true;
  bool isLoadingYT=true;

  //Rsultats Woordpress
  List<Result> results_wp = List();
  //Resultat youtube
  List<Result> results_yt_foot= List ();
  //Resultats Twitter
  List<Result> results_twt_foot= List ();


//CHARGEMENT DES DONNEES
  _FetchData() {
    _getDataWp();
    _getDataYt();
    _getDataTwitter();
  }
  //---> CHARGEMENT WP
  String url = "https://wiwsport.com/wp-json/wp/v2/posts?_embed&per_page=100&_fields=title,slug,content,date,categories,link,_links.wp:featuredmedia,_links.wp:term&categories=63,65,1514,71,67,66,1648,1649,9548,9244,6897,57778,57777,35409,22736,57714,22747,22748";
  List<Post> posts = List();
  int cpt=0;

  List<Widget> results=List();
  Future<void> _getDataWp() async {

    final response = await http.get(url);
    if(response.statusCode == 200) {
      posts =(json.decode(response.body) as List).map((data){
        return Post.fromJSON(data);
      }).toList();

      for(int i=0; i<posts.length; i++) {
        if(posts[i].content.contains("jeg_video_container")) {
          DateTime date = DateTime.parse(posts[i].date);
          String title = posts[i].title;
          String _type = "Youtube";
          var content = PostCardExp(post: posts[i], type: _type);
          String link = posts[i].link;
          String  tag  = "<iframe";
          String end_tag = "</iframe>";
          int startIndex = posts[i].content.indexOf(tag);
          int endIndex = posts[i].content.indexOf(end_tag)+end_tag.length;
          String _iframe = posts[i].content.substring(startIndex, endIndex);
          //print("---------------->iframe : $_iframe");
          String debut_src = "/embed/";
          int index_debut_src = _iframe.indexOf(debut_src)+debut_src.length;
          String fin_src ="?feature";
          int index_fin_src = _iframe.indexOf(fin_src);
          String src;

          if(index_fin_src != -1) {
            src = _iframe.substring(index_debut_src, index_fin_src);
          } else {
            src= "defaultID"+cpt.toString();
            cpt++;
          }
          //print("---------------->SRC: $src");
          var res = Result(src,date,title,content,link, true);
          bool isdoublon = false;
          for (int i =0; i<results_wp.length; i++){
            if(src == results_wp[i].id) {
              isdoublon =true;
            }
          }
          if(isdoublon == false){
            results_wp.add(res);
          }
        }
        if(posts[i].content.contains('twitter-tweet')) {
          DateTime date = DateTime.parse(posts[i].date);
          String title = posts[i].title;
          String link = posts[i].link;
          String  tag  = "<blockquote";
          String end_tag = "</blockquote>";
          int startIndex = posts[i].content.indexOf(tag);
          int endIndex = posts[i].content.indexOf(end_tag)+end_tag.length;
          String _blockquote = posts[i].content.substring(startIndex, endIndex);

          String debut_src = "/status/";
          int index_debut_src = _blockquote.indexOf(debut_src)+debut_src.length;
          String _bq = _blockquote.substring(index_debut_src);
          RegExp re = RegExp(r'(\d+)');
          String src =re.stringMatch(_bq);
          var content = TwitterCardPlus(id:src, isExplorer: true, title: posts[i].title);
          isVideo = content.isExplorerVideo;
          //print("---------------->SRC: $src");
          var res = Result(src,date,title,content,link, true);
          bool isdoublon = false;
          for (int i =0; i<results_wp.length; i++){
            if(src == results_wp[i].id) {
              isdoublon =true;
            }
          }
          if(isdoublon == false){
            results_wp.add(res);
          }
        }
        if(posts[i].content.contains("instagram-media")) {
          DateTime date = DateTime.parse(posts[i].date);
          String title = posts[i].title;
          String _type = "Instagram";
          var content = PostCardExp(post: posts[i], type: _type);
          String link = posts[i].link;
          String id="fakeID"+cpt.toString();
          cpt++;
          var res = Result(id,date,title,content,link, false);
          results_wp.add(res);
        }
        if (posts[i].content.contains('video.php')) {
          DateTime date = DateTime.parse(posts[i].date);
          String title = posts[i].title;
          String _type = "Facebook";

          String  tag  = "<iframe";
          String end_tag = "</iframe>";
          int startIndex = posts[i].content.indexOf(tag);
          int endIndex = posts[i].content.indexOf(end_tag)+end_tag.length;
          String _iframe = posts[i].content.substring(startIndex, endIndex);
          print("_IFRAME: $_iframe");

          String link = posts[i].link;
          String id="faceID"+cpt.toString();
          cpt++;
          var content = _iframeDisplayer(_iframe, title, _type, posts[i].date, link);
          var res = Result(id,date,title,content,link, true);
          bool isdoublon = false;
          for (int i =0; i<results_wp.length; i++){
            if(id == results_wp[i].id) {
              isdoublon =true;
            }
          }
          if(isdoublon == false){
            results_wp.add(res);
          }
        }
      }


      //resultats = resultats + results_wp;
      print('taille -> '+results_wp.length.toString());
      for(int i =0; i<results_wp.length; i++) {
        print("index -> $i");
        print('id -> '+results_wp[i].id.toString());
        for(int j =0; j<resultats.length; j++) {
          if(results_wp[i].id==resultats[j].id) {
            results_wp.removeWhere((item) => item.id==results_wp[i].id);
          }
        }
      }
      setState(() {
        resultats = resultats + results_wp;
        resultats.sort((b, a) => a.date.compareTo(b.date));
        isLoadingWP=false;
      });

    }
  }

  //---> CHARGEMENT TWITTER
  List tweets = List();
  List jsonFromTwitterAPI = List();
  Future _getDataTwitter() async {

    String consumerApiKey = "3hEda6a5H4hGr93fv8xKzIBte";
    String consumerApiSecret = "twkcvEDH8cHG6Uaja6VMDs9lsdPgDIzNDOatMWO8uItZQQChAk";
    String accessToken = "1486817757853372416-m7bveHgXbbK5vaInGvSkv83XccvPcS";
    String accessTokenSecret = "uLNvCRWvyQj4jyxWqNyVPCNwRejz7SoO6PuMGkpxAxXZx";

    final _twitterOauth = new twitterApi(
        consumerKey: consumerApiKey,
        consumerSecret: consumerApiSecret,
        token: accessToken,
        tokenSecret: accessTokenSecret
    );


    Future twitterRequest_foot = _twitterOauth.getTwitterRequest(
      "GET",
      "collections/entries.json",
      options: {
        "id": "custom-1366833082079326221",
        "count": "30",
        "tweet_mode":"extended",
      },
    );

    var res_foot = await twitterRequest_foot;

    if (res_foot.statusCode == 200)  {
      var _id;
      String _txt;
      DateTime _date;
      var _content;
      String _url;
      String video_img;
      String _link;
      String _type;
      List<ImageSlider> images = List();
      bool isCaroussel = false;

      String user_id;
      String user_image;
      String user_name;
      String user_screename;


      var data =json.decode(res_foot.body);
      var _taille =data['response']['timeline'].length;

      for (int i=0; i<_taille; i++) {
        _id =data['response']['timeline'][i]['tweet']['id'].toString();
        var date = data['objects']['tweets'][_id]['created_at'];
        _date = FormatTwitterDate(date);
        String toRemove;
        int indexToRemove;
        var media = data['objects']['tweets'][_id]['extended_entities'];
        if(media != null){

          _type = data['objects']['tweets'][_id]['extended_entities']['media'][0]['type'];
          _link = data['objects']['tweets'][_id]['extended_entities']['media'][0]['expanded_url'];
          int size = data['objects']['tweets'][_id]['extended_entities']['media'].length;
          if(_type=="photo"){
            isVideo = false;
            if(size>1) {
              isCaroussel = true;
              print("******caroussell de $_id");
              print("**************SIZE: "+size.toString());
              for(int i = 0; i<size; i++) {
                var lien = data['objects']['tweets'][_id]['extended_entities']['media'][i]['media_url_https'];
                int hauteur = data['objects']['tweets'][_id]['extended_entities']['media'][i]['sizes']['large']['h'];
                //print("HAUTEUR IMG -> "+hauteur.toString());
                var largeur= data['objects']['tweets'][_id]['extended_entities']['media'][i]['sizes']['large']['w'];
                //print("LARGEUR IMG -> "+largeur.toString());

                ImageSlider _img = ImageSlider(_id,lien, hauteur, largeur);
                images.add(_img);

              }
            }
            else {
              isCaroussel =false;
              images = new List();
              _url = data['objects']['tweets'][_id]['extended_entities']['media'][0]['media_url_https'];
            }
          }
          else if (_type=="video") {
            isVideo = true;
            video_img = data['objects']['tweets'][_id]['extended_entities']['media'][0]['media_url_https'];
            _url = data['objects']['tweets'][_id]['extended_entities']['media'][0]['video_info']['variants'][1]["url"];
          }
          else {
            isVideo = false;
            video_img = "";
            _url = "";
          }
          toRemove = data['objects']['tweets'][_id]['extended_entities']['media'][0]['url'];
        }
        String txt = data['objects']['tweets'][_id]['full_text'];
        if(toRemove!=null) {
          indexToRemove = txt.indexOf(toRemove);
          _txt = txt.substring(0, indexToRemove);
        } else {
          //int x = txt.length-23;
          _txt = txt;
        }

        user_id = data['objects']['tweets'][_id]['user']['id_str'];
        user_image = data['objects']['users'][user_id]['profile_image_url_https'];
        user_name = data['objects']['users'][user_id]['name'];
        user_screename = data['objects']['users'][user_id]['screen_name'];


        var link ="https://twitter.com/$user_screename/status/$_id";
        if(data['objects']['tweets'][_id]['entities']['media'] == null)  {
          print("**************TAILLE: "+images.length.toString());
          _content =  TwitterCard(id: _id, date:_date, txt: _txt, media_url: _url, type: _type,usr_img: user_image, usr_name: user_name, usr_scrname: user_screename,caroussel: images,isSlider: isCaroussel, isCard: true,link: link,);
          images =new List();
        }
        else {
          if(data['objects']['tweets'][_id]['extended_entities']==null) {
            _content= Container();
          }
          else {
            print("**************TAILLE: "+images.length.toString());
            _content =  TwitterCard(id: _id, date:_date, txt: _txt, media_url: _url, type: _type,usr_img: user_image, usr_name: user_name, usr_scrname: user_screename,caroussel: images,isSlider: isCaroussel, isCard: false, link: link,);
            images = new List();
          }
        }

        Result result = Result(_id,_date, '', _content, _link,isVideo);
        results_twt_foot.add(result);
      }
      for(int i =0; i<results_twt_foot.length; i++) {
        for (int j = 0; j < resultats.length; j++) {
          if (results_twt_foot[i].id == resultats[j].id) {
            results_twt_foot.removeWhere((item) =>
            item.id == results_twt_foot[i].id);
          }
        }
      }
      setState(() {
        resultats = resultats + results_wp;
        resultats.sort((b, a) => a.date.compareTo(b.date));
        isLoadingTWT=false;
      });
    } else {
      print(">>>>>>>>>>>>> NOUS AVONS UNE ERREUR DE CHARGEMENT TWIITER");
      print(res_foot.statusCode);
    }
  }

  //---> CHARGEMENT YOUTUBE
  static const _baseUrl = 'www.googleapis.com';
  _getDataYt() async {

    await loadsYTVideo_Foot();

    setState(() {
      resultats = resultats + results_yt_foot;
      resultats.sort((b, a) => a.date.compareTo(b.date));
      isLoadingYT = false;
    });
  }

  loadsYTVideo_Foot () async {
    Map<String, String> parameters = {
      'part': 'snippet, contentDetails',
      'playlistId': "PL68y_RTVo0Acw4zEfI-0aG78NcSejOzpt",
      'maxResults': '11',
      'key': Constants.KEY_YT,
    };
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/playlistItems',
      parameters,
    );
    Response response = await http.get(uri, headers: headers);
    if(response.statusCode==200) {
      var data = json.decode(response.body);
      var _date1 = data['items'][0]["contentDetails"]["videoPublishedAt"];
      DateTime date = DateTime.parse(_date1);
      var id_1 = data['items'][0]["snippet"]["resourceId"]["videoId"];
      var title_1 = data['items'][0]["snippet"]["title"];
      var link_1 = "https://www.youtube.com/watch?v=$id_1";
      var content_1 = PostCardExpYT(VideoItemId: id_1, VideoItemDate: date, VideoItemTitle: title_1, VideoItemLink: link_1);
      var res_1 = Result(id_1,date,title_1,content_1,link_1, true);

      var _date2 = data['items'][1]["snippet"]["publishedAt"];
      DateTime date2 = DateTime.parse(_date2);
      var id_2 = data['items'][1]["snippet"]["resourceId"]["videoId"];
      var title_2 = data['items'][1]["snippet"]["title"];
      var link_2 = "https://www.youtube.com/watch?v=$id_2";
      var content_2 = PostCardExpYT(VideoItemId: id_2, VideoItemDate: date2, VideoItemTitle: title_2, VideoItemLink: link_2);
      var res_2 = Result(id_2,date2,title_2,content_2,link_2, true);

      var _date3 = data['items'][2]["snippet"]["publishedAt"];
      DateTime date3 = DateTime.parse(_date3);
      var id_3 = data['items'][2]["snippet"]["resourceId"]["videoId"];
      var title_3 = data['items'][2]["snippet"]["title"];
      var link_3 = "https://www.youtube.com/watch?v=$id_3";
      var content_3 = PostCardExpYT(VideoItemId: id_3, VideoItemDate: date3, VideoItemTitle: title_3, VideoItemLink: link_3);
      var res_3 = Result(id_3,date3,title_3,content_3,link_3, true);

      var _date4 = data['items'][3]["snippet"]["publishedAt"];
      DateTime date4 = DateTime.parse(_date3);
      var id_4 = data['items'][3]["snippet"]["resourceId"]["videoId"];
      var title_4 = data['items'][3]["snippet"]["title"];
      var link_4 = "https://www.youtube.com/watch?v=$id_4";
      var content_4 = PostCardExpYT(VideoItemId: id_4, VideoItemDate: date4, VideoItemTitle: title_4, VideoItemLink: link_4);
      var res_4 = Result(id_4,date4,title_4,content_4,link_4, true);

      var _date5 = data['items'][4]["snippet"]["publishedAt"];
      DateTime date5 = DateTime.parse(_date5);
      var id_5 = data['items'][4]["snippet"]["resourceId"]["videoId"];
      var title_5 = data['items'][4]["snippet"]["title"];
      var link_5 = "https://www.youtube.com/watch?v=$id_5";
      var content_5 = PostCardExpYT(VideoItemId: id_5, VideoItemDate: date5, VideoItemTitle: title_5, VideoItemLink: link_5);
      var res_5 = Result(id_5,date5,title_5,content_5,link_5, true);

      var _date6 = data['items'][5]["snippet"]["publishedAt"];
      DateTime date6 = DateTime.parse(_date6);
      var id_6 = data['items'][5]["snippet"]["resourceId"]["videoId"];
      var title_6 = data['items'][5]["snippet"]["title"];
      var link_6 = "https://www.youtube.com/watch?v=$id_6";
      var content_6 = PostCardExpYT(VideoItemId: id_6, VideoItemDate: date6, VideoItemTitle: title_6, VideoItemLink: link_6);
      var res_6 = Result(id_6,date6,title_6,content_6,link_6, true);

      var _date7 = data['items'][6]["snippet"]["publishedAt"];
      DateTime date7 = DateTime.parse(_date7);
      var id_7 = data['items'][6]["snippet"]["resourceId"]["videoId"];
      var title_7 = data['items'][6]["snippet"]["title"];
      var link_7 = "https://www.youtube.com/watch?v=$id_7";
      var content_7 = PostCardExpYT(VideoItemId: id_7, VideoItemDate: date7, VideoItemTitle: title_7, VideoItemLink: link_7);
      var res_7 = Result(id_7,date7,title_7,content_7,link_7, true);

      var _date8 = data['items'][7]["snippet"]["publishedAt"];
      DateTime date8 = DateTime.parse(_date8);
      var id_8 = data['items'][7]["snippet"]["resourceId"]["videoId"];
      var title_8 = data['items'][7]["snippet"]["title"];
      var link_8 = "https://www.youtube.com/watch?v=$id_8";
      var content_8 = PostCardExpYT(VideoItemId: id_8, VideoItemDate: date8, VideoItemTitle: title_8, VideoItemLink: link_8);
      var res_8 = Result(id_8,date8,title_8,content_8,link_8, true);

      var _date9 = data['items'][8]["snippet"]["publishedAt"];
      DateTime date9 = DateTime.parse(_date8);
      var id_9 = data['items'][8]["snippet"]["resourceId"]["videoId"];
      var title_9 = data['items'][8]["snippet"]["title"];
      var link_9 = "https://www.youtube.com/watch?v=$id_9";
      var content_9 = PostCardExpYT(VideoItemId: id_9, VideoItemDate: date9, VideoItemTitle: title_9, VideoItemLink: link_9);
      var res_9 = Result(id_9,date9,title_9,content_9,link_9, true);

      var _date0 = data['items'][9]["snippet"]["publishedAt"];
      DateTime date0 = DateTime.parse(_date0);
      var id_0 = data['items'][9]["snippet"]["resourceId"]["videoId"];
      var title_0 = data['items'][9]["snippet"]["title"];
      var link_0 = "https://www.youtube.com/watch?v=$id_0";
      var content_0 = PostCardExpYT(VideoItemId: id_0, VideoItemDate: date0, VideoItemTitle: title_0, VideoItemLink: link_0);
      var res_0 = Result(id_0,date0,title_0,content_0,link_0, true);

      results_yt_foot.add(res_1);
      results_yt_foot.add(res_2);
      results_yt_foot.add(res_3);
      results_yt_foot.add(res_4);
      results_yt_foot.add(res_5);
      results_yt_foot.add(res_6);
      results_yt_foot.add(res_7);
      results_yt_foot.add(res_8);
      results_yt_foot.add(res_9);
      results_yt_foot.add(res_0);

      for(int i =0; i<results_yt_foot.length; i++) {
        print("index -> $i");
        print('id -> ' + results_yt_foot[i].id.toString());
        for (int j = 0; j < resultats.length; j++) {
          if (results_yt_foot[i].id == resultats[j].id) {
            results_yt_foot.removeWhere((item) =>
            item.id == results_yt_foot[i].id);
          }
        }
      }
    }
    else {
      print(">>>>>>>>>>>>> NOUS AVONS UNE ERREUR DE CHARGEMENT YOUTUBE");
      print(response.statusCode);
    }

  }

  @override
  void initState() {
    _FetchData();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  //RESULTATS
  @override
  Widget build(BuildContext context) {
    //print("RES'BASKET ->"+resultats.length.toString());
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child:   this.isLoadingWP | isLoadingYT | isLoadingTWT
          ? Center(
        child: Image.asset(
          'assets/gifs/green_style.gif', height: 25, width: 25,),
      )
          : InViewNotifierList(
        isInViewPortCondition: (double deltaTop, double deltaBottom, double viewPortDimension) {
          return deltaTop < (0.5 * viewPortDimension) &&
              deltaBottom > (0.5 * viewPortDimension);
        },
        itemCount: resultats.length,
        builder: (BuildContext context, int index) {
          return InViewNotifierWidget(
              id: '$index',
              builder: (BuildContext context, bool inView, Widget child) {
                if(index == 0 ){
                  return Column(
                    children: [
                      SizedBox(height: 20,),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: AdmobBanner(
                          adUnitId: 'ca-app-pub-9120523919163473/2499635678',
                          adSize: AdmobBannerSize.LARGE_BANNER,
                        ),
                      ),
                      resultats[index].content,
                    ],
                  );
                }
                else if(index != 0 && index%4 ==0) {
                  return Column(
                    children: [
                      SizedBox(height: 20,),
                      resultats[index].content,
                      Container(
                        padding: EdgeInsets.all(5),
                        child: AdmobBanner(
                          adUnitId: 'ca-app-pub-9120523919163473/2499635678',
                          adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                        ),
                      ),
                    ],
                  );
                }
                else {
                  return Column(
                    children: [
                      SizedBox(height: 20,),
                      resultats[index].content
                    ],
                  );
                }
              }
          );
        },
      ),
    );
    RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: this.isLoadingWP | isLoadingYT | isLoadingTWT
          ? Center(
        child: Image.asset(
          'assets/gifs/green_style.gif', height: 25, width: 25,),
      )
          : ListView.builder(
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        itemCount: resultats.length,
        itemBuilder: (BuildContext context, int index) {
          if(index == 0 ){
            return Column(
              children: [
                SizedBox(height: 20,),
                Container(
                  padding: EdgeInsets.all(5),
                  child: AdmobBanner(
                    adUnitId: 'ca-app-pub-9120523919163473/2499635678',
                    adSize: AdmobBannerSize.LARGE_BANNER,
                  ),
                ),
                resultats[index].content,
              ],
            );
          }
          else if(index != 0 && index%4 ==0) {
            return Column(
              children: [
                SizedBox(height: 20,),
                resultats[index].content,
                Container(
                  padding: EdgeInsets.all(5),
                  child: AdmobBanner(
                    adUnitId: 'ca-app-pub-9120523919163473/2499635678',
                    adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                  ),
                ),
              ],
            );
          }
          else {
            return Column(
              children: [
                SizedBox(height: 20,),
                resultats[index].content
              ],
            );
          }
        },
      ),
    );
    RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: this.isLoadingWP | isLoadingYT | isLoadingTWT
            ? Center(
          child: Image.asset(
            'assets/gifs/green_style.gif', height: 25, width: 25,),
        )
            : ListView(
          children: <Widget>[
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: results
            )
          ],
        )
    );
  }

  //REFRESH PAGE
  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (content) {
              return ExplorerFootPage();
            }
        )
    );
  }
}

//------------------------------------------------------------------------------//
class LandingPageBasket extends StatefulWidget {
  @override
  _LandingPageBasketState createState() => _LandingPageBasketState();
}

class _LandingPageBasketState extends State<LandingPageBasket> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  ScrollController _scrollController =new ScrollController();

  static const _adUnitID = "ca-app-pub-9120523919163473/1283696274";

//VARIABLES
  List<Result> resultats = List();
  List<Widget> results = List();
  List<FER> tmp = List();
  bool isLoadingWP=true;
  //Rsultats Woordpress
  List<Result> results_wp = List();
  //Resultat youtube
  List<Result> results_yt_basket= List ();
  bool isLoadingYT=true;
  //Resultats Twitter
  List<Result> results_twt_basket= List ();
  bool isLoadingTWT=true;


//CHARGEMENT DES DONNEES
  _FetchData() {
    _getDataWp();
    _getDataTwitter();
    _getDataYt();
  }
  //---> CHARGEMENT WP
  String url = "https://wiwsport.com/wp-json/wp/v2/posts?_embed&per_page=100&_fields=title,slug,content,date,categories,link,_links.wp:featuredmedia,_links.wp:term&categories=75,32401,32402,1520,7987,6563,83,82";
  List<Post> posts = List();
  int cpt=0;
  Future<void> _getDataWp() async {
    final response = await http.get(url);
    if(response.statusCode == 200) {
      posts =(json.decode(response.body) as List).map((data){
        return Post.fromJSON(data);
      }).toList();

      for(int i=0; i<posts.length; i++) {
        if(posts[i].content.contains("jeg_video_container")) {
          DateTime date = DateTime.parse(posts[i].date);
          String title = posts[i].title;
          String _type = "Youtube";
          var content = PostCardExp(post: posts[i], type: _type);
          String link = posts[i].link;
          String  tag  = "<iframe";
          String end_tag = "</iframe>";
          int startIndex = posts[i].content.indexOf(tag);
          int endIndex = posts[i].content.indexOf(end_tag)+end_tag.length;
          String _iframe = posts[i].content.substring(startIndex, endIndex);
          //print("---------------->iframe : $_iframe");
          String debut_src = "/embed/";
          int index_debut_src = _iframe.indexOf(debut_src)+debut_src.length;
          String fin_src ="?feature";
          int index_fin_src = _iframe.indexOf(fin_src);
          String src;

          if(index_fin_src != -1) {
            src = _iframe.substring(index_debut_src, index_fin_src);
          } else {
            src= "defaultID"+cpt.toString();
            cpt++;
          }
          //print("---------------->SRC: $src");
          var res = Result(src,date,title,content,link, true);
          bool isdoublon = false;
          for (int i =0; i<results_wp.length; i++){
            if(src == results_wp[i].id) {
              isdoublon =true;
            }
          }
          if(isdoublon == false){
            results_wp.add(res);
          }
        }
        if(posts[i].content.contains('twitter-tweet')) {
          DateTime date = DateTime.parse(posts[i].date);
          String title = posts[i].title;
          String link = posts[i].link;
          String  tag  = "<blockquote";
          String end_tag = "</blockquote>";
          int startIndex = posts[i].content.indexOf(tag);
          int endIndex = posts[i].content.indexOf(end_tag)+end_tag.length;
          String _blockquote = posts[i].content.substring(startIndex, endIndex);

          String debut_src = "/status/";
          int index_debut_src = _blockquote.indexOf(debut_src)+debut_src.length;
          String _bq = _blockquote.substring(index_debut_src);
          RegExp re = RegExp(r'(\d+)');
          String src =re.stringMatch(_bq);
          var content = TwitterCardPlus(id:src, isExplorer: true, title: posts[i].title);
          isVideo = content.isExplorerVideo;
          //print("---------------->SRC: $src");
          var res = Result(src,date,title,content,link, true);
          bool isdoublon = false;
          for (int i =0; i<results_wp.length; i++){
            if(src == results_wp[i].id) {
              isdoublon =true;
            }
          }
          if(isdoublon == false){
            results_wp.add(res);
          }
        }
        if(posts[i].content.contains("instagram-media")) {
          DateTime date = DateTime.parse(posts[i].date);
          String title = posts[i].title;
          String _type = "Instagram";
          var content = PostCardExp(post: posts[i], type: _type);
          String link = posts[i].link;
          String id="fakeID"+cpt.toString();
          cpt++;
          var res = Result(id,date,title,content,link, false);
          results_wp.add(res);
        }
        if (posts[i].content.contains('video.php')) {
          DateTime date = DateTime.parse(posts[i].date);
          String title = posts[i].title;
          String _type = "Facebook";

          String  tag  = "<iframe";
          String end_tag = "</iframe>";
          int startIndex = posts[i].content.indexOf(tag);
          int endIndex = posts[i].content.indexOf(end_tag)+end_tag.length;
          String _iframe = posts[i].content.substring(startIndex, endIndex);
          print("_IFRAME: $_iframe");

          String link = posts[i].link;
          String id="faceID"+cpt.toString();
          cpt++;
          var content = _iframeDisplayer(_iframe, title, _type, posts[i].date, link);
          var res = Result(id,date,title,content,link, true);
          bool isdoublon = false;
          for (int i =0; i<results_wp.length; i++){
            if(id == results_wp[i].id) {
              isdoublon =true;
            }
          }
          if(isdoublon == false){
            results_wp.add(res);
          }
        }
      }


      //resultats = resultats + results_wp;
      //print('taille -> '+results_wp.length.toString());
      setState(() {
        resultats = resultats + results_wp;
        resultats.sort((b, a) => a.date.compareTo(b.date));
        isLoadingWP=false;
      });

    }
  }

  //---> CHARGEMENT TWITTER
  List tweets = List();
  List jsonFromTwitterAPI = List();
  Future _getDataTwitter() async {

    String consumerApiKey = "3hEda6a5H4hGr93fv8xKzIBte";
    String consumerApiSecret = "twkcvEDH8cHG6Uaja6VMDs9lsdPgDIzNDOatMWO8uItZQQChAk";
    String accessToken = "1486817757853372416-m7bveHgXbbK5vaInGvSkv83XccvPcS";
    String accessTokenSecret = "uLNvCRWvyQj4jyxWqNyVPCNwRejz7SoO6PuMGkpxAxXZx";

    final _twitterOauth = new twitterApi(
        consumerKey: consumerApiKey,
        consumerSecret: consumerApiSecret,
        token: accessToken,
        tokenSecret: accessTokenSecret
    );


    Future twitterRequest_basket = _twitterOauth.getTwitterRequest(
      "GET",
      "collections/entries.json",
      options: {
        "id": "custom-1366833135124643854",
        "count": "11",
        "tweet_mode":"extended",
      },
    );

    var res_basket = await twitterRequest_basket;

    if (res_basket.statusCode == 200) {
      var _id;
      String _txt;
      DateTime _date;
      var _content;
      String _url;
      String video_img;
      String _link;
      String _type;
      List<ImageSlider> images = List();
      List<String> H = List();
      List<String> L = List();
      bool isCaroussel = false;

      String user_id;
      String user_image;
      String user_name;
      String user_screename;


      var data =json.decode(res_basket.body);
      var _taille =data['response']['timeline'].length;

      for (int i=0; i<_taille; i++) {
        _id =data['response']['timeline'][i]['tweet']['id'].toString();
        var date = data['objects']['tweets'][_id]['created_at'];
        _date = FormatTwitterDate(date);
        String toRemove;
        int indexToRemove;
        var media = data['objects']['tweets'][_id]['extended_entities'];
        if(media != null){
          _type = data['objects']['tweets'][_id]['extended_entities']['media'][0]['type'];
          _link = data['objects']['tweets'][_id]['extended_entities']['media'][0]['expanded_url'];
          int size = data['objects']['tweets'][_id]['extended_entities']['media'].length;
          if(_type=="photo"){
            isVideo = false;
            if(size>1) {
              isCaroussel = true;
              print("******caroussell de $_id");
              print("**************SIZE: "+size.toString());
              for(int i = 0; i<size; i++) {
                var lien = data['objects']['tweets'][_id]['extended_entities']['media'][i]['media_url_https'];
                int hauteur = data['objects']['tweets'][_id]['extended_entities']['media'][i]['sizes']['large']['h'];
                print("HAUTEUR IMG -> "+hauteur.toString());
                var largeur= data['objects']['tweets'][_id]['extended_entities']['media'][i]['sizes']['large']['w'];
                print("LARGEUR IMG -> "+largeur.toString());

                ImageSlider _img = ImageSlider(_id,lien, hauteur, largeur);
                images.add(_img);
              }
            }
            else {
              isCaroussel =false;
              images = new List();
              _url = data['objects']['tweets'][_id]['extended_entities']['media'][0]['media_url_https'];
            }
          }
          else if (_type=="video") {
            isVideo = true;
            video_img = data['objects']['tweets'][_id]['extended_entities']['media'][0]['media_url_https'];
            _url = data['objects']['tweets'][_id]['extended_entities']['media'][0]['video_info']['variants'][1]["url"];
          }
          else {
            isVideo = false;
            video_img = "";
            _url = "";
          }
          toRemove = data['objects']['tweets'][_id]['extended_entities']['media'][0]['url'];
        }
        var fav_count = data['objects']['tweets'][_id]['favorite_count'];
        String txt = data['objects']['tweets'][_id]['full_text'];
        if(toRemove!=null) {
          indexToRemove = txt.indexOf(toRemove);
          _txt = txt.substring(0, indexToRemove);
        } else {
          //int x = txt.length-23;
          _txt = txt;
        }

        user_id = data['objects']['tweets'][_id]['user']['id_str'];
        user_image = data['objects']['users'][user_id]['profile_image_url_https'];
        user_name = data['objects']['users'][user_id]['name'];
        user_screename = data['objects']['users'][user_id]['screen_name'];

        var link ="https://twitter.com/$user_screename/status/$_id";
        if(data['objects']['tweets'][_id]['entities']['media'] == null)  {
          _content =  TwitterCard(id: _id, date:_date, txt: _txt, media_url: _url, type: _type,usr_img: user_image, usr_name: user_name, usr_scrname: user_screename,caroussel: images,isSlider: isCaroussel, isCard: true,link: link,);
          images=List();
        }
        else {
          if(data['objects']['tweets'][_id]['extended_entities']==null) {
            _content= Container();
          }
          else {
            _content =  TwitterCard(id: _id, date:_date, txt: _txt, media_url: _url, type: _type,usr_img: user_image, usr_name: user_name, usr_scrname: user_screename,caroussel: images,isSlider: isCaroussel, isCard: false, link: link,);
            images=List();
          }
        }



        Result result = Result(_id,_date, '', _content, _link,isVideo);
        results_twt_basket.add(result);
      }
      for(int i =0; i<results_twt_basket.length; i++) {
        // print("index -> $i");
        //print('id -> ' + results_twt_basket[i].id.toString());
        for (int j = 0; j < resultats.length; j++) {
          if (results_twt_basket[i].id == resultats[j].id) {
            results_twt_basket.removeWhere((item) =>
            item.id == results_twt_basket[i].id);
          }
        }
      }
      setState(() {
        resultats = resultats + results_twt_basket;
        resultats.sort((b, a) => a.date.compareTo(b.date));
        isLoadingTWT = false;
      });
    }  else {
      print(">>>>>>>>>>>>> NOUS AVONS UNE ERREUR DE CHARGEMENT TWIITER");
      print(res_basket.statusCode);
    }
  }

  //---> CHARGEMENT YOUTUBE
  static const _baseUrl = 'www.googleapis.com';
  _getDataYt() async {

    await loadsYTVideo_Basket();

    setState(() {
      resultats = resultats + results_yt_basket;
      resultats.sort((b, a) => a.date.compareTo(b.date));
      isLoadingYT = false;
    });
  }
  loadsYTVideo_Basket () async {
    //PL68y_RTVo0AejKQQAIGEaps3Uw_nMbuVm
    Map<String, String> parameters = {
      'part': 'snippet, contentDetails',
      'playlistId': "PL68y_RTVo0AejKQQAIGEaps3Uw_nMbuVm",
      'maxResults': '11',
      'key': Constants.KEY_YT,
    };
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/playlistItems',
      parameters,
    );
    Response response = await http.get(uri, headers: headers);
    if(response.statusCode==200) {
      var data = json.decode(response.body);
      var _date1 = data['items'][0]["contentDetails"]["videoPublishedAt"];
      DateTime date = DateTime.parse(_date1);
      var id_1 = data['items'][0]["snippet"]["resourceId"]["videoId"];
      var title_1 = data['items'][0]["snippet"]["title"];
      var link_1 = "https://www.youtube.com/watch?v=$id_1";
      var content_1 = PostCardExpYT(VideoItemId: id_1, VideoItemDate: date, VideoItemTitle: title_1, VideoItemLink: link_1);
      var res_1 = Result(id_1,date,title_1,content_1,link_1, true);

      var _date2 = data['items'][1]["contentDetails"]["videoPublishedAt"];
      DateTime date2 = DateTime.parse(_date2);
      var id_2 = data['items'][1]["snippet"]["resourceId"]["videoId"];
      var title_2 = data['items'][1]["snippet"]["title"];
      var link_2 = "https://www.youtube.com/watch?v=$id_2";
      var content_2 = PostCardExpYT(VideoItemId: id_2, VideoItemDate: date2, VideoItemTitle: title_2, VideoItemLink: link_2);
      var res_2 = Result(id_2,date2,title_2,content_2,link_2, true);

      var _date3 = data['items'][2]["contentDetails"]["videoPublishedAt"];
      DateTime date3 = DateTime.parse(_date3);
      var id_3 = data['items'][2]["snippet"]["resourceId"]["videoId"];
      var title_3 = data['items'][2]["snippet"]["title"];
      var link_3 = "https://www.youtube.com/watch?v=$id_3";
      var content_3 = PostCardExpYT(VideoItemId: id_3, VideoItemDate: date3, VideoItemTitle: title_3, VideoItemLink: link_3);
      var res_3 = Result(id_3,date3,title_3,content_3,link_3, true);

      var _date4 = data['items'][3]["contentDetails"]["videoPublishedAt"];
      DateTime date4 = DateTime.parse(_date3);
      var id_4 = data['items'][3]["snippet"]["resourceId"]["videoId"];
      var title_4 = data['items'][3]["snippet"]["title"];
      var link_4 = "https://www.youtube.com/watch?v=$id_4";
      var content_4 = PostCardExpYT(VideoItemId: id_4, VideoItemDate: date4, VideoItemTitle: title_4, VideoItemLink: link_4);
      var res_4 = Result(id_4,date4,title_4,content_4,link_4, true);

      var _date5 = data['items'][4]["contentDetails"]["videoPublishedAt"];
      DateTime date5 = DateTime.parse(_date5);
      var id_5 = data['items'][4]["snippet"]["resourceId"]["videoId"];
      var title_5 = data['items'][4]["snippet"]["title"];
      var link_5 = "https://www.youtube.com/watch?v=$id_5";
      var content_5 = PostCardExpYT(VideoItemId: id_5, VideoItemDate: date5, VideoItemTitle: title_5, VideoItemLink: link_5);
      var res_5 = Result(id_5,date5,title_5,content_5,link_5, true);

      var _date6 = data['items'][5]["contentDetails"]["videoPublishedAt"];
      DateTime date6 = DateTime.parse(_date6);
      var id_6 = data['items'][5]["snippet"]["resourceId"]["videoId"];
      var title_6 = data['items'][5]["snippet"]["title"];
      var link_6 = "https://www.youtube.com/watch?v=$id_6";
      var content_6 = PostCardExpYT(VideoItemId: id_6, VideoItemDate: date6, VideoItemTitle: title_6, VideoItemLink: link_6);
      var res_6 = Result(id_6,date6,title_6,content_6,link_6, true);

      var _date7 = data['items'][6]["contentDetails"]["videoPublishedAt"];
      DateTime date7 = DateTime.parse(_date7);
      var id_7 = data['items'][6]["snippet"]["resourceId"]["videoId"];
      var title_7 = data['items'][6]["snippet"]["title"];
      var link_7 = "https://www.youtube.com/watch?v=$id_7";
      var content_7 = PostCardExpYT(VideoItemId: id_7, VideoItemDate: date7, VideoItemTitle: title_7, VideoItemLink: link_7);
      var res_7 = Result(id_7,date7,title_7,content_7,link_7, true);

      var _date8 = data['items'][7]["contentDetails"]["videoPublishedAt"];
      DateTime date8 = DateTime.parse(_date8);
      var id_8 = data['items'][7]["snippet"]["resourceId"]["videoId"];
      var title_8 = data['items'][7]["snippet"]["title"];
      var link_8 = "https://www.youtube.com/watch?v=$id_8";
      var content_8 = PostCardExpYT(VideoItemId: id_8, VideoItemDate: date8, VideoItemTitle: title_8, VideoItemLink: link_8);
      var res_8 = Result(id_8,date8,title_8,content_8,link_8, true);

      var _date9 = data['items'][8]["contentDetails"]["videoPublishedAt"];
      DateTime date9 = DateTime.parse(_date8);
      var id_9 = data['items'][8]["snippet"]["resourceId"]["videoId"];
      var title_9 = data['items'][8]["snippet"]["title"];
      var link_9 = "https://www.youtube.com/watch?v=$id_9";
      var content_9 = PostCardExpYT(VideoItemId: id_9, VideoItemDate: date9, VideoItemTitle: title_9, VideoItemLink: link_9);
      var res_9 = Result(id_9,date9,title_9,content_9,link_9, true);

      var _date0 = data['items'][9]["contentDetails"]["videoPublishedAt"];
      DateTime date0 = DateTime.parse(_date0);
      var id_0 = data['items'][9]["snippet"]["resourceId"]["videoId"];
      var title_0 = data['items'][9]["snippet"]["title"];
      var link_0 = "https://www.youtube.com/watch?v=$id_0";
      var content_0 = PostCardExpYT(VideoItemId: id_0, VideoItemDate: date0, VideoItemTitle: title_0, VideoItemLink: link_0);
      var res_0 = Result(id_0,date0,title_0,content_0,link_0, true);

      results_yt_basket.add(res_1);
      results_yt_basket.add(res_2);
      results_yt_basket.add(res_3);
      results_yt_basket.add(res_4);
      results_yt_basket.add(res_5);
      results_yt_basket.add(res_6);
      results_yt_basket.add(res_7);
      results_yt_basket.add(res_8);
      results_yt_basket.add(res_9);
      results_yt_basket.add(res_0);

      for(int i =0; i<results_yt_basket.length; i++) {
        print("index -> $i");
        print('id -> ' + results_yt_basket[i].id.toString());
        for (int j = 0; j < resultats.length; j++) {
          if (results_yt_basket[i].id == resultats[j].id) {
            results_yt_basket.removeWhere((item) =>
            item.id == results_yt_basket[i].id);
          }
        }
      }
    }
    else {
      print(">>>>>>>>>>>>> NOUS AVONS UNE ERREUR DE CHARGEMENT YOUTUBE");
      print(response.statusCode);
    }

  }

  @override
  void initState() {
    _FetchData();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }



  //RESULTATS
  @override
  Widget build(BuildContext context) {
    //print("RES'BASKET ->"+resultats.length.toString());
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child:   this.isLoadingWP | isLoadingYT | isLoadingTWT
          ? Center(
        child: Image.asset(
          'assets/gifs/green_style.gif', height: 25, width: 25,),
      )
          : InViewNotifierList(
        isInViewPortCondition: (double deltaTop, double deltaBottom, double viewPortDimension) {
          return deltaTop < (0.5 * viewPortDimension) &&
              deltaBottom > (0.5 * viewPortDimension);
        },
        itemCount: resultats.length,
        builder: (BuildContext context, int index) {
          return InViewNotifierWidget(
              id: '$index',
              builder: (BuildContext context, bool inView, Widget child) {
                if(index == 0 ){
                  return Column(
                    children: [
                      SizedBox(height: 20,),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: AdmobBanner(
                          adUnitId: 'ca-app-pub-9120523919163473/2499635678',
                          adSize: AdmobBannerSize.LARGE_BANNER,
                        ),
                      ),
                      resultats[index].content,
                    ],
                  );
                }
                else if(index != 0 && index%4 ==0) {
                  return Column(
                    children: [
                      SizedBox(height: 20,),
                      resultats[index].content,
                      Container(
                        padding: EdgeInsets.all(5),
                        child: AdmobBanner(
                          adUnitId: 'ca-app-pub-9120523919163473/2499635678',
                          adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                        ),
                      ),
                    ],
                  );
                }
                else {
                  return Column(
                    children: [
                      SizedBox(height: 20,),
                      resultats[index].content
                    ],
                  );
                }
              }
          );
        },
      ),
    );
      RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: this.isLoadingWP | isLoadingYT | isLoadingTWT
          ? Center(
        child: Image.asset(
          'assets/gifs/green_style.gif', height: 25, width: 25,),
      )
          : ListView.builder(
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        itemCount: resultats.length,
        itemBuilder: (BuildContext context, int index) {
          if(index == 0 ){
            return Column(
              children: [
                SizedBox(height: 20,),
                Container(
                  padding: EdgeInsets.all(5),
                  child: AdmobBanner(
                    adUnitId: 'ca-app-pub-9120523919163473/2499635678',
                    adSize: AdmobBannerSize.LARGE_BANNER,
                  ),
                ),
                resultats[index].content,
              ],
            );
          }
          else if(index != 0 && index%4 ==0) {
            return Column(
              children: [
                SizedBox(height: 20,),
                resultats[index].content,
                Container(
                  padding: EdgeInsets.all(5),
                  child: AdmobBanner(
                    adUnitId: 'ca-app-pub-9120523919163473/2499635678',
                    adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                  ),
                ),
              ],
            );
          }
          else {
            return Column(
              children: [
                SizedBox(height: 20,),
                resultats[index].content
              ],
            );
          }
        },
      ),
    );
    RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: this.isLoadingWP | isLoadingYT | isLoadingTWT
            ? Center(
          child: Image.asset(
            'assets/gifs/green_style.gif', height: 25, width: 25,),
        )
            : ListView(
          children: <Widget>[
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: results
            )
          ],
        )
    );
  }

  //REFRESH PAGE
  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (content) {
              return ExplorerBasketPage();
            }
        )
    );
  }
}

//------------------------------------------------------------------------------//
class LandingPageCombat extends StatefulWidget {
  @override
  _LandingPageCombatState createState() => _LandingPageCombatState();
}

class _LandingPageCombatState extends State<LandingPageCombat> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  ScrollController _scrollController =new ScrollController();

  static const _adUnitID = "ca-app-pub-9120523919163473/1283696274";

//VARIABLES
  List<Result> resultats = List();
  List<Widget> results = List();
  bool isLoadingWP=true;
  bool isLoadingTWT=true;
  bool isLoadingYT=true;
  //Rsultats Woordpress
  List<Result> results_wp = List();
  //Resultat youtube
  List<Result> results_yt_combat= List ();
  //Resultats Twitter
  List<Result> results_twt_combat= List ();

//CHARGEMENT DES DONNEES
  _FetchData() {
    _getDataWp();
    _getDataTwitter();
    _getDataYt();
  }
  //---> CHARGEMENT WP
  String url = "https://wiwsport.com/wp-json/wp/v2/posts?_embed&per_page=100&_fields=title,slug,content,date,categories,link,_links.wp:featuredmedia,_links.wp:term&categories=72,22741";
  List<Post> posts = List();
  List<FER> tmp = List();
  int cpt=0;
  Future<void> _getDataWp() async {

    final response = await http.get(url);
    if(response.statusCode == 200) {
      posts =(json.decode(response.body) as List).map((data){
        return Post.fromJSON(data);
      }).toList();

      for(int i=0; i<posts.length; i++) {
        if(posts[i].content.contains("jeg_video_container")) {
          DateTime date = DateTime.parse(posts[i].date);
          String title = posts[i].title;
          String _type = "Youtube";
          var content = PostCardExp(post: posts[i], type: _type);
          String link = posts[i].link;
          String  tag  = "<iframe";
          String end_tag = "</iframe>";
          int startIndex = posts[i].content.indexOf(tag);
          int endIndex = posts[i].content.indexOf(end_tag)+end_tag.length;
          String _iframe = posts[i].content.substring(startIndex, endIndex);
          //print("---------------->iframe : $_iframe");
          String debut_src = "/embed/";
          int index_debut_src = _iframe.indexOf(debut_src)+debut_src.length;
          String fin_src ="?feature";
          int index_fin_src = _iframe.indexOf(fin_src);
          String src;

          if(index_fin_src != -1) {
            src = _iframe.substring(index_debut_src, index_fin_src);
          } else {
            src= "defaultID"+cpt.toString();
            cpt++;
          }
          //print("---------------->SRC: $src");
          var res = Result(src,date,title,content,link, true);
          bool isdoublon = false;
          for (int i =0; i<results_wp.length; i++){
            if(src == results_wp[i].id) {
              isdoublon =true;
            }
          }
          if(isdoublon == false){
            results_wp.add(res);
          }
        }
        if(posts[i].content.contains('twitter-tweet')) {
          DateTime date = DateTime.parse(posts[i].date);
          String title = posts[i].title;
          String link = posts[i].link;
          String  tag  = "<blockquote";
          String end_tag = "</blockquote>";
          int startIndex = posts[i].content.indexOf(tag);
          int endIndex = posts[i].content.indexOf(end_tag)+end_tag.length;
          String _blockquote = posts[i].content.substring(startIndex, endIndex);

          String debut_src = "/status/";
          int index_debut_src = _blockquote.indexOf(debut_src)+debut_src.length;
          String _bq = _blockquote.substring(index_debut_src);
          RegExp re = RegExp(r'(\d+)');
          String src =re.stringMatch(_bq);
          var content = TwitterCardPlus(id:src, isExplorer: true, title: posts[i].title);
          isVideo = content.isExplorerVideo;
          //print("---------------->SRC: $src");
          var res = Result(src,date,title,content,link, true);
          bool isdoublon = false;
          for (int i =0; i<results_wp.length; i++){
            if(src == results_wp[i].id) {
              isdoublon =true;
            }
          }
          if(isdoublon == false){
            results_wp.add(res);
          }
        }
        if(posts[i].content.contains("instagram-media")) {
          DateTime date = DateTime.parse(posts[i].date);
          String title = posts[i].title;
          String _type = "Instagram";
          var content = PostCardExp(post: posts[i], type: _type);
          String link = posts[i].link;
          String id="fakeID"+cpt.toString();
          cpt++;
          var res = Result(id,date,title,content,link, false);
          results_wp.add(res);
        }
        if (posts[i].content.contains('video.php')) {
          DateTime date = DateTime.parse(posts[i].date);
          String title = posts[i].title;
          String _type = "Facebook";

          String  tag  = "<iframe";
          String end_tag = "</iframe>";
          int startIndex = posts[i].content.indexOf(tag);
          int endIndex = posts[i].content.indexOf(end_tag)+end_tag.length;
          String _iframe = posts[i].content.substring(startIndex, endIndex);
          print("_IFRAME: $_iframe");

          String link = posts[i].link;
          String id="faceID"+cpt.toString();
          cpt++;
          var content = _iframeDisplayer(_iframe, title, _type, posts[i].date, link);
          var res = Result(id,date,title,content,link, true);
          bool isdoublon = false;
          for (int i =0; i<results_wp.length; i++){
            if(id == results_wp[i].id) {
              isdoublon =true;
            }
          }
          if(isdoublon == false){
            results_wp.add(res);
          }
        }
      }


      //resultats = resultats + results_wp;
      print('taille -> '+results_wp.length.toString());
      for(int i =0; i<results_wp.length; i++) {
        print("index -> $i");
        print('id -> '+results_wp[i].id.toString());
        for(int j =0; j<resultats.length; j++) {
          if(results_wp[i].id==resultats[j].id) {
            results_wp.removeWhere((item) => item.id==results_wp[i].id);
          }
        }
      }
      resultats = resultats + results_wp;
      resultats.sort((b, a) => a.date.compareTo(b.date));
      for(int j =0; j<resultats.length; j++) {
        results.add(resultats[j].content);
      }
      setState(() {
        resultats = resultats + results_wp;
        resultats.sort((b, a) => a.date.compareTo(b.date));
        isLoadingWP=false;
      });

    }
  }

  //---> CHARGEMENT TWITTER
  List tweets = List();
  List jsonFromTwitterAPI = List();
  Future _getDataTwitter() async {

    String consumerApiKey = "3hEda6a5H4hGr93fv8xKzIBte";
    String consumerApiSecret = "twkcvEDH8cHG6Uaja6VMDs9lsdPgDIzNDOatMWO8uItZQQChAk";
    String accessToken = "1486817757853372416-m7bveHgXbbK5vaInGvSkv83XccvPcS";
    String accessTokenSecret = "uLNvCRWvyQj4jyxWqNyVPCNwRejz7SoO6PuMGkpxAxXZx";

    final _twitterOauth = new twitterApi(
        consumerKey: consumerApiKey,
        consumerSecret: consumerApiSecret,
        token: accessToken,
        tokenSecret: accessTokenSecret
    );


    Future twitterRequest_combat = _twitterOauth.getTwitterRequest(
      "GET",
      "collections/entries.json",
      options: {
        "id": "custom-1366833200937512969",
        "count": "11",
        "tweet_mode":"extended",
      },
    );

    var res_combat = await twitterRequest_combat;

    if (res_combat.statusCode == 200) {
      var _id;
      String _txt;
      DateTime _date;
      var _content;
      String _url;

      String _link;
      String _type;
      List<ImageSlider> images = List();
      List<String> H = List();
      List<String> L = List();
      bool isCaroussel = false;

      String user_id;
      String user_image;
      String user_name;
      String user_screename;


      var data =json.decode(res_combat.body);
      var _taille =data['response']['timeline'].length;

      for (int i=0; i<_taille; i++) {
        _id =data['response']['timeline'][i]['tweet']['id'].toString();
        var date = data['objects']['tweets'][_id]['created_at'];
        _date = FormatTwitterDate(date);
        String toRemove;
        int indexToRemove;
        var media = data['objects']['tweets'][_id]['extended_entities'];
        if(media != null){
          _type = data['objects']['tweets'][_id]['extended_entities']['media'][0]['type'];
          _link = data['objects']['tweets'][_id]['extended_entities']['media'][0]['expanded_url'];
          int size = data['objects']['tweets'][_id]['extended_entities']['media'].length;
          if(_type=="photo"){
            isVideo = false;
            if(size>1) {
              isCaroussel = true;
              print("******caroussell de $_id");
              print("**************SIZE: "+size.toString());
              for(int i = 0; i<size; i++) {
                var lien = data['objects']['tweets'][_id]['extended_entities']['media'][i]['media_url_https'];
                int hauteur = data['objects']['tweets'][_id]['extended_entities']['media'][i]['sizes']['large']['h'];
                print("HAUTEUR IMG -> "+hauteur.toString());
                var largeur= data['objects']['tweets'][_id]['extended_entities']['media'][i]['sizes']['large']['w'];
                print("LARGEUR IMG -> "+largeur.toString());

                ImageSlider _img = ImageSlider(_id,lien, hauteur, largeur);
                images.add(_img);
              }
            }
            else {
              isCaroussel =false;
              images = new List();
              _url = data['objects']['tweets'][_id]['extended_entities']['media'][0]['media_url_https'];
            }
          }
          else if (_type=="video") {
            isVideo = true;
            _url = data['objects']['tweets'][_id]['extended_entities']['media'][0]['video_info']['variants'][1]["url"];
          }
          else {
            isVideo = false;
            _url = "";
          }
          toRemove = data['objects']['tweets'][_id]['extended_entities']['media'][0]['url'];
        }
        var fav_count = data['objects']['tweets'][_id]['favorite_count'];
        String txt = data['objects']['tweets'][_id]['full_text'];
        if(toRemove!=null) {
          indexToRemove = txt.indexOf(toRemove);
          _txt = txt.substring(0, indexToRemove);
        } else {
          //int x = txt.length-23;
          _txt = txt;
        }

        user_id = data['objects']['tweets'][_id]['user']['id_str'];
        user_image = data['objects']['users'][user_id]['profile_image_url_https'];
        user_name = data['objects']['users'][user_id]['name'];
        user_screename = data['objects']['users'][user_id]['screen_name'];

        _content =  TwitterCard(id: _id, date:_date, txt: _txt, media_url: _url, type: _type,usr_img: user_image, usr_name: user_name, usr_scrname: user_screename,caroussel: images,isSlider: isCaroussel);
        images = [];
        Result result = Result(_id,_date, '', _content, _link,isVideo);
        results_twt_combat.add(result);

      }
      for(int i =0; i<results_twt_combat.length; i++) {
        // print("index -> $i");
        //print('id -> ' + results_twt_basket[i].id.toString());
        for (int j = 0; j < resultats.length; j++) {
          if (results_twt_combat[i].id == resultats[j].id) {
            results_twt_combat.removeWhere((item) =>
            item.id == results_twt_combat[i].id);
          }
        }
      }
      setState(() {
        resultats = resultats + results_twt_combat;
        resultats.sort((b, a) => a.date.compareTo(b.date));
        isLoadingTWT = false;
      });
    }  else {
      print(">>>>>>>>>>>>> NOUS AVONS UNE ERREUR DE CHARGEMENT TWIITER");
      print(res_combat.statusCode);
    }
  }

  //---> CHARGEMENT YOUTUBE
  static const _baseUrl = 'www.googleapis.com';
  _getDataYt() async {

    await loadsYTVideo_Combat();

    setState(() {
      resultats = resultats + results_yt_combat;
      resultats.sort((b, a) => a.date.compareTo(b.date));
      isLoadingYT = false;
    });
  }

  loadsYTVideo_Combat () async {
    //PL68y_RTVo0Af9J76u1q7dabSbBlWA-hgO
    Map<String, String> parameters = {
      'part': 'snippet',
      'playlistId': "PL68y_RTVo0Af9J76u1q7dabSbBlWA-hgO",
      'maxResults': '11',
      'key': Constants.KEY_YT,
    };
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/playlistItems',
      parameters,
    );
    Response response = await http.get(uri, headers: headers);
    if(response.statusCode==200) {
      var data = json.decode(response.body);

      var _date1 = data['items'][0]["contentDetails"]["videoPublishedAt"];
      DateTime date = DateTime.parse(_date1);
      var id_1 = data['items'][0]["snippet"]["resourceId"]["videoId"];
      var title_1 = data['items'][0]["snippet"]["title"];
      var link_1 = "https://www.youtube.com/watch?v=$id_1";
      var content_1 = PostCardExpYT(VideoItemId: id_1, VideoItemDate: date, VideoItemTitle: title_1, VideoItemLink: link_1);
      var res_1 = Result(id_1,date,title_1,content_1,link_1, true);

      var _date2 = data['items'][1]["snippet"]["publishedAt"];
      DateTime date2 = DateTime.parse(_date2);
      var id_2 = data['items'][1]["snippet"]["resourceId"]["videoId"];
      var title_2 = data['items'][1]["snippet"]["title"];
      var link_2 = "https://www.youtube.com/watch?v=$id_2";
      var content_2 = PostCardExpYT(VideoItemId: id_2, VideoItemDate: date2, VideoItemTitle: title_2, VideoItemLink: link_2);
      var res_2 = Result(id_2,date2,title_2,content_2,link_2, true);

      var _date3 = data['items'][2]["snippet"]["publishedAt"];
      DateTime date3 = DateTime.parse(_date3);
      var id_3 = data['items'][2]["snippet"]["resourceId"]["videoId"];
      var title_3 = data['items'][2]["snippet"]["title"];
      var link_3 = "https://www.youtube.com/watch?v=$id_3";
      var content_3 = PostCardExpYT(VideoItemId: id_3, VideoItemDate: date3, VideoItemTitle: title_3, VideoItemLink: link_3);
      var res_3 = Result(id_3,date3,title_3,content_3,link_3, true);

      var _date4 = data['items'][3]["snippet"]["publishedAt"];
      DateTime date4 = DateTime.parse(_date3);
      var id_4 = data['items'][3]["snippet"]["resourceId"]["videoId"];
      var title_4 = data['items'][3]["snippet"]["title"];
      var link_4 = "https://www.youtube.com/watch?v=$id_4";
      var content_4 = PostCardExpYT(VideoItemId: id_4, VideoItemDate: date4, VideoItemTitle: title_4, VideoItemLink: link_4);
      var res_4 = Result(id_4,date4,title_4,content_4,link_4, true);

      var _date5 = data['items'][4]["snippet"]["publishedAt"];
      DateTime date5 = DateTime.parse(_date5);
      var id_5 = data['items'][4]["snippet"]["resourceId"]["videoId"];
      var title_5 = data['items'][4]["snippet"]["title"];
      var link_5 = "https://www.youtube.com/watch?v=$id_5";
      var content_5 = PostCardExpYT(VideoItemId: id_5, VideoItemDate: date5, VideoItemTitle: title_5, VideoItemLink: link_5);
      var res_5 = Result(id_5,date5,title_5,content_5,link_5, true);

      var _date6 = data['items'][5]["snippet"]["publishedAt"];
      DateTime date6 = DateTime.parse(_date6);
      var id_6 = data['items'][5]["snippet"]["resourceId"]["videoId"];
      var title_6 = data['items'][5]["snippet"]["title"];
      var link_6 = "https://www.youtube.com/watch?v=$id_6";
      var content_6 = PostCardExpYT(VideoItemId: id_6, VideoItemDate: date6, VideoItemTitle: title_6, VideoItemLink: link_6);
      var res_6 = Result(id_6,date6,title_6,content_6,link_6, true);

      var _date7 = data['items'][6]["snippet"]["publishedAt"];
      DateTime date7 = DateTime.parse(_date7);
      var id_7 = data['items'][6]["snippet"]["resourceId"]["videoId"];
      var title_7 = data['items'][6]["snippet"]["title"];
      var link_7 = "https://www.youtube.com/watch?v=$id_7";
      var content_7 = PostCardExpYT(VideoItemId: id_7, VideoItemDate: date7, VideoItemTitle: title_7, VideoItemLink: link_7);
      var res_7 = Result(id_7,date7,title_7,content_7,link_7, true);

      var _date8 = data['items'][7]["snippet"]["publishedAt"];
      DateTime date8 = DateTime.parse(_date8);
      var id_8 = data['items'][7]["snippet"]["resourceId"]["videoId"];
      var title_8 = data['items'][7]["snippet"]["title"];
      var link_8 = "https://www.youtube.com/watch?v=$id_8";
      var content_8 = PostCardExpYT(VideoItemId: id_8, VideoItemDate: date8, VideoItemTitle: title_8, VideoItemLink: link_8);
      var res_8 = Result(id_8,date8,title_8,content_8,link_8, true);

      var _date9 = data['items'][8]["snippet"]["publishedAt"];
      DateTime date9 = DateTime.parse(_date8);
      var id_9 = data['items'][8]["snippet"]["resourceId"]["videoId"];
      var title_9 = data['items'][8]["snippet"]["title"];
      var link_9 = "https://www.youtube.com/watch?v=$id_9";
      var content_9 = PostCardExpYT(VideoItemId: id_9, VideoItemDate: date9, VideoItemTitle: title_9, VideoItemLink: link_9);
      var res_9 = Result(id_9,date9,title_9,content_9,link_9, true);

      var _date0 = data['items'][9]["snippet"]["publishedAt"];
      DateTime date0 = DateTime.parse(_date0);
      var id_0 = data['items'][9]["snippet"]["resourceId"]["videoId"];
      var title_0 = data['items'][9]["snippet"]["title"];
      var link_0 = "https://www.youtube.com/watch?v=$id_0";
      var content_0 = PostCardExpYT(VideoItemId: id_0, VideoItemDate: date0, VideoItemTitle: title_0, VideoItemLink: link_0);
      var res_0 = Result(id_0,date0,title_0,content_0,link_0, true);

        results_yt_combat.add(res_1);
        results_yt_combat.add(res_2);
        results_yt_combat.add(res_3);
        results_yt_combat.add(res_4);
        results_yt_combat.add(res_5);
        results_yt_combat.add(res_6);
        results_yt_combat.add(res_7);
        results_yt_combat.add(res_8);
        results_yt_combat.add(res_9);
        results_yt_combat.add(res_0);

      for(int i =0; i<results_yt_combat.length; i++) {
        print("index -> $i");
        print('id -> ' + results_yt_combat[i].id.toString());
        for (int j = 0; j < resultats.length; j++) {
          if (results_yt_combat[i].id == resultats[j].id) {
            results_yt_combat.removeWhere((item) =>
            item.id == results_yt_combat[i].id);
          }
        }
      }
    }
    else {
      print(">>>>>>>>>>>>> NOUS AVONS UNE ERREUR DE CHARGEMENT YOUTUBE");
      print(response.statusCode);
    }
  }

  @override
  void initState() {
    _FetchData();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  //RESULTATS
  @override
  Widget build(BuildContext context) {
    //print("RES'BASKET ->"+resultats.length.toString());
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child:   this.isLoadingWP | isLoadingYT | isLoadingTWT
          ? Center(
        child: Image.asset(
          'assets/gifs/green_style.gif', height: 25, width: 25,),
      )
          : InViewNotifierList(
        isInViewPortCondition: (double deltaTop, double deltaBottom, double viewPortDimension) {
          return deltaTop < (0.5 * viewPortDimension) &&
              deltaBottom > (0.5 * viewPortDimension);
        },
        controller: _scrollController,
        itemCount: resultats.length,
        builder: (BuildContext context, int index) {
          return InViewNotifierWidget(
              id: '$index',
              builder: (BuildContext context, bool inView, Widget child) {
                if(index == 0 ){
                  return Column(
                    children: [
                      SizedBox(height: 20,),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: AdmobBanner(
                          adUnitId: 'ca-app-pub-9120523919163473/2499635678',
                          adSize: AdmobBannerSize.LARGE_BANNER,
                        ),
                      ),
                      resultats[index].content,
                    ],
                  );
                }
                else if(index != 0 && index%4 ==0) {
                  return Column(
                    children: [
                      SizedBox(height: 20,),
                      resultats[index].content,
                      Container(
                        padding: EdgeInsets.all(5),
                        child: AdmobBanner(
                          adUnitId: 'ca-app-pub-9120523919163473/2499635678',
                          adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                        ),
                      ),
                    ],
                  );
                }
                else {
                  return Column(
                    children: [
                      SizedBox(height: 20,),
                      resultats[index].content
                    ],
                  );
                }
              }
          );
        },
      ),
    );
    RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: this.isLoadingWP | isLoadingYT | isLoadingTWT
          ? Center(
        child: Image.asset(
          'assets/gifs/green_style.gif', height: 25, width: 25,),
      )
          : ListView.builder(
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        itemCount: resultats.length,
        itemBuilder: (BuildContext context, int index) {
          if(index == 0 ){
            return Column(
              children: [
                SizedBox(height: 20,),
                Container(
                  padding: EdgeInsets.all(5),
                  child: AdmobBanner(
                    adUnitId: 'ca-app-pub-9120523919163473/2499635678',
                    adSize: AdmobBannerSize.LARGE_BANNER,
                  ),
                ),
                resultats[index].content,
              ],
            );
          }
          else if(index != 0 && index%4 ==0) {
            return Column(
              children: [
                SizedBox(height: 20,),
                resultats[index].content,
                Container(
                  padding: EdgeInsets.all(5),
                  child: AdmobBanner(
                    adUnitId: 'ca-app-pub-9120523919163473/2499635678',
                    adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                  ),
                ),
              ],
            );
          }
          else {
            return Column(
              children: [
                SizedBox(height: 20,),
                resultats[index].content
              ],
            );
          }
        },
      ),
    );
    RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: this.isLoadingWP | isLoadingYT | isLoadingTWT
            ? Center(
          child: Image.asset(
            'assets/gifs/green_style.gif', height: 25, width: 25,),
        )
            : ListView(
          children: <Widget>[
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: results
            )
          ],
        )
    );
  }
  //REFRESH PAGE
  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (content) {
              return ExplorerCombatPage();
            }
        )
    );
  }
}

//------------------------------------------------------------------------------//


//------------------------------------------------------------------------------//

//COMPARAISON DE DATE
bool isDateSmaller (DateTime date1, DateTime date2) {
  if (date1.year > date2.year) {
    print('is_preview_by_year');
    return true;
  }
  else if( date1.year == date2.year) {
    if (date1.month > date2.month) {
      print('is_preview_by_month');
      return true;
    }
    else if( date1.month == date2.month) {
      if (date1.day > date2.day) {
        print('is_preview_by_day');
        return true;
      }
      else if( date1.day == date2.day) {
        if (date1.hour > date2.hour) {
          print('is_preview_by_hour');
          return true;
        }
        else if( date1.hour == date2.hour) {
          if (date1.minute > date2.minute) {
            print('is_preview_by_minute');
            return true;
          }
          else if( date1.minute == date2.minute) {
            if (date1.second > date2.second) {
              print('is_preview_by_second');
              return true;
            }
            else if( date1.second < date2.second){
              print('is_preview_by_second');
              return false;
            }
            else {
              return true;
            }
          }
          else if( date1.minute < date2.minute){
            print('is_preview_by_minute');
            return false;
          }
        }
        else if( date1.hour < date2.hour){
          print('is_preview_by_hour');
          return false;
        }
      }
      else if( date1.day < date2.day){
        print('is_preview_by_day');
        return false;
      }
    }
    else if( date1.month < date2.month){
      print('is_preview_by_month');
      return false;
    }
  }
  else {
    print('is_preview_by_year');
    return false;
  }
}

//SORT DATA
mergeSortData (List<Result> data_array) {
  if(data_array.length >1) {
    //DIVISER LE TABLEAU EN DEUX
    var middleIndex = (data_array.length/2).round();
    //COTER GAUCHE
    var leftSide = data_array.sublist(0, middleIndex);
    //COTER DROIT
    var rightSide= data_array.sublist(middleIndex+1);
    //FAIRE APPEL A LA RECURSION SUR LES DEUX SOUS TABLEAU
    mergeSortData(leftSide);
    mergeSortData(rightSide);
    //BOUCLE DE COMPARAISON
    int leftIndex =0;   int rightIndex = 0; int currentIndex=0;
    while(leftIndex<leftSide.length && rightIndex<rightSide.length) {
      //CONDTION DE COMPARAISON: si la date  viens après, elle passe devant !
      bool cdt = isDateSmaller(leftSide[leftIndex].date, rightSide[rightIndex].date);

      //print ("CDT -----------> $cdt");
      //print ("DATE DE GAUCHE -----------> "+leftSide[leftIndex].date.toString());
      //print ("DATE DE DROITE -----------> "+rightSide[rightIndex].date.toString());

      if(cdt){
        data_array[currentIndex] = leftSide[leftIndex];
        leftIndex++;
      }
      else {
        data_array[currentIndex] = rightSide[rightIndex];
        rightIndex++;
      }
      currentIndex++;
    }
    //SI UNE DES DEUX LISTE SE TERMINE AJOUTER LE RESTE DE LA SUIVANTE
    while(leftIndex<(leftSide.length-1)) {
      data_array[currentIndex] = leftSide[leftIndex];
      currentIndex++;
      leftIndex++;
    }
    while(rightIndex<(rightSide.length-1)) {
      data_array[currentIndex] = rightSide[rightIndex];
      currentIndex++;
      rightIndex++;
    }
  }
  return data_array;
}

//FORMAT DATE
DateTime FormatTwitterDate(String _date) {
  //Mon Aug 25 22:27:38 +0000 2014
  //to
  //2014–08–25T22:27:38.000
  var composant = _date.split(' ');
  var mois = composant[1];
  var jour = composant[2];
  var annee = composant[5];
  var heure = composant[3];
  if(mois == "Jan") {mois = "01";}
  else if(mois == "Feb") {mois = "02";}
  else if(mois == "Mar") {mois = "03";}
  else if(mois == "Apr") {mois = "04";}
  else if(mois == "May") {mois = "05";}
  else if(mois == "Jun") {mois = "06";}
  else if(mois == "Jul") {mois = "07";}
  else if(mois == "Aug") {mois = "08";}
  else if(mois == "Sep") {mois = "09";}
  else if(mois == "Oct") {mois = "10";}
  else if(mois == "Nov") {mois = "11";}
  else if(mois == "Dec") {mois = "12";}

  _date = annee+"-"+mois+"-"+jour+"T"+heure+".000";
  DateTime _dateTime =DateTime.parse(_date);
  return _dateTime;

}

getDate(_date) {
  DateTime dateTime = DateTime.parse(_date);
  DateTime now = new DateTime.now();

  if(dateTime.day == now.day){
    String date = " · "+DateFormat("HH").format(dateTime)+'h'+DateFormat("mm").format(dateTime);
    return Text(date, style: TextStyle(
      fontSize: 13,
      fontWeight: null,
      fontFamily: "DINNextLTPro-MediumCond",
      color: Colors.black45,
    ));
  }
  else {
    String date = " · "+DateFormat("dd").format(dateTime)+'/'+DateFormat("MM").format(dateTime);
    return Text(date, style: TextStyle(
      fontSize: 13,
      fontWeight: null,
      fontFamily: "DINNextLTPro-MediumCond",
      color: Colors.black45,
    ));
  }
}

Widget _iframeDisplayer(_iframe, title, type, date, link) {
  return InkWell(
      onTap: () {},
      child: Padding(
        padding:const EdgeInsets.only(left: 0, right: 0, top: 15, bottom: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 11),
              child: Text(title,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Roboto")),
            ),
            SizedBox(height: 11),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                InkWell(
                  onTap: () async {},
                  child: Padding(
                    padding: EdgeInsets.only(left: 11),
                    child: Text(type,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: null,
                          fontFamily: "Arial",
                          color: Colors.grey,
                        )),
                  ),
                ),
                getDate(date),
                SizedBox(height: 11),
              ],
            ),
            SizedBox(height: 3),
            Card(
              child: Column(
                children: <Widget>[
                  HtmlWidget(_iframe, webView: true,),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: SvgPicture.asset("assets/icons/partager.svg",
                          height: 21, width: 27),
                      onPressed: () => Share.share(link),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ));
}







