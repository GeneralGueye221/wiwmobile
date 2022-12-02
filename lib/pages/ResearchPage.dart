import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wiwmedia_wiwsport_v3/model/post.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart';
import 'package:wiwmedia_wiwsport_v3/screens/details_page.dart';
import 'package:intl/intl.dart';
import 'package:wiwmedia_wiwsport_v3/model/post.dart';
import 'package:wiwmedia_wiwsport_v3/screens/menu/page_newsletter.dart';

import 'ExplorerPage.dart';
import 'HomePage.dart';

class ResearchPage extends StatefulWidget {
  @override
  _ResearchPageState createState() => _ResearchPageState();
}

class _ResearchPageState extends State<ResearchPage> {
  ///wp/v2/posts?_fields[]=id&_fields[]=title&_fields[]=datet&_fields[]=_embedded&_fields[]=content&_fields[]=categories&_fields[]=link&

  ScrollController _scrollController =new ScrollController();

  String url = "https://wiwsport.com/wp-json/wp/v2/posts?_embed&_fields[]=id&_fields[]=title&_fields[]=date&_fields[]=content&_fields[]=categories&_fields[]=link&_fields[]=_embedded";
  String searching = " ";
  List<Post> posts = List();
  List<Post> postList = List();
  List<String> tempList = List<String>();
  bool isLoading = false;

  var _search = new TextEditingController();
  bool firts_search = true;
  String _query = "";
  List<Post> _filterList;

  //CHARGEMENT D'ARTICLE DEPUIS LE SLUG
  List<Post> article = List();
  Future<void> _fetchDataFromSlug(slug) async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get("https://wiwsport.com/wp-json/wp/v2/posts?&slug=$slug");
    if (response.statusCode == 200) {
      article = (json.decode(response.body) as List).map((data) {
        return Post.fromJSON(data);
      }).toList();
      setState(() {
        isLoading = false;
      });
    }
  }

  //ANALYTICS EVENT
  FirebaseAnalytics analytics;
  void onResearch() {
    analytics.logEvent(
      name: 'user_search',
    );
  }

  @override
  void initState() {
    super.initState();
    fetchPost("");
    //onResearch();
  }

  generateDate(int jour, int mois, int annee, int hh, int mm ) {
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
      _dateTime = "le ${jour} Aoout. ${annee} à ${hh}h${mm}";
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

  getDate(articles) {
    DateTime dateTime = DateTime.parse(articles);
    DateTime now = new DateTime.now();

    if(dateTime.day == now.day){
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

  setImage(context,item,index){
    if(item[index].image == null){
      return  Image.asset("assets/bug_img.jpeg");

    } else {
      return Image.network(
          item[index].image,
          fit: BoxFit.cover);
    }
  }

  String removeDiacritics(String str) {
    var withDia = 'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    var withoutDia = 'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

    for (int i = 0; i < withDia.length; i++) {
      str = str.replaceAll(withDia[i], withoutDia[i]);
    }

    return str;
  }

  _ResearchPageState(){
    _search.addListener(() {
      if(_search.text.isEmpty){
        setState(() {
          firts_search = true;
          _query = '';
        });
      } else {
        setState(() {
          firts_search = false;
          _query = _search.text;
          Future.delayed(Duration(seconds: 1), () {
            fetchPost(removeDiacritics(_query).toLowerCase());
          });
        });
      }
    });
  }

  int _selectedIndex=3;
  PageController _pageController = PageController(initialPage: 1);
  void _onSwitchPage(int selectedIndex) {
    if(selectedIndex==0) {
      setState(() {
        _selectedIndex =selectedIndex;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) {
                return HomePage();
              }
          )
      );
    }
    if(selectedIndex==1) {
      setState(() {
        _selectedIndex =selectedIndex;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) {
                return ExplorerPage();
              }
          )
      );
    }
    if(selectedIndex==2) {
      setState(() {
        _selectedIndex =selectedIndex;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) {
                return ResearchPage();
              }
          )
      );
    }
    if(selectedIndex==3) {
      setState(() {
        _selectedIndex =selectedIndex;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) {
                return NewsLetterPage();
              }
          )
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Container(
        margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        padding: EdgeInsets.only(top:20),
        child: new Column(
          children: <Widget>[
            _createSearchView(),
            firts_search ? _createListView() : _createFilteredListView()
          ],
        ),
      ),

    );
  }

  String target = "";
  List<Post> articles = List();
  int page = 1;

  fetchPost(String indice) async {
    tempList = List<String>();
    setState(() {
      isLoading = true;
    });
    if(indice.length>0){
      final response =
      await http.get("https://wiwsport.com/wp-json/wp/v2/posts?per_page=10&_embed&search=$indice&_fields=title,content,date,categories,link,_links.wp:featuredmedia,_links.wp:term");
      if (response.statusCode == 200) {
        posts = (json.decode(response.body) as List).map((data) {
          return Post.fromJSON(data);
        }).toList();
      } else {
        throw Exception("Failed to load Posts.");
      }
      setState(() {
        isLoading = false;
        articles = posts;
        this.target = indice;
      });
    }
    else{
      final response =
      await http.get("https://wiwsport.com/wp-json/wp/v2/posts?per_page=5&_embed");
      if (response.statusCode == 200) {
        posts = (json.decode(response.body) as List).map((data) {
          return Post.fromJSON(data);
        }).toList();
      } else {
        throw Exception("Failed to load Posts.");
      }
      setState(() {
        isLoading = false;
        postList = posts;
      });
    }
  }

  bool isReload = false;
  Future fetchMore(String target) async {
    setState(() {
      isReload = true;
      this.page = page+1;
    });
    ///wp/v2/posts?_fields[]=author&_fields[]=id&_fields[]=excerpt&_fields[]=title&_fields[]=link

    final response = await http.get("https://wiwsport.com/wp-json/wp/v2/posts?per_page=10&page=$page&_embed&search=$target");
    if (response.statusCode == 200) {
      articles = articles + (json.decode(response.body) as List).map((data) {
        return Post.fromJSON(data);
      }).toList();
      setState(() {
        isReload = false;
      });
    }
  }



  Widget _createSearchView () {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height:75),
        Container(
          decoration: BoxDecoration(border: Border.all(width:0.0), color: Colors.grey[200]),
          width: 250,
          height: 40,
          child: new TextField(
            autofocus: true,
            controller: _search,
            cursorColor: Colors.green[300],
            decoration: InputDecoration(
              hintText: "Rechercher ...",
              hoverColor: Colors.grey,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black54),
              ),
              border: new UnderlineInputBorder(
                  borderSide: new BorderSide(
                      color: Colors.grey
                  )
              ),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.black45,
              ),
              suffixIcon: IconButton(
                onPressed: () => _search.clear(),
                icon: Icon(Icons.clear),
                color: Colors.black,
              ),
            ),
            textAlign: TextAlign.left,
          ),
        ),
        SizedBox(width: 7,),
        InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) { return HomePage();})),
          child: Text(" Annuler ", style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.normal,
            fontFamily: "DINNextLTPro-MediumCond",
            color: Colors.black87,
          )),
        ),
      ],
    );

  }

  Widget _createListView(){
    return new Flexible(
      child: isLoading
          ? Text("Veuillez patienter...")
          :ListView.builder(
        itemCount: posts.length,
        itemBuilder: (BuildContext context, int index){
          DateTime dateTime = DateTime.parse(posts[index].date);
          String dateformat = DateFormat( "le dd.MM.yyyy à HH:mm").format(dateTime);

          return  new Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new ListTile(
                    leading: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: 100,
                        minHeight: 120,
                        maxWidth: 100,
                        maxHeight: 164,
                      ),
                      child: setImage(context, posts, index),
                    ),

                    title: new Text(
                      parse(posts[index].title).documentElement.text,
                      style: new TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                    ),
                    subtitle: new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          getDate(posts[index].date),
                        ]),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            settings: RouteSettings(name: ''),
                            builder: (BuildContext context) {
                              return DetailsPage(post:posts[index]);
                            },
                            fullscreenDialog: true),
                      );
                    },
                  )
                ],
              )
          );

        },
      ),
    );
  }

  Widget _createFilteredListView() {
    return new Flexible(
        child: isLoading
            ? CircularProgressIndicator()
            : ListView.builder(
          itemCount: articles.length,
          itemBuilder: (BuildContext context, int index){
            DateTime dateTime = DateTime.parse(articles[index].date);
            String dateformat = DateFormat( "le dd.MM.yyyy à HH:mm").format(dateTime);
            if (index == articles.length-1){
              if(isReload == true){
                return new Container(
                    child: Column(
                      children: <Widget>[
                        new ListTile(
                          leading: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: 100,
                              minHeight: 120,
                              maxWidth: 100,
                              maxHeight: 164,
                            ),
                            child: setImage(context, articles, index),
                          ),

                          title: new Text(
                            parse(articles[index].title).documentElement.text,
                            style: new TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                          ),
                          subtitle: new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                getDate(articles[index].date),
                              ]),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  settings: RouteSettings(name: ''),
                                  builder: (BuildContext context) {
                                    return DetailsPage(post:articles[index]);
                                  },
                                  fullscreenDialog: true),
                            );
                          },
                        ),
                        Center(
                          child: Text("chargement en cours...", style: TextStyle(fontSize: 15,color:Colors.teal,fontFamily:"DINNextLTPro-MediumCond", fontWeight: FontWeight.bold, )),
                        ),
                      ],
                    )
                );
              }
              else {
                return new Container(
                    child: Column(
                      children: <Widget>[
                        new ListTile(
                          leading: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: 100,
                              minHeight: 120,
                              maxWidth: 100,
                              maxHeight: 164,
                            ),
                            child: setImage(context, articles, index),
                          ),

                          title: new Text(
                            parse(articles[index].title).documentElement.text,
                            style: new TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                          ),
                          subtitle: new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                getDate(articles[index].date),
                              ]),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  settings: RouteSettings(name: ''),
                                  builder: (BuildContext context) {
                                    return DetailsPage(post:articles[index]);
                                  },
                                  fullscreenDialog: true),
                            );
                          },
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(top: 20.0),
                            child: new Material(
                              color: Colors.teal,
                              elevation: 3.0,
                              child: new MaterialButton(
                                height: 50.0,
                                child: new Text(
                                  'Plus de résultats',
                                  style: new TextStyle(
                                      color: Colors.white
                                  ),
                                ),
                                onPressed: () => fetchMore(this.target),
                                color: Colors.teal,
                              ),
                            )
                        ),
                      ],
                    )
                );
              }

            } else {
              return new Container(
                  child: Column(
                    children: <Widget>[
                      new ListTile(
                        leading: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: 100,
                            minHeight: 120,
                            maxWidth: 100,
                            maxHeight: 164,
                          ),
                          child: setImage(context, articles, index),
                        ),

                        title: new Text(
                          parse(articles[index].title).documentElement.text,
                          style: new TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                        ),
                        subtitle: new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              getDate(articles[index].date),
                            ]),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                settings: RouteSettings(name: ''),
                                builder: (BuildContext context) {
                                  return DetailsPage(post:articles[index]);
                                },
                                fullscreenDialog: true),
                          );
                        },
                      ),
                    ],
                  )
              );

            }

          },
        )
    );
  }

}
