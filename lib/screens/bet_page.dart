import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:flutter_svg/svg.dart';
import 'package:share/share.dart';
import 'package:social_embed_webview/social_embed_webview.dart';
import 'package:wiwmedia_wiwsport_v3/model/post.dart';
import 'package:wiwmedia_wiwsport_v3/pages/HomePage.dart';
import 'package:wiwmedia_wiwsport_v3/reusable/CustomSearchDelegate.dart';
import 'package:http/http.dart' as http;
import 'package:wiwmedia_wiwsport_v3/screens/details_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/parser.dart';
//import 'package:flutter_google_ad_manager/ad_size.dart';
//import 'package:flutter_google_ad_manager/banner.dart';

class BetPage extends StatefulWidget {
  @override
  _BetPageState createState() => _BetPageState();
}

class _BetPageState extends State<BetPage> {

  Bet article;
  List<Bet> articles = List();

  String get title => null;

  get link => null;

  List<Post> suggestions = List();
  bool isload = false;
  Future<void> fetchSuggestions() async {
    setState(() {
      isload = true;
    });
    //var cat = data[0].category;
    final responses = await http.get(
        "https://wiwsport.com/wp-json/wp/v2/posts?_embed");
    if (responses.statusCode == 200) {
      suggestions = (json.decode(responses.body) as List).map((data) {
        return Post.fromJSON(data);
      }).toList();
      setState(() {
        isload = false;
      });
    }
  }

  Future<void> getPage() async {
    final response = await http.get(
        "https://wiwsport.com/wp-json/wp/v2/posts?slug=telecharger-1xbet-et-obtenez-jusqua-130-de-bonus-avec-wiwsport");
    if (response.statusCode == 200) {
      articles = (json.decode(response.body) as List).map((data) {
        return Bet.fromJSON(data);
      }).toList();
    }
    setState(() {
      article = articles[0];
    });
  }

  @override
  void initState() {
    super.initState();
    getPage();
  }

  @override
  Widget build(BuildContext context) {
    String htmlContent = "<h2><b>Télécharger et installer sur iOS</b></h2>\n<p><span style=\"font-weight: 400;\">L’application iOS est une chose pratique. Vous pouvez être loin de chez vous &#8211; dans le train, dans la voiture, coincé dans les bouchons. Mais le </span><span style=\"font-weight: 400;\">portable est toujours sous la main.</span></p>\n<p><img loading=\"lazy\" class=\"aligncenter wp-image-101704 size-full\" title=\"1xbet ios\" src=\"https://wiwsport.com/v2/wp-content/uploads/2020/05/1xbet_ios.jpeg\" alt=\"1xbet ios\" width=\"338\" height=\"600\" srcset=\"https://wiwsport.com/v2/wp-content/uploads/2020/05/1xbet_ios.jpeg 338w, https://wiwsport.com/v2/wp-content/uploads/2020/05/1xbet_ios-169x300.jpeg 169w, https://wiwsport.com/v2/wp-content/uploads/2020/05/1xbet_ios-576x1024.jpeg 576w, https://wiwsport.com/v2/wp-content/uploads/2020/05/1xbet_ios-72x128.jpeg 72w, https://wiwsport.com/v2/wp-content/uploads/2020/05/1xbet_ios-18x32.jpeg 18w, https://wiwsport.com/v2/wp-content/uploads/2020/05/1xbet_ios-600x1067.jpeg 600w\" sizes=\"(max-width: 338px) 100vw, 338px\" /></p>\n<p><span style=\"font-weight: 400;\">Même si vous regardez un match chez vous, il est plus facile et plus rapide de miser via une application que de démarrer un ordinateur.</span></p>\n<h3><b>Instruction</b></h3>\n<p><span style=\"font-weight: 400;\">Pour le téléchargement et l’installation du logiciel:</span></p>\n<ol>\n<li style=\"font-weight: 400;\"><span style=\"font-weight: 400;\">Accédez aux “Réglages”;</span></li>\n<li style=\"font-weight: 400;\"><span style=\"font-weight: 400;\">Puis, à « iTunes et Apple Store »;</span></li>\n<li style=\"font-weight: 400;\"><span style=\"font-weight: 400;\">Faites un appui sur “Apple ID” et ouvrez l&rsquo;identifiant Apple;</span></li>\n<li style=\"font-weight: 400;\"><span style=\"font-weight: 400;\">Choisissez “Pays/Région” et après,  » Chypre »;</span></li>\n<li style=\"font-weight: 400;\"><span style=\"font-weight: 400;\">Indiquez les données requises;</span></li>\n<li style=\"font-weight: 400;\"><span style=\"font-weight: 400;\">Terminez la procédure;</span></li>\n<li style=\"font-weight: 400;\"><span style=\"font-weight: 400;\">Visitez Apple Store et recherchez le programme.</span></li>\n</ol>\n";
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          iconSize: 24,
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HomePage()));
          },
        ),
        actions: [
          Container(
            margin: const EdgeInsets.fromLTRB(3.0, 15.0, 9.0, 15.0),
            padding: const EdgeInsets.fromLTRB(3, 1, 3, 3),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFFabd9c2), width: 1),
              color: Color(0xFFabd9c2),
            ),
            child: InkWell(
              onTap: () async {
                const url = "https://www.xbet-app.com/wiwsport/1xbet.apk";
                if (await canLaunch(url))
                  await launch(url);
                else
                  throw "Could not launch $url";
              },
              child: Text(" télécharger ", style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
                fontFamily: "DINNextLTPro-MediumCond",
                color: Colors.black,
              )),
            ),
          ),
        ],
        //title: Text('1 selected'),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          return SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 15,
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 11),
                            child: Text(
                              parse(articles[index].title.toString())
                                  .documentElement
                                  .text,
                              style: TextStyle(
                                fontFamily: "DINNextLTPro-MediumCond",
                                fontWeight: FontWeight.bold,
                                fontSize: 35,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Image.asset("assets/images/bet.jpeg", height: 210, width: MediaQuery.of(context).size.width,),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                              padding: EdgeInsets.only(left: 11),
                              child: Column(
                                children: <Widget>[
                                  HtmlWidget (
                                    articles[index].content,
                                    textStyle: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: "DINNextLTPro-MediumCond",
                                      color: Colors.black,
                                    ),
                                    webView: true,
                                  ),
                                  SizedBox(height: 30,),
                                ],
                              )
                          ),
                                    ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 1500,
                            maxWidth: MediaQuery.of(context).size.width
                          ),
                          child: this.isload
                                  ? Center(
                                child: Image.asset('assets/gifs/green_style.gif', height: 15, width: 15,),
                              )
                                  : ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: 7,
                                itemBuilder: (context, index) {
                                  if(index == 0){
                                    return InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (BuildContext context) {
                                                  return DetailsPage(post:suggestions[0]);
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
                                                padding: EdgeInsets.only(right: 5, left: 5),
                                                child: FadeInImage.assetNetwork(
                                                  placeholder: 'assets/images/logo.png',
                                                  image: suggestions[0].image,
                                                ),
                                              ),
                                              SizedBox(height: 3),
                                              Padding(
                                                padding: EdgeInsets.only(left: 11),
                                                child: Text(parse(suggestions[0].title.toString()).documentElement.text,
                                                    style: TextStyle(
                                                        fontSize: 22,
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: "Roboto")),
                                              ),
                                              SizedBox(height: 3),
                                              Divider(),
                                            ],
                                          ),
                                        ),
                                    );
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
                                              child: Image.network(
                                                  suggestions[index].image,
                                                  fit: BoxFit.cover),
                                            ),
                                            title: new Text(
                                              parse(suggestions[index].title)
                                                  .documentElement.text,
                                              style: new TextStyle(fontSize: 17.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: new Column(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .start,
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .start,
                                                children: <Widget>[
                                                  new Text(
                                                      ' ${this.suggestions[index].date
                                                          .substring(
                                                          8, 10)} Dec. ${this
                                                          .suggestions[index].date
                                                          .substring(
                                                          0, 4)} à ${this
                                                          .suggestions[index].date
                                                          .substring(
                                                          11, 13)}h${this
                                                          .suggestions[index].date
                                                          .substring(14, 16)}',
                                                      style: new TextStyle(
                                                          fontSize: 11.0,
                                                          color: Colors.black54,
                                                          fontWeight: FontWeight
                                                              .normal)),
                                                ]),
                                            onTap: () {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (
                                                        BuildContext context) {
                                                      return DetailsPage(post:
                                                          suggestions[index]);
                                                    },
                                                    fullscreenDialog: true),
                                              );
                                            },
                                          ),
                                          SizedBox(height: 30,),
                                        ],
                                      );
                                    }
                                    else if(index == 5 ) {
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
                                              child: Image.network(
                                                  suggestions[index].image,
                                                  fit: BoxFit.cover),
                                            ),
                                            title: new Text(
                                              parse(suggestions[index].title)
                                                  .documentElement.text,
                                              style: new TextStyle(fontSize: 17.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: new Column(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .start,
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .start,
                                                children: <Widget>[
                                                  new Text(
                                                      ' ${this.suggestions[index].date
                                                          .substring(
                                                          8, 10)} Dec. ${this
                                                          .suggestions[index].date
                                                          .substring(
                                                          0, 4)} à ${this
                                                          .suggestions[index].date
                                                          .substring(
                                                          11, 13)}h${this
                                                          .suggestions[index].date
                                                          .substring(14, 16)}',
                                                      style: new TextStyle(
                                                          fontSize: 11.0,
                                                          color: Colors.black54,
                                                          fontWeight: FontWeight
                                                              .normal)),
                                                ]),
                                            onTap: () {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (
                                                        BuildContext context) {
                                                      return DetailsPage(post:suggestions[index]);
                                                    },
                                                    fullscreenDialog: true),
                                              );
                                            },
                                          ),
                                          SizedBox(height: 20,),
                                          InkWell(
                                            onTap: () {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (
                                                        BuildContext context) {
                                                      return BetPage();
                                                    },
                                                    fullscreenDialog: true),
                                              );
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
                                              child: Image.network(
                                                  suggestions[index].image,
                                                  fit: BoxFit.cover),
                                            ),
                                            title: new Text(
                                              parse(suggestions[index].title)
                                                  .documentElement.text,
                                              style: new TextStyle(fontSize: 17.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: new Column(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .start,
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .start,
                                                children: <Widget>[
                                                  new Text(
                                                      ' ${this.suggestions[index].date
                                                          .substring(
                                                          8, 10)} Dec. ${this
                                                          .suggestions[index].date
                                                          .substring(
                                                          0, 4)} à ${this
                                                          .suggestions[index].date
                                                          .substring(
                                                          11, 13)}h${this
                                                          .suggestions[index].date
                                                          .substring(14, 16)}',
                                                      style: new TextStyle(
                                                          fontSize: 11.0,
                                                          color: Colors.black54,
                                                          fontWeight: FontWeight
                                                              .normal)),
                                                ]),
                                            onTap: () {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (
                                                        BuildContext context) {
                                                      return DetailsPage(post:
                                                          suggestions[index]);
                                                    },
                                                    fullscreenDialog: true),
                                              );
                                            },
                                          ),
                                        ],
                                      );
                                    }
                                  }
                                },
                              )
                            ),
                          SizedBox(height: 30),
                        ],
                      ),

                  ]
              ));
        },
      ),
    );
  }
}

class Bet {
  final  id;
  final  title;
  final  content;
  bool isSaved = false;

  Bet({
    this.content,
    this.id,
    this.title,
  });

  factory Bet.fromJSON(Map<String, dynamic> json) {
    return Bet(
        id: json['id'],
        title: json['title']['rendered'],
        content: json['content']['rendered'],
     );
  }
}





