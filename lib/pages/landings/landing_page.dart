import 'dart:async';
import 'dart:io';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'package:wiwmedia_wiwsport_v3/model/post.dart';
import 'package:wiwmedia_wiwsport_v3/model/user.dart';
import 'package:wiwmedia_wiwsport_v3/screens/PostCard.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:convert';

class LandingPage extends StatefulWidget {
  final int tab_value;
  final bool isConnect;
  final String pp;
  final String email;
  final Utilisateur user;

  LandingPage({this.user, this.tab_value, this.isConnect, this.email, this.pp, Key key}) :super(key:key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with WidgetsBindingObserver {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  ScrollController _scrollController = new ScrollController();

  FirebaseAnalytics analytics;
  FirebaseAnalyticsObserver observer;

  Future<Null> _CurrentScreen(String suffix) async {
    await analytics.setCurrentScreen(screenName: suffix);
  }

  //SUFFIX
  String base_suffix = "";
  String suffix_foot ="&categories=63,65,1514,71,67,66,1648,1649,9548,9244,6897,57778,57777,35409,22736,57714,22747,22748";
  String suffix_basket ="&categories=75,32401,32402,1520,7987,6563,83,82,58110";
  String suffix_lamb ="&categories=72";
  String suffix_athletisme ="&categories=84";
  String suffix_rallye ="&categories=85";
  String suffix_combat ="&categories=92,22737,22738,22739,22740,17423,6564,22741";
  String suffix_tennis = "&categories=89";
  String suffix_handball = "&categories=86";
  String suffix_volleyball = "&categories=90";
  String suffix_rugby = "&categories=88";
  String suffix_automoto = "&categories=85";
  String suffix_cyclisme = "&categories=8008";
  String suffix_natation = "&categories=87";
  String suffix_roller = "&categories=57539";
  String suffix_golf = "&categories=57537";
  String suffix_olympism = "&categories=57617,32403,10218,36407";
  String suffix_esport = "&categories=9135";
  String suffix_autre = "&categories=91,42353,43346";

  String suffix;
  String suffix_name;
  setSuffix() {
    if (widget.tab_value == 0) {
      suffix = this.base_suffix;
      setState(() {
        suffix_name = "acceuil";
      });
    } else if (widget.tab_value == 1) {
      suffix = this.suffix_foot;
      setState(() {
        suffix_name = "football";
      });
    } else if (widget.tab_value == 2) {
      suffix = this.suffix_basket;
      setState(() {
        suffix_name = "basketball";
      });
    } else if (widget.tab_value == 3) {
      suffix = this.suffix_lamb;
      setState(() {
        suffix_name = "lamb";
      });
    } else if (widget.tab_value == 4) {
      suffix = this.suffix_combat;
      setState(() {
        suffix_name = "combat";
      });
    } else if (widget.tab_value == 5) {
      suffix = this.suffix_athletisme;
      setState(() {
        suffix_name = "athletisme";
      });
    } else if (widget.tab_value == 6) {
      suffix = this.suffix_tennis;
      setState(() {
        suffix_name = "tenis";
      });
    } else if (widget.tab_value == 7) {
      suffix = this.suffix_handball;
      setState(() {
        suffix_name = "handball";
      });
    } else if (widget.tab_value == 8) {
      suffix = this.suffix_volleyball;
      setState(() {
        suffix_name = "volleyball";
      });
    } else if (widget.tab_value == 9) {
      suffix = this.suffix_rugby;
      setState(() {
        suffix_name = "rugby";
      });
    } else if (widget.tab_value == 10) {
      suffix = this.suffix_automoto;
      setState(() {
        suffix_name = "auto-moto";
      });
    } else if (widget.tab_value == 11) {
      suffix = this.suffix_cyclisme;
      setState(() {
        suffix_name = "cyclisme";
      });
    } else if (widget.tab_value == 12) {
      suffix = this.suffix_natation;
      setState(() {
        suffix_name = "natation";
      });
    } else if (widget.tab_value == 13) {
      suffix = this.suffix_roller;
      setState(() {
        suffix_name = "roller";
      });
    } else if (widget.tab_value == 14) {
      suffix = this.suffix_golf;
      setState(() {
        suffix_name = "golf";
      });
    } else if (widget.tab_value == 15) {
      suffix = this.suffix_olympism;
      setState(() {
        suffix_name = "olympisme";
      });
    } else if (widget.tab_value == 16) {
      suffix = this.suffix_esport;
      setState(() {
        suffix_name = "esport";
      });
    } else if (widget.tab_value == 17) {
      suffix = this.suffix_autre;
      setState(() {
        suffix_name = "autre";
      });
    }
  }

  //ChHECK CONNECTION
  bool isConnexion = true;
  void _checkConection() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        _setConnexion();
        _fetchPosts(suffix);
      } else {
        _setOffline();
      }
    });
  }

  void _setConnexion() {
    _fetchPosts(suffix);
    setState(() {
      isConnexion = true;
    });
  }

  void _setOffline() {
    setState(() {
      isConnexion = false;
    });
  }

  //CHARGEMENT D'ARTICLE
  int page = 1;
  bool isLoading = false;
  List<Post> articles = List();
  List<Post> posts = List();
  Future<void> _fetchPosts(suffix) async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(
        "https://wiwsport.com/wp-json/wp/v2/posts?per_page=16&_fields=id,title,slug,content,date,categories,link,_links.wp:featuredmedia,_links.wp:term&_embed$suffix");
    if (response.statusCode == 200) {
      posts = (json.decode(response.body) as List).map((data) {
        return Post.fromJSON(data);
      }).toList();
      setState(() {
        articles = posts;
        isLoading = false;
      });
    }
  }

  //RECHARGEMENT D'ARTICLE
  bool isReload = false;
  Future fetchMore(suffix) async {
    setState(() {
      //isReload = true;
      this.page = page + 1;
    });

    ///wp/v2/posts?_fields[]=author&_fields[]=id&_fields[]=excerpt&_fields[]=title&_fields[]=link

    final response = await http.get(
        "https://wiwsport.com/wp-json/wp/v2/posts?per_page=11&page=$page&_embed$suffix&_fields=id,title,content,date,categories,link,_links.wp:featuredmedia,_links.wp:term");
    if (response.statusCode == 200) {
      articles = articles +
          (json.decode(response.body) as List).map((data) {
            return Post.fromJSON(data);
          }).toList();
      setState(() {
        isReload = false;
      });
    }
  }

  Timer timer;
  @override
  void initState() {
    _checkConection();

    setSuffix();
    _fetchPosts(suffix);

    WidgetsBinding.instance.addObserver(this);
    super.initState();
    //FirebaseAdMob.instance.initialize(appId:"ca-app-pub-9120523919163473~3676757066");

    // _CurrentScreen(suffix_name);

    
    timer = Timer.periodic(Duration(seconds: 3), (Timer t) => fetchMore(suffix));

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          (_scrollController.position.maxScrollExtent)) {
        //if(_scrollController.){
        setState(() {
          this.isReload = true;
        });
        fetchMore(suffix);
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    _scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('--------------------------------------------------------------------->state = $state');
    setSuffix();
    _fetchPosts(suffix);
  }

  Future<Null> _refresh() async {
    articles = new List();
    await Future.delayed(Duration(seconds: 1));
    return _fetchPosts(suffix);
  }

  static const _adUnitID = "ca-app-pub-9120523919163473/1283696274";

  @override
  Widget build(BuildContext context) {
    bool isNative = false;
    if (isConnexion != null) {
      return Scaffold(
        body: Container(
          child: isConnexion
              ? RefreshIndicator(
                  key: _refreshIndicatorKey,
                  onRefresh: _refresh,
                  child: this.isLoading
                      ? Center(
                          child: Image.asset(
                            'assets/gifs/green_style.gif',
                            height: 25,
                            width: 25,
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: articles.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            if (index != 0 && index % 3 == 0) {
                              return Column(
                                children: <Widget>[
                                  PostCard(
                                    post: articles[index],
                                    isConnect: widget.isConnect,
                                    user: widget.user,
                                  ),
                                  Divider(
                                    color: Colors.black,
                                    indent: 7,
                                    endIndent: 7,
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    child: AdmobBanner(
                                      adUnitId:
                                          'ca-app-pub-9120523919163473/3209669731',
                                      adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                                    ),
                                  ),
                                ],
                              );
                            } else if (index == articles.length - 1) {
                              return Column(
                                children: <Widget>[
                                  PostCard(
                                    post: articles[index],
                                    isConnect: widget.isConnect,
                                    user: widget.user,
                                  ),
                                  Divider(
                                    color: Colors.black,
                                    indent: 7,
                                    endIndent: 7,
                                  ),
                                  Center(
                                    child: CircularProgressIndicator(),
                                  )
                                ],
                              );
                            } else {
                              return Column(
                                children: <Widget>[
                                  PostCard(
                                    post: articles[index],
                                    isConnect: widget.isConnect,
                                    user: widget.user,
                                  ),
                                  Divider(
                                    color: Colors.black,
                                    indent: 7,
                                    endIndent: 7,
                                  )
                                ],
                              );
                            }
                          }),
                )
              : Center(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        child: Image.asset("assets/bug_img.jpeg"),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(11),
                        child: Padding(
                          padding: EdgeInsets.only(left: 27),
                          child: Text(
                            'Impossible de charger les actualités ! Veuillez vous connecter à internet.',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: null,
                              fontFamily: "DINNextLTPro-MediumCond",
                              color: Colors.black45,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      );
    } else {
      return RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: this.isLoading
            ? Center(
                child: Image.asset(
                  'assets/gifs/green_style.gif',
                  height: 25,
                  width: 25,
                ),
              )
            : ListView.builder(
                controller: _scrollController,
                itemCount: articles.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  if (index != 0 && index % 3 == 0) {
                    return Column(
                      children: <Widget>[
                        PostCard(
                          post: articles[index],
                          isConnect: widget.isConnect,
                          user: widget.user,
                        ),
                        Divider(
                          color: Colors.black,
                          indent: 7,
                          endIndent: 7,
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          child: AdmobBanner(
                            adUnitId: 'ca-app-pub-9120523919163473/2499635678',
                            adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                          ),
                        ),
                      ],
                    );
                  } else if (index == articles.length - 1) {
                    return Column(
                      children: <Widget>[
                        PostCard(
                          post: articles[index],
                          isConnect: widget.isConnect,
                          user: widget.user,
                        ),
                        Divider(
                          color: Colors.black,
                          indent: 7,
                          endIndent: 7,
                        ),
                        Center(
                          child: Image.asset(
                            'assets/gifs/green_style.gif',
                            height: 25,
                            width: 25,
                          ),
                        )
                      ],
                    );
                  } else {
                    return Column(
                      children: <Widget>[
                        PostCard(
                          post: articles[index],
                          isConnect: widget.isConnect,
                          user: widget.user,
                        ),
                        Divider(
                          color: Colors.black,
                          indent: 7,
                          endIndent: 7,
                        )
                      ],
                    );
                  }
                }),
      );
    }
  }
}
