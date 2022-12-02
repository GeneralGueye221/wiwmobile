import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tweet_webview/tweet_webview.dart';
import 'package:twitter_api/twitter_api.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:getwidget/getwidget.dart';


import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:wiwmedia_wiwsport_v3/model/post.dart';
import 'package:wiwmedia_wiwsport_v3/model/tweet.dart';
import 'package:wiwmedia_wiwsport_v3/reusable/players/video.dart';
import 'package:wiwmedia_wiwsport_v3/screens/details_page.dart';
import 'package:wiwmedia_wiwsport_v3/screens/notification_page.dart';





class TwitterCard extends StatefulWidget {
   String id;
   final String txt;
   DateTime date;
   String media_url;
   String type;
   String link;
   List<ImageSlider> caroussel;
   bool isSlider;
   bool isCard;

   String usr_img;
   String usr_name;
   String usr_scrname;



  TwitterCard({this.id, this.isSlider, this.date, this.txt, this.media_url, this.type, this.link, this.usr_scrname, this.usr_name, this.usr_img, this.caroussel, this.isCard});

  @override
  _TwitterCardState createState() => _TwitterCardState();
}

class _TwitterCardState extends State<TwitterCard> {

  List<String> slider = List();

  @override
  void initState() {
    // TODO: implement initState
    if(widget.isCard==null) {
      widget.isCard = false;
    }
    setTitle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("******SLIDER de "+widget.id);
    print("**************SIZE: "+widget.caroussel.length.toString());
    //print("**************TAILLE: "+slider.length.toString());//
    if(widget.isCard ==true) {
      return Container (
        child: Card(
          child: Column(
            children: <Widget>[
              SizedBox(height: 11),
              Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 11),
                  child: Stack(
                    children: <Widget>[
                      //****************************HEADER*********************//
                      Row(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundImage: NetworkImage(widget.usr_img),
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 13),
                              child: Container(
                                //width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(username, style: TextStyle(fontFamily: "DINNextLTPro-MediumCond", fontWeight: FontWeight.w600, fontSize: 18.0, color: Colors.black),),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("@"+widget.usr_scrname, style: TextStyle( fontFamily: "DINNextLTPro-MediumCond", fontSize: 16.0, color: Colors.grey)),
                                        Container(
                                          padding: EdgeInsets.only(top: 3),
                                          child: setDate(widget.date),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )
                          ),
                        ],
                      ),
                      Align(
                          alignment: Alignment.topRight,
                          child: Image.asset("assets/images/twitter.png", height: 15, width: 30)
                      )
                    ],
                  )
              ),
              SizedBox(height: 13),
              //****************************TEXT*********************//
              Container(
                padding: EdgeInsets.only(left: 11),
                alignment: Alignment.topLeft,
                child: setText(_parseHtmlString(widget.txt)),
              ),
              SizedBox(height: 11),
              //****************************MEDIA*********************//
              Container(),
              //****************************FOOTER*********************//
              Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 15, 55, 0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: RichText(
                          text: TextSpan(
                              children: [
                                TextSpan(
                                    style: TextStyle(color: Colors.lightBlueAccent, fontSize: 15),
                                    text: "voir sur Twitter",
                                    recognizer: TapGestureRecognizer()..onTap =  () async{
                                      var url = "https://twitter.com/"+widget.usr_scrname+"/status/"+widget.id+"?ref_src=twsrc%5Etfw";
                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    }
                                ),
                              ]
                          )),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: SvgPicture.asset("assets/icons/partager.svg",
                          height: 15, width: 20),
                      onPressed: () => Share.share(widget.link),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15,)
            ],
          ),
        ),
      );
    }
    else {
      if(widget.type=="video") {
        return Container (
            child: Column(
              children: <Widget>[
                SizedBox(height: 11),
                Divider(indent: 11, endIndent: 11,),
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(left: 11),
                    child: Stack(
                      children: <Widget>[
                        //****************************HEADER*********************//
                        Row(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundImage: NetworkImage(widget.usr_img),
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: 13),
                                child: Container(
                                  //width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(username, style: TextStyle(fontFamily: "DINNextLTPro-MediumCond", fontWeight: FontWeight.w600, fontSize: 18.0, color: Colors.black),),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text("@"+widget.usr_scrname, style: TextStyle( fontFamily: "DINNextLTPro-MediumCond", fontSize: 16.0, color: Colors.grey)),
                                          Container(
                                            padding: EdgeInsets.only(top: 3),
                                            child: setDate(widget.date),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                            ),
                          ],
                        ),
                        Align(
                            alignment: Alignment.topRight,
                            child: Image.asset("assets/images/twitter.png", height: 15, width: 30)
                        )
                      ],
                    )
                ),
                SizedBox(height: 13),
                //****************************TEXT*********************//
                Container(
                  padding: EdgeInsets.only(left: 11),
                  alignment: Alignment.topLeft,
                  child: setText(_parseHtmlString(widget.txt)),
                ),
                SizedBox(height: 11),
                //****************************MEDIA*********************//
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: MyVideoPlayer(
                    videoUrl: widget.media_url,
                  ),
                ),
                //****************************FOOTER*********************//
                Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 15, 0, 0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: RichText(
                            text: TextSpan(
                                children: [
                                  TextSpan(
                                      style: TextStyle(color: Colors.lightBlueAccent, fontSize: 15),
                                      text: "voir sur Twitter",
                                      recognizer: TapGestureRecognizer()..onTap =  () async{
                                        var url = "https://twitter.com/"+widget.usr_scrname+"/status/"+widget.id+"?ref_src=twsrc%5Etfw";
                                        if (await canLaunch(url)) {
                                          await launch(url);
                                        } else {
                                          throw 'Could not launch $url';
                                        }
                                      }
                                  ),
                                ]
                            )),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: SvgPicture.asset("assets/icons/partager.svg",
                            height: 15, width: 20),
                        onPressed: () => Share.share(widget.link),
                      ),
                    ),
                  ],
                ),
                Divider(indent: 11, endIndent: 11,),
                SizedBox(height: 15,)
              ],
            ),
        );
      }
      else  {
        return Column (
          children: <Widget>[
            SizedBox(height: 15),
            Card(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 11),
                  //****************************HEADER****************************//
                  Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(left: 11),
                      child: Stack(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              CircleAvatar(
                                backgroundImage: NetworkImage(widget.usr_img),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(left: 13),
                                  child: Container(
                                    //width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(username, style: TextStyle(fontFamily: "DINNextLTPro-MediumCond", fontWeight: FontWeight.w600, fontSize: 18.0, color: Colors.black),),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text("@"+widget.usr_scrname, style: TextStyle( fontFamily: "DINNextLTPro-MediumCond", fontSize: 16.0, color: Colors.grey)),
                                            Container(
                                              padding: EdgeInsets.only(top: 3),
                                              child: setDate(widget.date),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                              ),
                            ],
                          ),
                          Align(
                              alignment: Alignment.topRight,
                              child: Image.asset("assets/images/twitter.png", height: 15, width: 30)
                          )
                        ],
                      )
                  ),
                  SizedBox(height: 13),
                  //**************************TEXT********************************//
                  Container(
                    padding: EdgeInsets.only(left: 11),
                    alignment: Alignment.topLeft,
                    child: setText(_parseHtmlString(widget.txt)),
                  ),
                  SizedBox(height: 11),
                  //*********************************IMG**************************//
                  setImage(),
                  //******************************FOOTER**************************//
                  Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 15, 0, 0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: RichText(
                              text: TextSpan(
                                  children: [
                                    TextSpan(
                                        style: TextStyle(color: Colors.lightBlueAccent, fontSize: 15),
                                        text: "voir sur Twitter",
                                        recognizer: TapGestureRecognizer()..onTap =  () async{
                                          var url = "https://twitter.com/"+widget.usr_scrname+"/status/"+widget.id+"?ref_src=twsrc%5Etfw";
                                          if (await canLaunch(url)) {
                                            await launch(url);
                                          } else {
                                            throw 'Could not launch $url';
                                          }
                                        }
                                    ),
                                  ]
                              )),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: SvgPicture.asset("assets/icons/partager.svg",
                              height: 15, width: 20),
                          onPressed: () => Share.share(widget.link),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      }
    }
  }

  //FONCTIONS

  setDate(DateTime _date) {
    Duration dur = DateTime.now().difference(_date);
    var inSecond = dur.inSeconds;
    var inMinute = dur.inMinutes;
    var inHour = dur.inHours;
    var inDay = dur.inDays;
    if(inSecond<60) {
      String date = " · "+ inSecond.toString() +"s";
      return Text(date, style: TextStyle(
        fontSize: 13,
        fontWeight: null,
        fontFamily: "DINNextLTPro-MediumCond",
        color: Colors.black45,
      ));
    }
    else if(inSecond>=60 && inMinute<60) {
      String date = " · "+ inMinute.toString() +"mn";
      return Text(date, style: TextStyle(
        fontSize: 13,
        fontWeight: null,
        fontFamily: "DINNextLTPro-MediumCond",
        color: Colors.black45,
      ));
    }
    else if(inMinute>=60 && inHour<24) {
      String date = " · "+ inHour.toString() +"h";
      return Text(date, style: TextStyle(
        fontSize: 13,
        fontWeight: null,
        fontFamily: "DINNextLTPro-MediumCond",
        color: Colors.black45,
      ));
    }
    else if(inHour>=24 && inDay<7) {
      String date = " · "+ inDay.toString() +"j";
      return Text(date, style: TextStyle(
        fontSize: 13,
        fontWeight: null,
        fontFamily: "DINNextLTPro-MediumCond",
        color: Colors.black45,
      ));
    }
    else {
      String date = " · "+DateFormat("dd").format(_date)+'/'+DateFormat("MM").format(_date);
      return Text(date, style: TextStyle(
        fontSize: 13,
        fontWeight: null,
        fontFamily: "DINNextLTPro-MediumCond",
        color: Colors.black45,
      ));
    }
  }

  setText(_text) {
    //_text = removeDiacritics(_text);
    return ParsedText(
      alignment: TextAlign.start,
      text: _text,
      style: TextStyle(color: Colors.black, fontSize: 17),
      parse: <MatchText>[
        MatchText(
            type: ParsedType.URL,
            style: TextStyle(
              color: Colors.lightBlueAccent,
              fontSize: 17,
            ),
            onTap: (url) async {
              var a = await canLaunch(url);
              if (a) {
                launch(url);
              }
            }),
        MatchText(
            pattern: r"\B#+([\S]+)\b",
            style: TextStyle(
              color: Colors.lightBlueAccent,
            ),
            onTap: (url) async {
              var cpt = url.toString().substring(1);
              _launchUrl("https://twitter.com/hashtag/$cpt");
            }),
        MatchText(
            pattern: r"\B@+([\w]+)\b",
            style: TextStyle(
              color: Colors.lightBlueAccent,
            ),
            onTap: (url) async {
              var cpt = url.toString().substring(1);
              _launchUrl("https://twitter.com/$cpt");
            })
      ],
    );
    Linkify(
      onOpen: (link) async {
        if (await canLaunch(link.url)) {
          await launch(link.url);
        } else {
          throw 'Could not launch $link';
        }
      },
      text: _text,
      style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.normal,
        fontFamily: "DINNextLTPro-MediumCond",
      ),
      linkStyle: TextStyle(color: Colors.lightBlueAccent),
    );
  }
  String removeDiacritics(String str) {
    var withDia = 'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    var withoutDia = 'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

    for (int i = 0; i < withDia.length; i++) {
      str = str.replaceAll(withDia[i], withoutDia[i]);
    }

    return str;
  }
  String _parseHtmlString(String htmlString) {
    var unescape = new HtmlUnescape();
    return unescape.convert(htmlString);
  }

  var username="";
  setTitle() {
    if(widget.usr_name.length >23) {
        username = widget.usr_name.substring(0,17)+"...";
    } else {
       username = widget.usr_name;
    }
    return username;
  }

  int index_car  = 1;
  setImage () {
    if(widget.isSlider==false) {
      return FadeInImage.assetNetwork(
        placeholder: 'assets/reloading.gif',
        image: widget.media_url,
        fit: BoxFit.fill,
      );
    }
    else {
      return Container(
        //width: MediaQuery.of(context).size.width,
        child: Stack (
          children: [
            GFCarousel(
              height: 400,
              enlargeMainPage: true,
              pagination: true,
              items: widget.caroussel.map(
                    (slide) {
                  return AspectRatio(
                    //width: MediaQuery.of(context).size.width,
                    aspectRatio: 25/5,
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/reloading.gif',
                      image: slide.link,
                      fit: BoxFit.fitWidth,
                    ),
                  );
                },
              ).toList(),
              onPageChanged: (index) {
                setState(() {
                  index_car = index+1;
                });
              },
            ),
            Container(
              alignment: Alignment.topRight,
              padding: EdgeInsets.only(top: 10, right: 10),
              child: Container(
                  width: 35,
                  height: 20,
                  // padding: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(18.0)
                  ),
                  child: Center(
                      child: Text(
                        index_car.toString()+"/"+widget.caroussel.length.toString(),
                        style: TextStyle(
                            color: Colors.white
                        ),
                      )
                  )
              ),
            )
          ],
        ),
      );
    }
  }

  _launchUrl(String link) async {
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      throw 'Cannot launch $link';
    }
  }


}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class TwitterCardPlus extends StatefulWidget {
  final String id;
  bool isExplorer;
  bool isExplorerVideo;
  String title;

  String slug;


  TwitterCardPlus({this.id, this.isExplorer, this.title, this.slug});

  @override
  _TwitterCardPlusState createState() => _TwitterCardPlusState();
}

class _TwitterCardPlusState extends State<TwitterCardPlus> {
//VARIABLES
   String id="";
   String txt="";
   DateTime date;
   String media_url="";
   String type="";
   String link="";
   List<ImageSlider> caroussel =List();
   bool isCaroussel = false;

   String usr_img="";
   String usr_name="";
   String usr_scrname="";

  //--->FETCH DATA FROM TWITTER API
  bool isLoading=false;
  bool isEmbed=false;
  bool isCard = false;
  var data;

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
    Future twitterCardRequest = _twitterOauth.getTwitterRequest(
      "GET",
      "accounts",
      options: {
        "card_uris": "card://1044301099031658496",
        "account_id": "18ce54d4x5t"
      },
    );

    var response = await twitterRequest;

    if (response.statusCode == 200) {
      data =json.decode(response.body);
      //print("JSON -> $data");

      id = data['id'].toString();
      String _date = data['created_at'];
      date = FormatTwitterDate(_date);
      var media = data['entities']['media'];
      var liens = data['entities']['urls'];
      var entity =  data['extended_entities'];
      var source =  data['source'];
      print("ENTITY -> $entity");
      print("MEDIA -> $media");
      //print("MEDIA LENGTH -> "+media.length.toString());
      bool isCard = (source.toString().contains("Twitter for Advertisers") | (media ==null && liens.length>0));
      print("BOOL -> $isCard");

      if(isCard) {
        setState(() {
          isEmbed = true;
        });
        print("BOOL EMBED* -> $isEmbed");
      }
      else {
        if(media == null) {
          var index_url = data['full_text'].toString().length-23;
          txt = data['full_text'];
        }
        else {
          var url = data['extended_entities']['media'][0]['url'];
          var index_url = data['full_text'].toString().indexOf(url);
          txt = data['full_text'].toString();
          type = data['extended_entities']['media'][0]['type'];
          var size = data['extended_entities']['media'].length;
          // print("SIZE: $size");
          if(type=="photo") {
            if(size>1) {
              isCaroussel = true;
              for(int i = 0; i<size; i++) {
                var lien = data['extended_entities']['media'][i]['media_url_https'];
                int hauteur = data['extended_entities']['media'][i]['sizes']['medium']['h'];
                //print("HAUTEUR IMG -> "+hauteur.toString());
                int largeur= data['extended_entities']['media'][i]['sizes']['medium']['w'];
                //print("LARGEUR IMG -> "+largeur.toString());

                ImageSlider _img = ImageSlider(id, lien, hauteur, largeur);
                caroussel.add(_img);
              }
            }
            else {
              isCaroussel =false;
              media_url = data['extended_entities']['media'][0]['media_url_https'];
            }
          }
          else {
            media_url =data['extended_entities']['media'][0]['video_info']['variants'][1]["url"];
            widget.isExplorerVideo = true;
            print("****************VIDEO URL: $media_url");
          }
        }
      }

      usr_img = data['user']['profile_image_url_https'];
      usr_name = data['user']['name'];
      if(usr_name.length > 27) {
        usr_name = usr_name.split(" ")[0];
      }
      usr_scrname= data['user']['screen_name'];

      link ="https://twitter.com/$usr_scrname/status/$id";

      setState(() {
        isLoading = false;
      });

    } else {
      print(">>>>>>>>>>>>> NOUS AVONS UNE ERREUR DE CHARGEMENT TWIITER");
      print(response.statusCode);
    }
  }
  var _text;
  bool isArticle = false;
  @override
  void initState() {
    // TODO: implement initState
    _getOneDataTwitter(widget.id);
    if(widget.title==null){
      widget.title = " ";
    }
    if(widget.slug==null){
      widget.slug = " ";
    }
    if(widget.title.toString().length>1){
      isArticle = true;
    }
    //setTitle();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return isLoading ? _Loader() : _Result();
  }

  //--->FONCTIONS

   var username="";
   setTitle() {
     if(usr_name.length >23) {
       setState(() {
         usr_name = usr_name.substring(0,17)+"...";
       });
     }
   }

   setDate(DateTime _date) {
     Duration dur = DateTime.now().difference(_date);
     var inSecond = dur.inSeconds;
     var inMinute = dur.inMinutes;
     var inHour = dur.inHours;
     var inDay = dur.inDays;
     if(inSecond<60) {
       String date = " · "+ inSecond.toString() +"s";
       return Text(date, style: TextStyle(
         fontSize: 13,
         fontWeight: null,
         fontFamily: "DINNextLTPro-MediumCond",
         color: Colors.black45,
       ));
     }
     else if(inSecond>=60 && inMinute<60) {
       String date = " · "+ inMinute.toString() +"mn";
       return Text(date, style: TextStyle(
         fontSize: 13,
         fontWeight: null,
         fontFamily: "DINNextLTPro-MediumCond",
         color: Colors.black45,
       ));
     }
     else if(inMinute>=60 && inHour<24) {
       String date = " · "+ inHour.toString() +"h";
       return Text(date, style: TextStyle(
         fontSize: 13,
         fontWeight: null,
         fontFamily: "DINNextLTPro-MediumCond",
         color: Colors.black45,
       ));
     }
     else if(inHour>=24 && inDay<7) {
       String date = " · "+ inDay.toString() +"j";
       return Text(date, style: TextStyle(
         fontSize: 13,
         fontWeight: null,
         fontFamily: "DINNextLTPro-MediumCond",
         color: Colors.black45,
       ));
     }
     else {
       String date = " · "+DateFormat("dd").format(_date)+'/'+DateFormat("MM").format(_date);
       return Text(date, style: TextStyle(
         fontSize: 13,
         fontWeight: null,
         fontFamily: "DINNextLTPro-MediumCond",
         color: Colors.black45,
       ));
     }
   }

   setText(_text) {
    //_text = removeDiacritics(_text);
     return ParsedText(
       alignment: TextAlign.start,
       text: _text,
       style: TextStyle(color: Colors.black, fontSize: 17),
       parse: <MatchText>[
         MatchText(
             type: ParsedType.URL,
             style: TextStyle(
               color: Colors.lightBlueAccent,
               fontSize: 17,
             ),
             onTap: (url) async {
               var a = await canLaunch(url);
               if (a) {
                 launch(url);
               }
             }),
         MatchText(
             pattern: r"\B#+([\S]+)\b",
             style: TextStyle(
               color: Colors.lightBlueAccent,
             ),
             onTap: (url) async {
               var cpt = url.toString().substring(1);
               _launchUrl("https://twitter.com/hashtag/$cpt");
             }),
         MatchText(
             pattern: r"\B@+([\w]+)\b",
             style: TextStyle(
               color: Colors.lightBlueAccent,
             ),
             onTap: (url) async {
               var cpt = url.toString().substring(1);
               _launchUrl("https://twitter.com/$cpt");
             })
       ],
     );
     Linkify(
       onOpen: (link) async {
         if (await canLaunch(link.url)) {
           await launch(link.url);
         } else {
           throw 'Could not launch $link';
         }
       },
       text: _text,
       style: TextStyle(
         fontSize: 17,
         fontWeight: FontWeight.normal,
         fontFamily: "DINNextLTPro-MediumCond",
       ),
       linkStyle: TextStyle(color: Colors.lightBlueAccent),
     );
   }
   String removeDiacritics(String str) {
     var withDia = 'ÈÉÊËèéêë';
     var withoutDia = 'EEEEeeeee';

     for (int i = 0; i < withDia.length; i++) {
       str = str.replaceAll(withDia[i], withoutDia[i]);
     }

     return str;
   }
   String _parseHtmlString(String htmlString) {
     var unescape = new HtmlUnescape();
     return unescape.convert(htmlString);
   }


   int index_car  = 1;
   setImage () {
     if(isCaroussel==false) {
       return FadeInImage.assetNetwork(
         placeholder: 'assets/reloading.gif',
         image: media_url,
         fit: BoxFit.fill,
       );
     }
     else {
       return Container(
         //width: MediaQuery.of(context).size.width,
         child: Stack (
           children: [
             GFCarousel(
               height: 450,
               enlargeMainPage: true,
               pagination: true,
               items: caroussel.map(
                     (slide) {
                   return AspectRatio(
                     //width: MediaQuery.of(context).size.width,
                     aspectRatio: 25/5,
                     child: FadeInImage.assetNetwork(
                       placeholder: 'assets/reloading.gif',
                       image: slide.link,
                       fit: BoxFit.fitWidth,
                     ),
                   );
                 },
               ).toList(),
               onPageChanged: (index) {
                 setState(() {
                   index_car = index+1;
                 });
               },
             ),
             Container(
               alignment: Alignment.topRight,
               padding: EdgeInsets.only(top: 10, right: 10),
               child: Container(
                   width: 35,
                   height: 20,
                   // padding: EdgeInsets.only(top: 10),
                   decoration: BoxDecoration(
                       color: Colors.black.withOpacity(0.7),
                       borderRadius: BorderRadius.circular(18.0)
                   ),
                   child: Center(
                       child: Text(
                         index_car.toString()+"/"+caroussel.length.toString(),
                         style: TextStyle(
                             color: Colors.white
                         ),
                       )
                   )
               ),
             )
           ],
         ),
       );
     }
   }

   _launchUrl(String link) async {
     if (await canLaunch(link)) {
       await launch(link);
     } else {
       throw 'Cannot launch $link';
     }
   }

   FormatTwitterDate(String _date) {
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

   Widget _Result() {
    if(isEmbed==true && widget.isExplorer==true) {
      return Container();
    }
    else if(isEmbed==true) {
      return _embed();
    }
     else if (widget.isExplorer==true && isEmbed==false){
      return _ResultExp();
    }
    else {
      if(type=="video") {
        String text = txt;
        if (txt.toString().contains("https://t.co/")){
          int end_index = txt.toString().length-23;
          setState(() {
            text = txt.substring(0, end_index);
          });
        }
        return Container(
          child: Column(
            children: <Widget>[
              SizedBox(height: 11),
              Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 11),
                  child: Stack(
                    children: <Widget>[
                      //****************************HEADER*********************//
                      Row(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundImage: NetworkImage(usr_img),
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 13),
                              child: Container(
                                //width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(usr_name, style: TextStyle(fontFamily: "DINNextLTPro-MediumCond", fontWeight: FontWeight.w600, fontSize: 18.0, color: Colors.black),),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("@"+usr_scrname, style: TextStyle( fontFamily: "DINNextLTPro-MediumCond", fontSize: 16.0, color: Colors.grey)),
                                        Container(
                                          padding: EdgeInsets.only(top: 3),
                                          child: setDate(date),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )
                          ),
                        ],
                      ),
                      Align(
                          alignment: Alignment.topRight,
                          child: Image.asset("assets/images/twitter.png", height: 15, width: 30)
                      )
                    ],
                  )
              ),
              SizedBox(height: 13),
              //****************************TEXT*********************//
              Container(
                padding: EdgeInsets.only(left: 11),
                alignment: Alignment.topLeft,
                child: setText(_parseHtmlString(text)),
              ),
              SizedBox(height: 11),
              //****************************MEDIA*********************//
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Text("  Twitter · Video", style: TextStyle( fontFamily: "DINNextLTPro-MediumCond", fontSize: 16.0, color: Colors.grey)),
                    SizedBox(height: 25)
                  ]
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 300,
                child: MyVideoPlayer(
                  videoUrl: media_url,
                ),
              ),
              //****************************FOOTER*********************//
              Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 15, 0, 0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: RichText(
                          text: TextSpan(
                              children: [
                                TextSpan(
                                    style: TextStyle(color: Colors.lightBlueAccent, fontSize: 15),
                                    text: "voir sur Twitter",
                                    recognizer: TapGestureRecognizer()..onTap =  () async{
                                      var url = "https://twitter.com/"+usr_scrname+"/status/"+widget.id+"?ref_src=twsrc%5Etfw";
                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    }
                                ),
                              ]
                          )),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: Wrap(
                      // to apply margin in the cross axis of the wrap
                        spacing: -10,
                        children: <Widget>[
                          IconButton(
                            icon: SvgPicture.asset("assets/icons/partager.svg",
                                height: 15, width: 20),
                            onPressed: () => Share.share(link),
                          ),
                        ]
                    ),
                  )
                ],
              ),
              Divider(indent: 11, endIndent: 11,),
              SizedBox(height: 15,)
            ],
          ),
        );
      }
      else if (type=="photo")  {
        String text = txt;
        if (txt.toString().contains("https://t.co/")){
          int end_index = txt.toString().length-23;
          setState(() {
            text = txt.substring(0, end_index);
          });
        }
        return Column(
          children: <Widget>[
            SizedBox(height: 15),
            Card(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 11),
                  //****************************HEADER****************************//
                  Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(left: 11),
                      child: Stack(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              CircleAvatar(
                                backgroundImage: NetworkImage(usr_img),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(left: 13),
                                  child: Container(
                                    //width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(usr_name, style: TextStyle(fontFamily: "DINNextLTPro-MediumCond", fontWeight: FontWeight.w600, fontSize: 18.0, color: Colors.black),),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text("@"+usr_scrname, style: TextStyle( fontFamily: "DINNextLTPro-MediumCond", fontSize: 16.0, color: Colors.grey)),
                                            Container(
                                              padding: EdgeInsets.only(top: 3),
                                              child: setDate(date),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                              ),
                            ],
                          ),
                          Align(
                              alignment: Alignment.topRight,
                              child: Image.asset("assets/images/twitter.png", height: 15, width: 30)
                          )
                        ],
                      )
                  ),
                  SizedBox(height: 13),
                  //**************************TEXT********************************//
                  Container(
                    padding: EdgeInsets.only(left: 11),
                    alignment: Alignment.topLeft,
                    child: setText(_parseHtmlString(text)),
                  ),
                  SizedBox(height: 11),
                  //*********************************IMG**************************//
                  setImage(),
                  //******************************FOOTER**************************//
                  Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 15, 0, 0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: RichText(
                              text: TextSpan(
                                  children: [
                                    TextSpan(
                                        style: TextStyle(color: Colors.lightBlueAccent, fontSize: 15),
                                        text: "voir sur Twitter",
                                        recognizer: TapGestureRecognizer()..onTap =  () async{
                                          var url = "https://twitter.com/"+usr_scrname+"/status/"+widget.id+"?ref_src=twsrc%5Etfw";
                                          if (await canLaunch(url)) {
                                            await launch(url);
                                          } else {
                                            throw 'Could not launch $url';
                                          }
                                        }
                                    ),
                                  ]
                              )),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topRight,
                        child: Wrap(
                          // to apply margin in the cross axis of the wrap
                            spacing: -10,
                            children: <Widget>[
                              IconButton(
                                icon: SvgPicture.asset("assets/icons/partager.svg",
                                    height: 15, width: 20),
                                onPressed: () => Share.share(link),
                              ),
                            ]
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      }
      else {
        return Container(
          child: Card(
            child: Column(
              children: <Widget>[
                SizedBox(height: 10,),
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(left: 11),
                    child: Stack(
                      children: <Widget>[
                        //****************************HEADER*********************//
                        Row(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundImage: NetworkImage(usr_img),
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: 13),
                                child: Container(
                                  //width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(usr_name, style: TextStyle(fontFamily: "DINNextLTPro-MediumCond", fontWeight: FontWeight.w600, fontSize: 18.0, color: Colors.black),),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text("@"+usr_scrname, style: TextStyle( fontFamily: "DINNextLTPro-MediumCond", fontSize: 16.0, color: Colors.grey)),
                                          Container(
                                            padding: EdgeInsets.only(top: 3),
                                            child: setDate(date),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                            ),
                          ],
                        ),
                        Align(
                            alignment: Alignment.topRight,
                            child: Image.asset("assets/images/twitter.png", height: 15, width: 30)
                        )
                      ],
                    )
                ),
                SizedBox(height: 13),
                //****************************TEXT*********************//
                Container(
                  padding: EdgeInsets.only(left: 11),
                  alignment: Alignment.topLeft,
                  child: setText(_parseHtmlString(txt)),
                ),
                SizedBox(height: 11),
                //****************************MEDIA*********************//
                Container(),
                //****************************FOOTER*********************//
                Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 15, 55, 0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: RichText(
                            text: TextSpan(
                                children: [
                                  TextSpan(
                                      style: TextStyle(color: Colors.lightBlueAccent, fontSize: 15),
                                      text: "voir sur Twitter",
                                      recognizer: TapGestureRecognizer()..onTap =  () async{
                                        var url = "https://twitter.com/"+usr_scrname+"/status/"+widget.id+"?ref_src=twsrc%5Etfw";
                                        if (await canLaunch(url)) {
                                          await launch(url);
                                        } else {
                                          throw 'Could not launch $url';
                                        }
                                      }
                                  ),
                                ]
                            )),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      child: Wrap(
                        // to apply margin in the cross axis of the wrap
                          spacing: -10,
                          children: <Widget>[
                            IconButton(
                              icon: SvgPicture.asset("assets/icons/partager.svg",
                                  height: 15, width: 20),
                              onPressed: () => Share.share(link),
                            ),
                          ]
                      ),
                    )
                  ],
                ),
                SizedBox(height: 15)
              ],
            ),
          ),
        );
      }
    }
   }

   goToArticle(String slug) {
     return Navigator.push(
         context,
         MaterialPageRoute(
             builder: (context) {
               return NotificationPage(link: slug, isExplorer: true);
             }
         )
     );
   }

   Widget _ResultExp() {
     if(isArticle){
       if(type=="video") {
         String text = txt;
         if (txt.toString().contains("https://t.co/")){
           int end_index = txt.toString().length-23;
           setState(() {
             text = txt.substring(0, end_index);
           });
         }
         return Container(
           child: Column(
             children: <Widget>[
               SizedBox(height: 11),
               Padding(
                 padding: EdgeInsets.only(left: 9, right:9),
                 child: Text(widget.title,
                     style: TextStyle(
                         fontSize: 17,
                         fontWeight: FontWeight.bold,
                         fontFamily: "Roboto")),
               ),
               SizedBox(height: 10,),
               Divider(indent: 13, endIndent: 13,),
               SizedBox(height: 10,),
               Container(
                   width: MediaQuery.of(context).size.width,
                   padding: EdgeInsets.only(left: 11),
                   child: Stack(
                     children: <Widget>[
                       //****************************HEADER*********************//
                       Row(
                         children: <Widget>[
                           CircleAvatar(
                             backgroundImage: NetworkImage(usr_img),
                           ),
                           Padding(
                               padding: EdgeInsets.only(left: 13),
                               child: Container(
                                 //width: MediaQuery.of(context).size.width,
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.start,
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: <Widget>[
                                     Text(usr_name, style: TextStyle(fontFamily: "DINNextLTPro-MediumCond", fontWeight: FontWeight.w600, fontSize: 18.0, color: Colors.black),),
                                     Row(
                                       mainAxisAlignment: MainAxisAlignment.start,
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: <Widget>[
                                         Text("@"+usr_scrname, style: TextStyle( fontFamily: "DINNextLTPro-MediumCond", fontSize: 16.0, color: Colors.grey)),
                                         Container(
                                           padding: EdgeInsets.only(top: 3),
                                           child: setDate(date),
                                         )
                                       ],
                                     ),
                                   ],
                                 ),
                               )
                           ),
                         ],
                       ),
                       Align(
                           alignment: Alignment.topRight,
                           child: Image.asset("assets/images/twitter.png", height: 15, width: 30)
                       )
                     ],
                   )
               ),
               SizedBox(height: 13),
               //****************************TEXT*********************//
               Container(
                 padding: EdgeInsets.only(left: 11),
                 alignment: Alignment.topLeft,
                 child: setText(_parseHtmlString(text)),
               ),
               SizedBox(height: 11),
               //****************************MEDIA*********************//
               Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     //Text("  Twitter · Video", style: TextStyle( fontFamily: "DINNextLTPro-MediumCond", fontSize: 16.0, color: Colors.grey)),
                     SizedBox(height: 25)
                   ]
               ),
               Container(
                 width: MediaQuery.of(context).size.width,
                 height: 300,
                 child: MyVideoPlayer(
                   videoUrl: media_url,
                 ),
               ),
               //****************************FOOTER*********************//
               Stack(
                 children: [
                   Padding(
                     padding: EdgeInsets.fromLTRB(15, 15, 0, 0),
                     child: Align(
                       alignment: Alignment.topLeft,
                       child: RichText(
                           text: TextSpan(
                               children: [
                                 TextSpan(
                                     style: TextStyle(color: Colors.lightBlueAccent, fontSize: 15),
                                     text: "voir sur Twitter",
                                     recognizer: TapGestureRecognizer()..onTap =  () async{
                                       var url = "https://twitter.com/"+usr_scrname+"/status/"+widget.id+"?ref_src=twsrc%5Etfw";
                                       if (await canLaunch(url)) {
                                         await launch(url);
                                       } else {
                                         throw 'Could not launch $url';
                                       }
                                     }
                                 ),
                               ]
                           )),
                     ),
                   ),
                   Container(
                     alignment: Alignment.topRight,
                     child: Wrap(
                       // to apply margin in the cross axis of the wrap
                         spacing: -10,
                         children: <Widget>[
                           IconButton(
                             icon: SvgPicture.asset("assets/icons/article.svg",
                                 height: 20, width: 25),
                             onPressed: () => goToArticle(widget.slug),
                           ),
                           IconButton(
                             icon: SvgPicture.asset("assets/icons/partager.svg",
                                 height: 15, width: 20),
                             onPressed: () => Share.share(link),
                           ),
                         ]
                     ),
                   )
                 ],
               ),
               Divider(indent: 11, endIndent: 11,),
               SizedBox(height: 15,)
             ],
           ),
         );
       }
       else if (type=="photo")  {
         String text = txt;
         if (txt.toString().contains("https://t.co/")){
           int end_index = txt.toString().length-23;
           setState(() {
             text = txt.substring(0, end_index);
           });
         }
         return Column(
           children: <Widget>[
             SizedBox(height: 15),
             Card(
               child: Column(
                 children: <Widget>[
                   SizedBox(height: 11),
                   Padding(
                     padding: EdgeInsets.only(left: 9, right:9),
                     child: Text(widget.title,
                         style: TextStyle(
                             fontSize: 17,
                             fontWeight: FontWeight.bold,
                             fontFamily: "Roboto")),
                   ),
                   SizedBox(height: 10,),
                   Divider(indent: 13, endIndent: 13,),
                   SizedBox(height: 10,),
                   //****************************HEADER****************************//
                   Container(
                       width: MediaQuery.of(context).size.width,
                       padding: EdgeInsets.only(left: 11),
                       child: Stack(
                         children: <Widget>[
                           Row(
                             children: <Widget>[
                               CircleAvatar(
                                 backgroundImage: NetworkImage(usr_img),
                               ),
                               Padding(
                                   padding: EdgeInsets.only(left: 13),
                                   child: Container(
                                     //width: MediaQuery.of(context).size.width,
                                     child: Column(
                                       mainAxisAlignment: MainAxisAlignment.start,
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: <Widget>[
                                         Text(usr_name, style: TextStyle(fontFamily: "DINNextLTPro-MediumCond", fontWeight: FontWeight.w600, fontSize: 18.0, color: Colors.black),),
                                         Row(
                                           mainAxisAlignment: MainAxisAlignment.start,
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: <Widget>[
                                             Text("@"+usr_scrname, style: TextStyle( fontFamily: "DINNextLTPro-MediumCond", fontSize: 16.0, color: Colors.grey)),
                                             Container(
                                               padding: EdgeInsets.only(top: 3),
                                               child: setDate(date),
                                             )
                                           ],
                                         ),
                                       ],
                                     ),
                                   )
                               ),
                             ],
                           ),
                           Align(
                               alignment: Alignment.topRight,
                               child: Image.asset("assets/images/twitter.png", height: 15, width: 30)
                           )
                         ],
                       )
                   ),
                   SizedBox(height: 13),
                   //**************************TEXT********************************//
                   Container(
                     padding: EdgeInsets.only(left: 11),
                     alignment: Alignment.topLeft,
                     child: setText(_parseHtmlString(text)),
                   ),
                   SizedBox(height: 11),
                   //*********************************IMG**************************//
                   setImage(),
                   //******************************FOOTER**************************//
                   Stack(
                     children: [
                       Padding(
                         padding: EdgeInsets.fromLTRB(15, 15, 0, 0),
                         child: Align(
                           alignment: Alignment.topLeft,
                           child: RichText(
                               text: TextSpan(
                                   children: [
                                     TextSpan(
                                         style: TextStyle(color: Colors.lightBlueAccent, fontSize: 15),
                                         text: "voir sur Twitter",
                                         recognizer: TapGestureRecognizer()..onTap =  () async{
                                           var url = "https://twitter.com/"+usr_scrname+"/status/"+widget.id+"?ref_src=twsrc%5Etfw";
                                           if (await canLaunch(url)) {
                                             await launch(url);
                                           } else {
                                             throw 'Could not launch $url';
                                           }
                                         }
                                     ),
                                   ]
                               )),
                         ),
                       ),
                       Container(
                         alignment: Alignment.topRight,
                         child: Wrap(
                           // to apply margin in the cross axis of the wrap
                             spacing: -10,
                             children: <Widget>[
                               IconButton(
                                 icon: SvgPicture.asset("assets/icons/article.svg",
                                     height: 20, width: 25),
                                 onPressed: () => goToArticle(widget.slug),
                               ),
                               IconButton(
                                 icon: SvgPicture.asset("assets/icons/partager.svg",
                                     height: 15, width: 20),
                                 onPressed: () => Share.share(link),
                               ),
                             ]
                         ),
                       )
                     ],
                   ),
                 ],
               ),
             ),
           ],
         );
       }
       else {
         return Container(
           child: Card(
             child: Column(
               children: <Widget>[
                 SizedBox(height: 11),
                 Padding(
                   padding: EdgeInsets.only(left: 9, right:9),
                   child: Text(widget.title,
                       style: TextStyle(
                           fontSize: 17,
                           fontWeight: FontWeight.bold,
                           fontFamily: "Roboto")),
                 ),
                 SizedBox(height: 10,),
                 Divider(indent: 13, endIndent: 13,),
                 SizedBox(height: 10,),
                 SizedBox(height: 10,),
                 Container(
                     width: MediaQuery.of(context).size.width,
                     padding: EdgeInsets.only(left: 11),
                     child: Stack(
                       children: <Widget>[
                         //****************************HEADER*********************//
                         Row(
                           children: <Widget>[
                             CircleAvatar(
                               backgroundImage: NetworkImage(usr_img),
                             ),
                             Padding(
                                 padding: EdgeInsets.only(left: 13),
                                 child: Container(
                                   //width: MediaQuery.of(context).size.width,
                                   child: Column(
                                     mainAxisAlignment: MainAxisAlignment.start,
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: <Widget>[
                                       Text(usr_name, style: TextStyle(fontFamily: "DINNextLTPro-MediumCond", fontWeight: FontWeight.w600, fontSize: 18.0, color: Colors.black),),
                                       Row(
                                         mainAxisAlignment: MainAxisAlignment.start,
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children: <Widget>[
                                           Text("@"+usr_scrname, style: TextStyle( fontFamily: "DINNextLTPro-MediumCond", fontSize: 16.0, color: Colors.grey)),
                                           Container(
                                             padding: EdgeInsets.only(top: 3),
                                             child: setDate(date),
                                           )
                                         ],
                                       ),
                                     ],
                                   ),
                                 )
                             ),
                           ],
                         ),
                         Align(
                             alignment: Alignment.topRight,
                             child: Image.asset("assets/images/twitter.png", height: 15, width: 30)
                         )
                       ],
                     )
                 ),
                 SizedBox(height: 13),
                 //****************************TEXT*********************//
                 Container(
                   padding: EdgeInsets.only(left: 11),
                   alignment: Alignment.topLeft,
                   child: setText(_parseHtmlString(txt)),
                 ),
                 SizedBox(height: 11),
                 //****************************MEDIA*********************//
                 Container(),
                 //****************************FOOTER*********************//
                 Stack(
                   children: [
                     Padding(
                       padding: EdgeInsets.fromLTRB(15, 15, 55, 0),
                       child: Align(
                         alignment: Alignment.topLeft,
                         child: RichText(
                             text: TextSpan(
                                 children: [
                                   TextSpan(
                                       style: TextStyle(color: Colors.lightBlueAccent, fontSize: 15),
                                       text: "voir sur Twitter",
                                       recognizer: TapGestureRecognizer()..onTap =  () async{
                                         var url = "https://twitter.com/"+usr_scrname+"/status/"+widget.id+"?ref_src=twsrc%5Etfw";
                                         if (await canLaunch(url)) {
                                           await launch(url);
                                         } else {
                                           throw 'Could not launch $url';
                                         }
                                       }
                                   ),
                                 ]
                             )),
                       ),
                     ),
                     Container(
                       alignment: Alignment.topRight,
                       child: Wrap(
                         // to apply margin in the cross axis of the wrap
                           spacing: -10,
                           children: <Widget>[
                             IconButton(
                               icon: SvgPicture.asset("assets/icons/article.svg",
                                   height: 20, width: 25),
                               onPressed: () => goToArticle(widget.slug),
                             ),
                             IconButton(
                               icon: SvgPicture.asset("assets/icons/partager.svg",
                                   height: 15, width: 20),
                               onPressed: () => Share.share(link),
                             ),
                           ]
                       ),
                     )
                   ],
                 ),
                 SizedBox(height: 15)
               ],
             ),
           ),
         );
       }
     }
     else {
       if(type=="video") {
         String text = txt;
         if (txt.toString().contains("https://t.co/")){
           int end_index = txt.toString().length-23;
           setState(() {
             text = txt.substring(0, end_index);
           });
         }
         return Container(
           child: Column(
             children: <Widget>[
               SizedBox(height: 11),
               Container(
                   width: MediaQuery.of(context).size.width,
                   padding: EdgeInsets.only(left: 11),
                   child: Stack(
                     children: <Widget>[
                       //****************************HEADER*********************//
                       Row(
                         children: <Widget>[
                           CircleAvatar(
                             backgroundImage: NetworkImage(usr_img),
                           ),
                           Padding(
                               padding: EdgeInsets.only(left: 13),
                               child: Container(
                                 //width: MediaQuery.of(context).size.width,
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.start,
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: <Widget>[
                                     Text(usr_name, style: TextStyle(fontFamily: "DINNextLTPro-MediumCond", fontWeight: FontWeight.w600, fontSize: 18.0, color: Colors.black),),
                                     Row(
                                       mainAxisAlignment: MainAxisAlignment.start,
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: <Widget>[
                                         Text("@"+usr_scrname, style: TextStyle( fontFamily: "DINNextLTPro-MediumCond", fontSize: 16.0, color: Colors.grey)),
                                         Container(
                                           padding: EdgeInsets.only(top: 3),
                                           child: setDate(date),
                                         )
                                       ],
                                     ),
                                   ],
                                 ),
                               )
                           ),
                         ],
                       ),
                       Align(
                           alignment: Alignment.topRight,
                           child: Image.asset("assets/images/twitter.png", height: 15, width: 30)
                       )
                     ],
                   )
               ),
               SizedBox(height: 13),
               //****************************TEXT*********************//
               Container(
                 padding: EdgeInsets.only(left: 11),
                 alignment: Alignment.topLeft,
                 child: setText(_parseHtmlString(text)),
               ),
               SizedBox(height: 11),
               //****************************MEDIA*********************//
               Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     //Text("  Twitter · Video", style: TextStyle( fontFamily: "DINNextLTPro-MediumCond", fontSize: 16.0, color: Colors.grey)),
                     SizedBox(height: 25)
                   ]
               ),
               Container(
                 width: MediaQuery.of(context).size.width,
                 height: 300,
                 child: MyVideoPlayer(
                   videoUrl: media_url,
                 ),
               ),
               //****************************FOOTER*********************//
               Stack(
                 children: [
                   Padding(
                     padding: EdgeInsets.fromLTRB(15, 15, 0, 0),
                     child: Align(
                       alignment: Alignment.topLeft,
                       child: RichText(
                           text: TextSpan(
                               children: [
                                 TextSpan(
                                     style: TextStyle(color: Colors.lightBlueAccent, fontSize: 15),
                                     text: "voir sur Twitter",
                                     recognizer: TapGestureRecognizer()..onTap =  () async{
                                       var url = "https://twitter.com/"+usr_scrname+"/status/"+widget.id+"?ref_src=twsrc%5Etfw";
                                       if (await canLaunch(url)) {
                                         await launch(url);
                                       } else {
                                         throw 'Could not launch $url';
                                       }
                                     }
                                 ),
                               ]
                           )),
                     ),
                   ),
                   Container(
                     alignment: Alignment.topRight,
                     child: Wrap(
                       // to apply margin in the cross axis of the wrap
                         spacing: -10,
                         children: <Widget>[
                           IconButton(
                             icon: SvgPicture.asset("assets/icons/partager.svg",
                                 height: 15, width: 20),
                             onPressed: () => Share.share(link),
                           ),
                         ]
                     ),
                   )
                 ],
               ),
               Divider(indent: 11, endIndent: 11,),
               SizedBox(height: 15,)
             ],
           ),
         );
       }
       else if (type=="photo")  {
         String text = txt;
         if (txt.toString().contains("https://t.co/")){
           int end_index = txt.toString().length-23;
           setState(() {
             text = txt.substring(0, end_index);
           });
         }
         return Column(
           children: <Widget>[
             SizedBox(height: 15),
             Card(
               child: Column(
                 children: <Widget>[
                   SizedBox(height: 11),
                   //****************************HEADER****************************//
                   Container(
                       width: MediaQuery.of(context).size.width,
                       padding: EdgeInsets.only(left: 11),
                       child: Stack(
                         children: <Widget>[
                           Row(
                             children: <Widget>[
                               CircleAvatar(
                                 backgroundImage: NetworkImage(usr_img),
                               ),
                               Padding(
                                   padding: EdgeInsets.only(left: 13),
                                   child: Container(
                                     //width: MediaQuery.of(context).size.width,
                                     child: Column(
                                       mainAxisAlignment: MainAxisAlignment.start,
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: <Widget>[
                                         Text(usr_name, style: TextStyle(fontFamily: "DINNextLTPro-MediumCond", fontWeight: FontWeight.w600, fontSize: 18.0, color: Colors.black),),
                                         Row(
                                           mainAxisAlignment: MainAxisAlignment.start,
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: <Widget>[
                                             Text("@"+usr_scrname, style: TextStyle( fontFamily: "DINNextLTPro-MediumCond", fontSize: 16.0, color: Colors.grey)),
                                             Container(
                                               padding: EdgeInsets.only(top: 3),
                                               child: setDate(date),
                                             )
                                           ],
                                         ),
                                       ],
                                     ),
                                   )
                               ),
                             ],
                           ),
                           Align(
                               alignment: Alignment.topRight,
                               child: Image.asset("assets/images/twitter.png", height: 15, width: 30)
                           )
                         ],
                       )
                   ),
                   SizedBox(height: 13),
                   //**************************TEXT********************************//
                   Container(
                     padding: EdgeInsets.only(left: 11),
                     alignment: Alignment.topLeft,
                     child: setText(_parseHtmlString(text)),
                   ),
                   SizedBox(height: 11),
                   //*********************************IMG**************************//
                   setImage(),
                   //******************************FOOTER**************************//
                   Stack(
                     children: [
                       Padding(
                         padding: EdgeInsets.fromLTRB(15, 15, 0, 0),
                         child: Align(
                           alignment: Alignment.topLeft,
                           child: RichText(
                               text: TextSpan(
                                   children: [
                                     TextSpan(
                                         style: TextStyle(color: Colors.lightBlueAccent, fontSize: 15),
                                         text: "voir sur Twitter",
                                         recognizer: TapGestureRecognizer()..onTap =  () async{
                                           var url = "https://twitter.com/"+usr_scrname+"/status/"+widget.id+"?ref_src=twsrc%5Etfw";
                                           if (await canLaunch(url)) {
                                             await launch(url);
                                           } else {
                                             throw 'Could not launch $url';
                                           }
                                         }
                                     ),
                                   ]
                               )),
                         ),
                       ),
                       Container(
                         alignment: Alignment.topRight,
                         child: Wrap(
                           // to apply margin in the cross axis of the wrap
                             spacing: -10,
                             children: <Widget>[
                               IconButton(
                                 icon: SvgPicture.asset("assets/icons/partager.svg",
                                     height: 15, width: 20),
                                 onPressed: () => Share.share(link),
                               ),
                             ]
                         ),
                       )
                     ],
                   ),
                 ],
               ),
             ),
           ],
         );
       }
       else {
         return Container(
           child: Card(
             child: Column(
               children: <Widget>[
                 SizedBox(height: 10,),
                 Container(
                     width: MediaQuery.of(context).size.width,
                     padding: EdgeInsets.only(left: 11),
                     child: Stack(
                       children: <Widget>[
                         //****************************HEADER*********************//
                         Row(
                           children: <Widget>[
                             CircleAvatar(
                               backgroundImage: NetworkImage(usr_img),
                             ),
                             Padding(
                                 padding: EdgeInsets.only(left: 13),
                                 child: Container(
                                   //width: MediaQuery.of(context).size.width,
                                   child: Column(
                                     mainAxisAlignment: MainAxisAlignment.start,
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: <Widget>[
                                       Text(usr_name, style: TextStyle(fontFamily: "DINNextLTPro-MediumCond", fontWeight: FontWeight.w600, fontSize: 18.0, color: Colors.black),),
                                       Row(
                                         mainAxisAlignment: MainAxisAlignment.start,
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children: <Widget>[
                                           Text("@"+usr_scrname, style: TextStyle( fontFamily: "DINNextLTPro-MediumCond", fontSize: 16.0, color: Colors.grey)),
                                           Container(
                                             padding: EdgeInsets.only(top: 3),
                                             child: setDate(date),
                                           )
                                         ],
                                       ),
                                     ],
                                   ),
                                 )
                             ),
                           ],
                         ),
                         Align(
                             alignment: Alignment.topRight,
                             child: Image.asset("assets/images/twitter.png", height: 15, width: 30)
                         )
                       ],
                     )
                 ),
                 SizedBox(height: 13),
                 //****************************TEXT*********************//
                 Container(
                   padding: EdgeInsets.only(left: 11),
                   alignment: Alignment.topLeft,
                   child: setText(_parseHtmlString(txt)),
                 ),
                 SizedBox(height: 11),
                 //****************************MEDIA*********************//
                 Container(),
                 //****************************FOOTER*********************//
                 Stack(
                   children: [
                     Padding(
                       padding: EdgeInsets.fromLTRB(15, 15, 55, 0),
                       child: Align(
                         alignment: Alignment.topLeft,
                         child: RichText(
                             text: TextSpan(
                                 children: [
                                   TextSpan(
                                       style: TextStyle(color: Colors.lightBlueAccent, fontSize: 15),
                                       text: "voir sur Twitter",
                                       recognizer: TapGestureRecognizer()..onTap =  () async{
                                         var url = "https://twitter.com/"+usr_scrname+"/status/"+widget.id+"?ref_src=twsrc%5Etfw";
                                         if (await canLaunch(url)) {
                                           await launch(url);
                                         } else {
                                           throw 'Could not launch $url';
                                         }
                                       }
                                   ),
                                 ]
                             )),
                       ),
                     ),
                     Container(
                       alignment: Alignment.topRight,
                       child: Wrap(
                         // to apply margin in the cross axis of the wrap
                           spacing: -10,
                           children: <Widget>[
                             IconButton(
                               icon: SvgPicture.asset("assets/icons/partager.svg",
                                   height: 15, width: 20),
                               onPressed: () => Share.share(link),
                             ),
                           ]
                       ),
                     )
                   ],
                 ),
                 SizedBox(height: 15)
               ],
             ),
           ),
         );
       }
     }
   }

   Widget _embed () {
     return Container(child: TweetWebView.tweetID(id));
   }

   Widget _Loader() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: Card(
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          child: Column(
            children: <Widget>[
              SizedBox(height: 11),
              Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 11),
                  child: Stack(
                    children: <Widget>[
                      //****************************HEADER*********************//
                      Row(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Colors.white,
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 13),
                              child: Container(
                                //width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: 200,
                                      height: 8.0,
                                      color: Colors.white,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 2.0),
                                    ),
                                    Container(
                                      width: 40.0,
                                      height: 8.0,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              )
                          ),
                        ],
                      ),
                      Align(
                          alignment: Alignment.topRight,
                          child: Image.asset("assets/images/twitter.png", height: 15, width: 30)
                      )
                    ],
                  )
              ),
              SizedBox(height: 13),
              //****************************TEXT*********************//
              Padding(
                padding: EdgeInsets.only(left: 11),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 8.0,
                      color: Colors.white,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.0),
                    ),
                    Container(
                      width: double.infinity,
                      height: 8.0,
                      color: Colors.white,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.0),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 11),
              //****************************MEDIA**********************//
              Container(
                height: 250,
                color: Colors.white,
              ),
              SizedBox(height: 11),
              //****************************FOOTER*********************//
              Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 15, 0, 0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: RichText(
                          text: TextSpan(
                              children: [
                                TextSpan(
                                    style: TextStyle(color: Colors.lightBlueAccent, fontSize: 15),
                                    text: "voir sur Twitter",
                                    recognizer: TapGestureRecognizer()..onTap =  () async{
                                      var url = "https://twitter.com/"+usr_scrname+"/status/"+widget.id+"?ref_src=twsrc%5Etfw";
                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    }
                                ),
                              ]
                          )),
                    ),
                  ),
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
              SizedBox(height: 15,)
            ],
          ),
        ),
      )
    );
    Container(
      padding: EdgeInsets.fromLTRB(15, 15, 25, 0),
      child: Card(
          child: Center(
              child: Image.asset(
                'assets/gifs/green_style.gif', height: 35, width: 35,)
          )
      ),
    );
   }
}

