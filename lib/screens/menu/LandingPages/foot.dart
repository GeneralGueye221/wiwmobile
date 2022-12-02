//import 'package:admob_flutter/admob_flutter.dart';
import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:wiwmedia_wiwsport_v3/model/post.dart';
import 'package:wiwmedia_wiwsport_v3/model/user.dart';
import 'package:wiwmedia_wiwsport_v3/pages/HomePage.dart';
import 'package:wiwmedia_wiwsport_v3/screens/PostCard.dart';
import 'dart:convert';


class LandingFoot extends StatefulWidget {
  final int tab_value;
  final Utilisateur user;
  final Utilisateur isUser;

  LandingFoot({this.tab_value, this.user, this.isUser});

  @override
  _LandingFootState createState() => _LandingFootState();
}

class _LandingFootState extends State<LandingFoot> {
  String url = "https://wiwsport.com/wp-json/wp/v2/posts?per_page=20&_embed";

  bool isLoading = false;
  List<Post> posts = List();

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  ScrollController _scrollController = new ScrollController();

  double mark = 6000;
  @override
  void initState() {
    _fetchPosts(widget.tab_value);
    super.initState();
    //FirebaseAdMob.instance.initialize(appId:"ca-app-pub-9120523919163473~3676757066");
    _scrollController.addListener(() {
      if(_scrollController.position.pixels >= mark)
      {

        setState(() {
          this.isReload = true;
        });
        fetchMore(widget.tab_value);
        mark = _scrollController.position.maxScrollExtent +6000;
      }}
    );
  }
 
  goToHome() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) {
            return HomePage();
          },
          fullscreenDialog: true),
    );
  }

  int page = 1;
  List<Post> articles = List();

  // CHARGEMENT ARTICLES
  Future<void> _fetchPosts(suffix) async {
    setState(() {
      isLoading = true;
    });
    if (widget.tab_value == 0) {
      return WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(
                user: widget.user,
                isUser: !(widget.user==null),
              ),
            ));
      });
    } else if (widget.tab_value == 1) {
      return WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(
                user: widget.user,
                isUser: !(widget.user==null),
                index: 1,
              ),
            ));
      });
    } else if (widget.tab_value == 2) {
      suffix = "&categories=65,9244,6897,35409,22736";
    } else if (widget.tab_value == 3) {
      suffix = "&categories=1514,22748,22747,71,67";
    } else if (widget.tab_value == 4) {
      suffix = "&categories=71";
    } else if (widget.tab_value == 5) {
      suffix = "&categories=67";
    } else if (widget.tab_value == 6) {
      suffix = "&categories=66,57778,57777";
    } else if (widget.tab_value == 7) {
      suffix = "&categories=1648";
    } else if (widget.tab_value == 8) {
      suffix = "&categories=57714";
    } else if (widget.tab_value == 9) {
      suffix = "&categories=1649";
    } else if (widget.tab_value == 10) {
      suffix = "&categories=9548";
    }
    final response = await http.get(this.url + suffix);
    if (response.statusCode == 200) {
      posts = (json.decode(response.body) as List).map((data) {
        return Post.fromJSON(data);
      }).toList();
      for (int i = 0; i < posts.length; i++) {
        articles.add(posts[i]);
      }
      setState(() {
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
    if (widget.tab_value == 0) {
      return WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ));
      });
    } else if (widget.tab_value == 1) {
      return WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(
                isUser: !(widget.user==null),
                user: widget.user,
                index: 1,
              ),
            ));
      });
    } else if (widget.tab_value == 2) {
      suffix = "&categories=65,9244,6897,35409,22736";
    } else if (widget.tab_value == 3) {
      suffix = "&categories=1514,22748,22747,71,67";
    } else if (widget.tab_value == 4) {
      suffix = "&categories=71";
    } else if (widget.tab_value == 5) {
      suffix = "&categories=67";
    } else if (widget.tab_value == 6) {
      suffix = "&categories=66,57778,57777";
    } else if (widget.tab_value == 7) {
      suffix = "&categories=1648";
    } else if (widget.tab_value == 8) {
      suffix = "&categories=57714";
    } else if (widget.tab_value == 9) {
      suffix = "&categories=1649";
    } else if (widget.tab_value == 10) {
      suffix = "&categories=9548";
    }
    final response = await http.get(
        "https://wiwsport.com/wp-json/wp/v2/posts?per_page=20&page=$page&_embed$suffix&_fields=title,content,date,categories,link,_links.wp:featuredmedia,_links.wp:term");
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

  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 3));
    return _fetchPosts(widget.tab_value);
  }

  bool isNative = false;
  static const _adUnitID = "ca-app-pub-9120523919163473/1283696274";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: RefreshIndicator(
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
                    isNative = true;
                    return Column(
                      children: <Widget>[
                        PostCard(post: articles[index]),
                        Divider(
                          color: Colors.black,
                          height: 26,
                          indent: 7,
                          endIndent: 7,
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          child: AdmobBanner(
                            adUnitId: 'ca-app-pub-9120523919163473/3209669731',
                            adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                          ),
                        ),
                      ],
                    );
                  } else if (index == articles.length - 1) {
                    return Column(
                      children: <Widget>[
                        PostCard(post: articles[index]),
                        Divider(
                          color: Colors.black,
                          height: 26,
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
                        PostCard(post: articles[index]),
                        Divider(
                          color: Colors.black,
                          height: 26,
                          indent: 7,
                          endIndent: 7,
                        )
                      ],
                    );
                  }
                }),
      )),
    );
  }
}
