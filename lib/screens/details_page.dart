import 'dart:async';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/painting.dart';
import 'dart:io' show Platform;
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'dart:convert';
import 'package:wiwmedia_wiwsport_v3/model/post.dart';
import 'package:wiwmedia_wiwsport_v3/model/user.dart';
import 'package:wiwmedia_wiwsport_v3/pages/ExplorerNews.dart';
import 'package:wiwmedia_wiwsport_v3/pages/HomePage.dart';
import 'package:wiwmedia_wiwsport_v3/pages/ForumPage.dart';
import 'package:wiwmedia_wiwsport_v3/pages/User/Room.dart';
import 'package:wiwmedia_wiwsport_v3/reusable/embedBlockquote.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:wiwmedia_wiwsport_v3/reusable/players/twitter.dart';
import 'package:share/share.dart';
import 'package:wiwmedia_wiwsport_v3/screens/charte.dart';
import 'package:wiwmedia_wiwsport_v3/screens/menu/page_newsletter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';

import 'notification_page.dart';



class DetailsPage extends StatefulWidget {
  final Post post;
  final bool isConnect;
  final bool fromRoom;
  final Utilisateur user;
  //final String email;
  //final String pp;

  DetailsPage({Key key, this.post, this.isConnect, this.user, this.fromRoom}): super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> with WidgetsBindingObserver {

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    Reload();
  }

  Reload(){
    if(widget.post.slug==null) {
      print("------------------------------------------------------------------->Error Slug NULL ");
    }
    else {
      Navigator.pop(context);
      return  Navigator.push(
          context,
          MaterialPageRoute(
              settings: RouteSettings(name:''),
              builder: (BuildContext context){
                print("--------------------------------------------------------------------->data sended:${widget.post.slug}");
                return NotificationPage(post: widget.post, link:widget.post.slug, user: widget.user, fromRoom: false);

                DetailsPage(post: widget.post, user: widget.user, isConnect: widget.isConnect, fromRoom: false);
              }
          )
      );
    }
  }

  String title ;
  String content;
  String link;
  String image;
  String categorie;
  int categorie_id;
  String date;
  var suggestion_title;
  var suggestion_image;
  var suggestion_date;
  //String suggestion_title;


  List<Post> posts = List();

  FirebaseAnalytics analytics;
  void onLink() {
    analytics.logEvent(
      name: 'deep_linking_page',
    );
  }


  bool isload = false;
  List<Post> suggestions = new List();
  Future<void> fetchSuggestions() async {
    setState(() {
      this.isload = true;
    });

    final responses = await http.get(
        "https://wiwsport.com/wp-json/wp/v2/posts?_embed&_fields=id,title,slug,content,date,categories,link,_links.wp:featuredmedia,_links.wp:term&per_page=8&categories="+categorie_id.toString());
    if (responses.statusCode == 200) {
      posts = (json.decode(responses.body) as List).map((data) {
        return Post.fromJSON(data);
      }).toList()
        ..shuffle();

      setState(() {
        suggestions = posts;
        isload = false;
      });
    }

  }

  generateDate(int jour, int mois, int annee, String hh, String mm ) {
    String _dateTime = "";
    if(mois == 1)
    {
      _dateTime =  "le ${jour} Janv. ${annee} à ${hh}h${mm}";
    } else if(mois == 2)
    {
      _dateTime = "le ${jour} Fev. ${annee} à ${hh}h${mm}";
    } else if(mois == 3)
    {
      _dateTime = "le ${jour} Mars ${annee} à ${hh}h${mm}";
    } else if(mois == 4)
    {
      _dateTime = "le ${jour} Avr. ${annee} à ${hh}h${mm}";
    } else if(mois == 5)
    {
      _dateTime = "le ${jour} Mai ${annee}  à ${hh}h${mm}";
    } else if(mois == 6)
    {
      _dateTime = "le ${jour} Juin ${annee} à ${hh}h${mm}";
    }else if(mois == 7)
    {
      _dateTime = "le ${jour} Juil. ${annee} à ${hh}h${mm}";
    } else if(mois == 8)
    {
      _dateTime = "le ${jour} Aout. ${annee} à ${hh}h${mm}";
    } else if(mois == 9)
    {
      _dateTime = "le ${jour} Sept. ${annee} à ${hh}h${mm}";
    } else if(mois == 10)
    {
      _dateTime = "le ${jour} Oct. ${annee} à ${hh}h${mm}";
    }
    else if(mois == 11)
    {
      _dateTime = "le ${jour} Nov. ${annee} à ${hh}h${mm}";
    }
    else if(mois == 12)
    {
      _dateTime = "le ${jour} Dec. ${annee} à ${hh}h${mm}";
    }
    return Text(_dateTime, style: TextStyle(
      fontSize: 13,
      fontWeight: null,
      fontFamily: "DINNextLTPro-MediumCond",
      color: Colors.black45,
    ));
  }


  List<Widget> widgetlist = new List<Widget>();
  List<Widget> listwidget = new List<Widget>();
  int cpt = 1;


  setContent(String _content){
    bool isEmbed = _content.contains("</blockquote");
    if( !isEmbed ){
      if(_content.contains('intro-text')){
        return HtmlWidget(
          _content,
          textStyle: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.normal,
            fontFamily: "DINNextLTPro-MediumCond",
            color: Colors.black,
          ),
          onTapUrl: (url) {
            print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>lien interne = $url');
            if(url.contains('wiwsport')){
              var slug = url.substring(32);
              print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>slug = $slug');
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(
                    //settings: RouteSettings(name:n),
                      builder: (context) => NotificationPage(post: widget.post, user: widget.user, fromRoom: false, link: url.substring(32))));

            }
            else {
              return _launchUrl(url);
            }
          },
          webView: true,
        );
      } else {
        return HtmlWidget(
          _content,
          textStyle: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.normal,
            fontFamily: "DINNextLTPro-MediumCond",
            color: Colors.black,
          ),
          onTapUrl: (url) {
            print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>lien interne = $url');
            if(url.contains('wiwsport')){
              var slug = url.substring(32);
              print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>slug = $slug');
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(
                    //settings: RouteSettings(name:'lien interne: $slug'),
                      builder: (context) => NotificationPage(post: widget.post, user: widget.user, fromRoom: false, link: url.substring(32))));

            }
            else {
              return _launchUrl(url);
            }
          },
          webView: true,
        );
      }
    }
    else {
      String  tag  = "<blockquote";
      String end_tag = "</blockquote>";
      int endIndex_01 = _content.toString().indexOf(tag);


      //print(">>>>>>>>>>>>>>>>>>>>>>end INDEX OF BLOCQIOTE= "+endIndex_01.toString());

      String text_part = _content.toString().substring(0, endIndex_01);
      //print(">>>>>>>>>>>>>>>>>>>>>>TEXT PART= "+text_part.toString());
      var paragraphe = loadHtml(text_part);
      widgetlist.add(paragraphe);




      int endIndex_02 = _content.toString().indexOf(end_tag);
      String tag_part = _content.toString().substring(endIndex_01, endIndex_02+end_tag.length);
      //print(">>>>>>>>>>>>>>>>>>>>>>EMBED PART= "+tag_part.toString());
      var embed = loadEmbed(tag_part);
      widgetlist.add(embed);

      for(int i=0; i<widgetlist.length;i++) {
        print(widgetlist[i].toString());
      }
      String res = _content.toString().substring( endIndex_02+end_tag.length);
      print(">>>>>>>>>>>>>>>>>>>>>>REST PART= "+res.toString()+"longueur: "+res.length.toString());

      //|| res.contains("</iframe")


      if(res.contains("</blockquote") ) {
        return setContent(res);
      }
      else  {
        var restant = loadHtml(res);
        widgetlist.add(restant);
        return Column(
            children: widgetlist
        );
      }
      //setContent(res);
      //for(int i=0; i<widgetlist.length;i++) {
      //print(widgetlist[i].toString());

      //}
    }
  }

  loadHtml(_html) {
    //String style = '<style type=text/css> .intro-text {font-size: 1.25em;line-height: 1.25em;color: #212121;letter-spacing: -.01em;}</style> ';
    //String htmlContent = style+_html;

    final find = 'width=\"500\"';
    final replaceWith = 'width=100%';
    final newString = _html.replaceAll(find, replaceWith);

    final img = '<img';
    final resizedImg ='<img style="max-width:100%; height:auto;"';
    final result = newString.replaceAll(img, resizedImg);

    if(_html.contains('intro-text')){
      return HtmlWidget(
        result,
        unsupportedWebViewWorkaroundForIssue37: true,
        textStyle: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.normal,
          fontFamily: "DINNextLTPro-MediumCond",
          color: Colors.black,
        ),
        onTapUrl: (url){
          if(url.contains('wiwsport.com')) {
           // onLink();
            print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>> slug du lien interne: "+url.substring(32));
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(
                    settings: RouteSettings(name: url.substring(32)),
                    builder: (context) => NotificationPage(post: widget.post,user: widget.user, fromRoom: false, link: url.substring(32),)));
          }
          else {
            print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>  lien interne: "+url);
            return _launchUrl(url);
          }
        },
        webView: true,
        webViewJs: true,
      );
    }
    else if(_html.toString().contains('.wp-caption .wp-caption-text')) {
      return HtmlWidget(
        result,
        unsupportedWebViewWorkaroundForIssue37: true,
        textStyle: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.normal,
          fontFamily: "DINNextLTPro-MediumCond",
          color: Color(0xffa0a0a0),
        ),
        onTapUrl: (url){
          if(url.contains('wiwsport.com')) {
            //onLink();
            print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>> slug du lien interne: "+url.substring(32));
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(
                    settings: RouteSettings(name: url.substring(32)),
                    builder: (context) => NotificationPage(post: widget.post,user: widget.user, fromRoom: false, link: url.substring(32),)));
          }
          else {
            print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>  lien interne: "+url);
            return _launchUrl(url);
          }
        },
        webView: true,
        webViewJs: true,
      );
    }
    else {
      return HtmlWidget(
        result,
        unsupportedWebViewWorkaroundForIssue37: true,
        textStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.normal,
          fontFamily: "DINNextLTPro-MediumCond",
          color: Colors.black,
        ),
        onTapUrl: (url){
          if(url.contains('wiwsport.com')) {
            //onLink();
            print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>> slug du lien interne: "+url.substring(32));
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(
                    settings: RouteSettings(name: url.substring(32)),
                    builder: (context) => NotificationPage(post: widget.post,user: widget.user, fromRoom: false, link: url.substring(32),)));
          }
          else {
            print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>  lien interne: "+url);
            return _launchUrl(url);
          }
        },
        webView: true,
        webViewJs: true,
      );
    }

  }


  loadEmbed (_blockquote) {
    if(_blockquote.toString().contains('twitter')){
      String debut_src = "/status/";
      int index_debut_src = _blockquote.indexOf(debut_src)+debut_src.length;
      String _bq = _blockquote.substring(index_debut_src);
      RegExp re = RegExp(r'(\d+)');
      String src =re.stringMatch(_bq);
      print("ID TWITTER: $src");
      return  Column(
        children: <Widget>[
          //TwitterCardPlus(id: src, isExplorer: false),
          EmbedBlockquoteTwitter(block: _blockquote),
          SizedBox(height: 20),
        ],
      );
    }
    else if (_blockquote.toString().contains('instagram')) {
      return Column(
        children: <Widget>[
          EmbedBlockquoteInsta(block: _blockquote),
          SizedBox(height: 20),
        ],
      );
    }
    else {
      return loadHtml(_blockquote);
    }
  }

  loadSuggestion (suggestions) {

    if ( suggestions.length > 0) {
      return  this.isload
          ? Center(
        child: Image.asset('assets/gifs/green_style.gif', height: 15, width: 15),
      )
          : ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          DateTime dateTime = DateTime.parse(suggestions[index].date);
          var an = int.parse(suggestions[index].date.substring(0, 4));
          var mois = int.parse(suggestions[index].date.substring(5, 7));
          var jour = int.parse(suggestions[index].date.substring(8, 10));
          var hh = DateFormat("HH").format(dateTime);
          //int.parse(date.substring(11, 13));
          var mn = DateFormat("mm").format(dateTime);
          //int.parse(date.substring(14, 16));
          var _date = generateDate(jour, mois, an, hh, mn);
           String subtitle;

          if(suggestions[index].title.toString().length<50){
            subtitle = suggestions[index].title;
          } else {
            subtitle = suggestions[index].title.substring(0, 50);
          }

          if(this.suggestions[index].slug == widget.post.slug){
            return Container();
          } else {
            if(index == 0){
              return InkWell(
                  onTap: () {
                    //Navigator.pop(context);
                    //print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<vas vers:'+suggestions[index].title);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          settings: RouteSettings(name: subtitle),
                          builder: (BuildContext context) {
                            return widget.isConnect ==null ? DetailsPage(post:suggestions[0])
                                : widget.isConnect ? DetailsPage(post:suggestions[0], isConnect: widget.isConnect, user: widget.user,)
                                : DetailsPage(post:suggestions[0]);
                            //return DetailsPage(post:suggestions[0]);
                          },
                          fullscreenDialog: true),
                    );
                  },
                  child: Padding(
                    padding:
                    const EdgeInsets.only(left: 0, right: 0, top: 15, bottom: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 7, left: 7),
                          child: setFirstImageSuggestion(context, suggestions, index)
                          ),
                        SizedBox(height: 3),
                        Padding(
                          padding: EdgeInsets.only(left: 11),
                          child: Text(suggestions[0].title.toString(),
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Roboto")),
                        ),
                        SizedBox(height: 5),
                        Padding(
                          padding: EdgeInsets.only(left: 11),
                          child: getDate(suggestions[0].date) ,
                        ),
                        SizedBox(height: 3),
                        Divider(),
                      ],
                    ),
                  ));
            }
            else {
              if(index == 2) {
                return new Column(
                  mainAxisAlignment: MainAxisAlignment
                      .start,
                  crossAxisAlignment: CrossAxisAlignment
                      .start,
                  children: <Widget>[
                    new ListTile(
                      leading: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: 100,
                          minHeight: 120,
                          maxWidth: 100,
                          maxHeight: 164,
                        ),
                        child: setImageSuggestion(context, suggestions, index),
                      ),
                      title: new Text(suggestions[index].title,
                        style: new TextStyle(fontSize: 17.0,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: new Column(
                          mainAxisAlignment: MainAxisAlignment
                              .start,
                          crossAxisAlignment: CrossAxisAlignment
                              .start,
                          children: <Widget>[
                            getDate(suggestions[index].date),
                          ]),
                      onTap: () {
                        //Navigator.pop(context);
                        print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<vas vers:'+suggestions[index].title);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              settings: RouteSettings(name: subtitle),
                              builder: (
                                  BuildContext context) {
                                return widget.isConnect ==null ? DetailsPage(post:suggestions[index])
                                    : widget.isConnect ? DetailsPage(post:suggestions[index], isConnect: widget.isConnect, user: widget.user,)
                                    : DetailsPage(post:suggestions[index]);
                              },
                              fullscreenDialog: true),
                        );
                      },
                    ),
                    SizedBox(height: 20,),
                    Align(
                      alignment: Alignment.center,
                      child: AdmobBanner(
                        adUnitId: 'ca-app-pub-9120523919163473/8070870013',
                        adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                      ),
                    ),
                  ],
                );
              }
              else if(index == 4 ) {
                return new Column(
                  mainAxisAlignment: MainAxisAlignment
                      .start,
                  crossAxisAlignment: CrossAxisAlignment
                      .start,
                  children: <Widget>[
                    new ListTile(
                      leading: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: 100,
                          minHeight: 120,
                          maxWidth: 100,
                          maxHeight: 164,
                        ),
                        child: setImageSuggestion(context, suggestions, index),
                      ),
                      title: new Text(
                        suggestions[index].title,
                        style: new TextStyle(fontSize: 17.0,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: new Column(
                          mainAxisAlignment: MainAxisAlignment
                              .start,
                          crossAxisAlignment: CrossAxisAlignment
                              .start,
                          children: <Widget>[
                            getDate(suggestions[index].date),
                          ]),
                      onTap: () {
                        //Navigator.pop(context);
                        print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<vas vers:'+suggestions[index].title);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              settings: RouteSettings(name: subtitle),
                              builder: (
                                  BuildContext context) {
                                return widget.isConnect ==null ? DetailsPage(post:suggestions[index])
                                    : widget.isConnect ? DetailsPage(post:suggestions[index], isConnect: widget.isConnect, user: widget.user,)
                                    : DetailsPage(post:suggestions[index]);
                              },
                              fullscreenDialog: true),
                        );
                      },
                    ),
                    SizedBox(height: 20,),
                    InkWell(
                      onTap: ()  {
                        _launchUrl("https://wiwsport.com/2020/05/04/telecharger-1xbet-et-obtenez-jusqua-130-de-bonus-avec-wiwsport/");
                      },
                      child: ListTile(
                        leading: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: 100,
                            minHeight: 120,
                            maxWidth: 100,
                            maxHeight: 164,
                          ),
                          child: Image.asset("assets/images/bet.jpeg"),
                        ),
                        title: new Text(
                          "Télécharger 1xBet pour Android, iOS",
                          style: new TextStyle(fontSize: 17.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                  ],
                );
              }
              else {
                return new Column(
                  mainAxisAlignment: MainAxisAlignment
                      .start,
                  crossAxisAlignment: CrossAxisAlignment
                      .start,
                  children: <Widget>[
                    new ListTile(
                      leading: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: 100,
                          minHeight: 120,
                          maxWidth: 100,
                          maxHeight: 164,
                        ),
                        child: setImageSuggestion(context, suggestions, index),
                      ),
                      title: new Text(suggestions[index].title,
                        style: new TextStyle(fontSize: 17.0,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: new Column(
                          mainAxisAlignment: MainAxisAlignment
                              .start,
                          crossAxisAlignment: CrossAxisAlignment
                              .start,
                          children: <Widget>[
                            getDate(suggestions[index].date),
                          ]),
                      onTap: () {
                        print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<vas vers:'+suggestions[index].title);
                        //Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              settings: RouteSettings(name: subtitle),
                              builder: (
                                  BuildContext context) {
                                return DetailsPage(post:suggestions[index], isConnect: widget.isConnect, user: widget.user,);
                              },
                              fullscreenDialog: true),
                        );
                      },
                    ),
                  ],
                );
              }
            }
          }

        },
      );
    } else {
      return CircularProgressIndicator();
    }
  }


  setImage(context){
    if(widget.post.image == null){
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 1000,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Image.asset("assets/bug_img.jpeg"),
        ),
      );
    } else {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Image.network(
          widget.post.image,
          fit: BoxFit.fill,
        ),
      );
    }
  }

  setImageSuggestion(context,item,index){
    if(item[index].image == null){
      return  Image.asset("assets/bug_img.jpeg");

    } else {
      return Image.network(
          item[index].image,
          fit: BoxFit.cover);
    }
  }

  setFirstImageSuggestion(context,item,index){
    if(item[index].image == null){
      return  Image.asset("assets/bug_img.jpeg");

    } else {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: FadeInImage.assetNetwork(
          placeholder: 'assets/reloading.gif',
          image: item[index].image,
          fit: BoxFit.fill,
        ),
      );
                      
    }
  }

  getDate(articles) {
    DateTime dateTime = DateTime.parse(articles);
    DateTime now = new DateTime.now();

    if((dateTime.day == now.day)&&(dateTime.month == now.month)){
      String date = DateFormat("HH").format(dateTime)+'h'+DateFormat("mm").format(dateTime);
      return Text(date, style: TextStyle(
        fontSize: 13,
        fontWeight: null,
        fontFamily: "DINNextLTPro-MediumCond",
        color: Colors.black45,
      ));
    }
    else {
      String date = DateFormat("dd").format(dateTime)+'/'+DateFormat("MM").format(dateTime);
      return Text(date, style: TextStyle(
        fontSize: 13,
        fontWeight: null,
        fontFamily: "DINNextLTPro-MediumCond",
        color: Colors.black45,
      ));
    }
  }

  var content_1;
  var content_2;
  var date_content;
  String subtitle;
  var articles_suggestions;
  bool ispanding = true;
  disable_panding () {
    setState(() {
      ispanding = false;
    });
  }

  @override
  void initState () {
    var p1 = widget.post.content.substring(0, widget.post.content.indexOf("</div>")+6);
    var p2 = widget.post.content.substring(widget.post.content.indexOf("</div>")+7);

    content_1 = setContent(p1);
    content_2 = setContent(p2);
    title = widget.post.title;
    date = widget.post.date;
    categorie = widget.post.category;
    categorie_id =widget.post.category_id;
    link = widget.post.link;
    if(widget.post.title.toString().length<50){
      subtitle = title;
    } else {
      subtitle = title.substring(0, 50);
    }


    DateTime dateTime = DateTime.parse(date);
    var an = int.parse(date.substring(0, 4));
    var mois = int.parse(date.substring(5, 7));
    var jour = int.parse(date.substring(8, 10));
    var hh = DateFormat("HH").format(dateTime);
    //int.parse(date.substring(11, 13));
    var mn = DateFormat("mm").format(dateTime);
    //int.parse(date.substring(14, 16));
    date_content = generateDate(jour, mois, an, hh, mn);
    
    
    fetchSuggestions();

    Future.delayed(Duration(seconds: 5), disable_panding());

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch(state){
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(date);
    var an = int.parse(date.substring(0, 4));
    var mois = int.parse(date.substring(5, 7));
    var jour = int.parse(date.substring(8, 10));
    var hh = DateFormat("HH").format(dateTime);
    //int.parse(date.substring(11, 13));
    var mn = DateFormat("mm").format(dateTime);
    //int.parse(date.substring(14, 16));

    return  Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          iconSize: 24,
          color: Colors.black,
          onPressed: () {
            widget.fromRoom ==null || widget.fromRoom ==false ?
            Navigator.pop(context)
                :Navigator.push(context, MaterialPageRoute(builder: (context)=>widget.isConnect? HomePage(isUser: true, user: widget.user):HomePage()));
          },
        ),
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.fromLTRB(3.0, 15.0, 9.0, 15.0),
            padding: const EdgeInsets.fromLTRB(3, 1, 3, 3),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFF339966), width: 1),
            ),
            child: InkWell(
              onTap: () => Share.share(link, subject: title),
              child: Text(" partager ", style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
                fontFamily: "DINNextLTPro-MediumCond",
                color: Colors.black,
              )),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(3.0, 15.0, 9.0, 15.0),
            padding: const EdgeInsets.fromLTRB(3, 1, 3, 3),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFFabd9c2), width: 1),
              color: Color(0xFFabd9c2),
            ),
            child: InkWell(
              onTap: () {
                return Navigator.push(
                  context,
                  MaterialPageRoute(
                      settings: RouteSettings(name: 'newsletter'),
                      builder: (BuildContext context) {
                        return NewsLetterPage();
                      },
                      fullscreenDialog: true),
                );
              },
              child: Text(" s'abonner ", style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
                fontFamily: "DINNextLTPro-MediumCond",
                color: Colors.black,
              )),
            ),
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body:  Stack(
        children: [
          RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _refresh,
            child: Container(
              // physics: ScrollPhysics(),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                              padding: EdgeInsets.only(left: 13, right: 11),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(" "+categorie.toString()+" ",
                                      textAlign: TextAlign.values.first,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "DINNextLTPro-MediumCond",
                                        color:  Color(0xFF339966),
                                      )),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    title.toString(),
                                    style: TextStyle(
                                      fontFamily: "DINNextLTPro-MediumCond",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () async {},
                                        child: Text("wiwsport.com - ", style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: null,
                                          fontFamily: "DINNextLTPro-MediumCond",
                                          color: Colors.teal,
                                        )),
                                      ),
                                      generateDate(jour, mois, an, hh, mn),
                                    ],
                                  ),
                                ],
                              )
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          setImage(context),
                          SizedBox(
                            height: 30,
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width,
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  content_1,
                                  SizedBox(height: 20,),
                                  Center(
                                    //padding: EdgeInsets.all(5),
                                    child: Container(
                                      child: AdmobBanner(
                                        adUnitId: 'ca-app-pub-9120523919163473/3201686719',
                                        adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  content_2,
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                          Center(
                            child: IntrinsicHeight(
                              child: AdmobBanner(
                                adUnitId: 'ca-app-pub-9120523919163473/5429460466',
                                adSize: AdmobBannerSize.LARGE_BANNER,
                              ),
                            )
                          ),
                          SizedBox(height: 15),
                          Comments(),
                          SizedBox(height: 15),
                          Container(
                              padding: EdgeInsets.only(left: 11),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(height: 30,),
                                  Container(
                                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(0, 5, 3, 2),
                                            child : Image.asset('assets/images/sqare.png', height: 15, width: 24,),
                                          ),
                                          SizedBox(height: 20,),
                                          Text("Lire Aussi",
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22,
                                                color: Colors.black,
                                              )),
                                        ],
                                      )
                                  ),
                                ],
                              )
                          ),
                          loadSuggestion(suggestions),
                          SizedBox(height: 111),
                        ],
                      ),
                    ),
                  ],
                )
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: IntrinsicHeight(
              child: _MessageField(),
            ),
          )
        ],
      ),
    );
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Widget Comments() {
    //print("ID ROOM ------------------>${widget.post.id}<---------------------");
    return Column(
      children: [
        Container(
          child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('room-' + widget.post.id.toString())
                  .orderBy('date')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                    child: Image.asset(
                      'assets/gifs/green_style.gif',
                      height: 25,
                      width: 25,
                    ),
                  );

                return Container(
                  color: Colors.grey[200],
                  height: 50,
                  child: Stack(children: [
                    Container(
                      padding: EdgeInsets.all(13.0),
                      alignment: Alignment.topLeft,
                      child: Text("     commentaires (${snapshot.data.size})",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      padding: EdgeInsets.all(13.0),
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () =>
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.bottomToTop,
                                child: Charte(
                                  isUser: widget.isConnect,
                                  user: widget.user,
                                ),
                              ),
                            ),
                        child: Text(
                          "lire la charte >",
                          style: TextStyle(fontSize: 15, color: Colors.teal),
                        ),
                      ),
                    )
                  ]),
                );
              }),
        ),
        Padding(
            padding: EdgeInsets.all(21.0),
            child: InkWell(
              onTap: () => GetRoom(widget.post, true, false, "", "", ""),
              child: Container(
                  height: 41,
                  color: Colors.teal,
                  child: Center(
                    child: Text(
                      "commenter cet article",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  )),
            )),
        Container(
          padding: EdgeInsets.only(left: 9.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('room-' + widget.post.id.toString())
                .orderBy('date')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: Image.asset(
                    'assets/gifs/green_style.gif',
                    height: 25,
                    width: 25,
                  ),
                );

              List<DocumentSnapshot> docs = snapshot.data.docs;

              List<Widget> messages = docs
                  .map((doc) => MessageCard(
                        from: doc['from'],
                        content: doc['content'],
                        type: doc['type'],
                        date: doc['date'],
                        me: null,
                        timer: doc['duration'],
                        post: widget.post,
                        user: widget.user,
                        isConnect: widget.isConnect,
                      ))
                  .toList();

              return messages.length > 0
                  ? messages.length == 1
                      ? Column(
                          //controller: scrollController,
                          children: <Widget>[
                            messages[0],
                            //messages[1],
                            //messages[2],
                          ],
                        )
                      : Column(
                          //controller: scrollController,
                          children: <Widget>[
                            Divider(thickness: 1, color: Colors.black12),
                            messages[messages.length - 2],
                            Divider(thickness: 1, color: Colors.black12),
                            messages[messages.length - 1],
                            Divider(thickness: 1, color: Colors.black12),
                            //messages[2],
                          ],
                        )
                  : Container();
            },
          ),
        ),
        Container(
          child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('room-' + widget.post.id.toString())
                  .orderBy('date')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                    child: Image.asset(
                      'assets/gifs/green_style.gif',
                      height: 25,
                      width: 25,
                    ),
                  );
                return Container(
                  color: Colors.grey[200],
                  height: 50,
                  child: Container(
                    padding: EdgeInsets.all(15.0),
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () =>
                          GetRoom(widget.post, false, false, "", "", ""),
                      child: Text(
                          "voir tous les commentaires...  (${snapshot.data.size})                        >",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: "DINNextLTPro-MediumCond",
                            color: Colors.teal,
                          )),
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
  
  
  Widget _MessageField() {
    //print("--------------------------------------------------------------------->ID DETAILPAGE : ${widget.post.id} de ${widget.post.title}");
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent
      ),
      child:  IntrinsicHeight(
        child: Column(
          children: [
            Container(
                color: Colors.white,
                child: AdmobBanner(
                  adUnitId: 'ca-app-pub-9120523919163473/1186325092',
                  adSize: AdmobBannerSize.FULL_BANNER,
                ),
              ),
            Expanded(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(5.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                          padding: EdgeInsets.only(left:8.0),
                          //margin: EdgeInsets.only(top: 21),
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Padding(
                              padding: EdgeInsets.only(left: 7),
                              child: TextField(
                                keyboardType: TextInputType.multiline,
                                readOnly: true,
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder:(context)=>Room(fromForum: false, article: widget.post, user:widget.user, isAnswer: false, isComment: false, answer:"", answerTo: "", answerType:""))),
                                decoration: InputDecoration(
                                  hintText: "écrire un commentaire...",
                                  border: InputBorder.none,
                                ),
                                controller: messageController,
                                autofocus: false,
                              )
                          )
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.fromLTRB(3, 1, 3, 3),
                      child: InkWell(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder:(context)=>Room(fromForum: false, article: widget.post, user:widget.user, isAnswer: false, isComment: false, answer:"", answerTo: "", answerType:""))),
                        child: StreamBuilder(
                          stream: _firestore
                              .collection('room-'+widget.post.id.toString())
                          //.orderBy('date')
                              .snapshots(),
                          builder: (context, snapshot){
                            if (!snapshot.hasData) return Center(
                              child: Image.asset(
                                'assets/gifs/green_style.gif', height: 25, width: 25,),
                            );
                            return Row(
                              children: [
                                Text(
                                  "${snapshot.data.size}",
                                  style: TextStyle(color:Colors.blueGrey),
                                ),
                                SizedBox(width: 3),
                                Icon(Icons.chat, size: 23, color: Colors.teal,),
                              ],
                            );
                          },

                        ),
                      ),
                    ),
                  ],
                ),
              )
            )
          ],
        ),
      )
    );
  }

  GetRoom(Post _post, isComment, isAnswer, answer, answerTo, answerType){
    return Navigator.push(context, MaterialPageRoute(builder:(context)=>Room(fromForum: false, article: widget.post, user:widget.user, isAnswer: isAnswer, isComment: isComment, answer:answer, answerTo: answerTo, answerType:answerType)));
  }
}

_launchUrl(String link) async {
  if (await canLaunch(link)) {
    await launch(link);
  } else {
    throw 'Cannot launch $link';
  }
}
