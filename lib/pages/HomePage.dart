import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:ads/ads.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:wiwmedia_wiwsport_v3/model/categories.dart';
import 'package:wiwmedia_wiwsport_v3/model/post.dart';
import 'package:wiwmedia_wiwsport_v3/model/user.dart';
import 'package:wiwmedia_wiwsport_v3/pages/ExplorerNews.dart';

import 'package:wiwmedia_wiwsport_v3/reusable/CustomSearchDelegate.dart';

import 'package:wiwmedia_wiwsport_v3/screens/PostCard.dart';
import 'package:wiwmedia_wiwsport_v3/screens/menu/page_newsletter.dart';
import 'package:wiwmedia_wiwsport_v3/screens/notification_page.dart';

import '../MyDrawer.dart';
import 'KiosquePage.dart';

import 'ForumPage.dart';


class HomePage extends StatefulWidget {
  HomePage(
      {Key key,
        this.user,
        this.title,
        this.analytics,
        this.observer,
        this.launched,
        this.goto,
        this.index,
        this.isUser})
      : super(key: key);

  final String title;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  final String goto;
  final int index;
  bool isUser;
  Utilisateur user;

  bool launched;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>  {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<_LandingPageState> landing_key = GlobalKey<_LandingPageState>();
  SharedPreferences preferences;

  //DFPInterstitialAd _interstitialAd;
  bool isNotification = false;
  String uri;
  List<Post> notifications = List();

  int currentIndex = 0;
  int tab_value = 0;
  var _search = new TextEditingController();
  bool isSearching = false;
  bool isExpanded = false;
  bool isWebsite = false;

  String url = "";
  double progress = 0;

  _HomeState() {  
    _search.addListener(() {
      if (_search.text.isEmpty) {
        setState(() {
          isSearching = false;
        });
      } else {
        setState(() {
          isSearching = true;
          lunchResearch();
        });
      }
    });
  }

  lunchResearch() {
    return Navigator.push(context,
        MaterialPageRoute(builder: (context) => CustomSearchDelegate()));
  }

  Future<void> _initOneSignal() async {
    await OneSignal.shared.init('d09d7444-d427-4340-a940-86f500566f9d');
    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);

    OneSignal.shared.setNotificationReceivedHandler((notification) {});
    OneSignal.shared.setNotificationOpenedHandler((result) {
      this.setState(() {
        uri = result.notification.payload.launchUrl;
        isNotification = true;
        print(
            ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>GO TO SLUG: " +
                uri.substring(6));
        String x = uri.toString().substring(5);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return NotificationPage(
            link: x,
            user: widget.user,
            fromRoom: false,
          );
        }));
      });
    });
  }

  int _initIndex;

  

  Mixpanel mixpanel;
  Future<void> initMixpanel() async {
    mixpanel = await Mixpanel.init("7fab86957be3eda6d231f8bcdcc0defb",
        optOutTrackingDefault: false);
  }

  Future<void> initializePreference() async {
    this.preferences = await SharedPreferences.getInstance();
    await retrieveUser();
  }

  Future<void> StoreUser() async {
    Utilisateur _user = Utilisateur(
        id: widget.user.id,
        email: widget.user.email,
        pp: widget.user.pp,
        pseudo: widget.user.pseudo);
    String _store = jsonEncode(_user.toJson());

    await this.preferences.setString('user', _store);
  }

  Future retrieveUser() async {
    String _resultStore = this.preferences.getString("user");
    Map<String, dynamic> decoded = jsonDecode(_resultStore);
    if (_resultStore.isEmpty || Utilisateur.fromJSON(decoded).id == null) {
      if (widget.isUser) return StoreUser();
    } else {
      setState(() {
        widget.user = Utilisateur(
            id: Utilisateur.fromJSON(decoded).id,
            email: Utilisateur.fromJSON(decoded).email,
            pp: Utilisateur.fromJSON(decoded).pp,
            pseudo: Utilisateur.fromJSON(decoded).pseudo,
            numberphone: Utilisateur.fromJSON(decoded).numberphone);
        widget.isUser = true;
        print(
            "USER STORED & RETRIEVED SUCESSFULLY -> id:${widget.user.id} pseudo:${widget.user.pseudo} isConnected:${widget.isUser}");
      });
    }
  }



  @override
  void initState() {
    initializePreference().whenComplete(() {
      setState(() {});
      if (widget.user != null) {
        print(
            "USER INFO HOME from store | username:${widget.user.pseudo}, email:${widget.user.email}, pp:${widget.user.pp}");
      }
    });
    if (widget.index == null) {
      _initIndex = 0;
    }
    else {
      _initIndex = widget.index;
    }

    if (widget.isUser == null) {
      widget.isUser = false;
    }


    super.initState();


    _scaffoldKey = GlobalKey<ScaffoldState>();
    initMixpanel();
    _initOneSignal();
    //FirebaseAdMob.instance.initialize(appId:"ca-app-pub-9120523919163473~3676757066");
    Ads ads = Ads("ca-app-pub-9120523919163473~3676757066");
    ads.setFullScreenAd(
            adUnitId: 'ca-app-pub-3940256099942544/1033173712',
            childDirected: false,
            listener: (MobileAdEvent event) {
              if (event == MobileAdEvent.opened) {
                print("An ad has opened up.");
              }
              if (event == MobileAdEvent.failedToLoad) {
                print("=========================> INTERTICIAL FAILED TO LOAD");
              }
            });
    if(widget.launched == true){
      
      widget.launched = false;
    }
    if (widget.goto != null) return print("GO TOOOO ======> ${widget.goto}");
    FirebaseAnalytics().setCurrentScreen(screenName: 'Acceuil');
  }

  int _selectedIndex = 0;
  void _onSwitchPage(int selectedIndex) {
    if (selectedIndex == 0) {
      setState(() {
        _selectedIndex = selectedIndex;
      });
      Navigator.pop(context);
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          child: HomePage(
            isUser: widget.isUser,
            user: widget.user,
          ),
        ),
      );
    }
    if (selectedIndex == 1) {
      setState(() {
        _selectedIndex = selectedIndex;
      });
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          child: ExplorerNews(
            isUser: widget.isUser,
            user: widget.user,
          ),
        ),
      );
    }
    if (selectedIndex == 2) {
      setState(() {
        _selectedIndex = selectedIndex;
      });
      Navigator.pop(context);
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          child: Salon(
            isUser: widget.isUser,
            user: widget.user,
          ),
        ),
      );
    }
    if (selectedIndex == 3) {
      setState(() {
        _selectedIndex = selectedIndex;
      });
      Navigator.pop(context);
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          child: kioske(
            isUser: widget.isUser,
            user: widget.user,
          ),
        ),
      );
    }
    if (selectedIndex == 4) {
      setState(() {
        _selectedIndex = selectedIndex;
      });
      Navigator.pop(context);
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          child: NewsLetterPage(
            isUser: widget.isUser,
            user: widget.user,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: categories.length,
      initialIndex: _initIndex,
      child: Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Center(
              child: Image.asset('assets/images/logo_wiwsport.png',
                  height: 300, width: 120),
            ),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Builder(
                  builder: (context) => IconButton(
                    icon: SvgPicture.asset(
                      "assets/icons/search.svg",
                      height: 17,
                      width: 35,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CustomSearchDelegate()));
                    },
                  ),
                ),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: new Size(35, 35),
              child: TabBar(
                labelPadding:
                EdgeInsets.only(left: 5, right: 15, top: 0.0, bottom: 7),
                indicatorSize: TabBarIndicatorSize.label,
                isScrollable: true,
                indicator: UnderlineTabIndicator(),
                labelColor: Colors.black,
                labelStyle: TextStyle(
                    fontFamily: "DINNextLTPro-MediumCond",
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
                unselectedLabelColor: Colors.black45,
                unselectedLabelStyle: TextStyle(
                    fontFamily: "DINNextLTPro-MediumCond",
                    fontSize: 15,
                    fontWeight: FontWeight.normal),
                tabs: List.generate(
                    categories.length,
                        (index) => Text(
                      categories[index].nom,
                    )),
                onTap: (int) {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage(user: widget.user, isUser: widget.isUser, index: int)));
                },
              ),
            ),
            backgroundColor:
            currentIndex == 3 ? Color(0xffF7F8FA) : Colors.white,
            elevation: 8,
            centerTitle: false,
            titleSpacing: 0,
            iconTheme: IconThemeData(color: Colors.black54),
          ),
          drawer: widget.isUser != null
              ? TheDrawer(
            isConnect: widget.isUser,
            user: widget.user,
          )
              : TheDrawer(isConnect: false),
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              TabBarView(
                children: [
                  LandingPage(
                      user: widget.user,
                      isConnect: widget.isUser,
                      tab_value: 0),
                  LandingPage(
                      user: widget.user,
                      isConnect: widget.isUser,
                      tab_value: 1),
                  LandingPage(
                      user: widget.user,
                      isConnect: widget.isUser,
                      tab_value: 2),
                  LandingPage(
                      user: widget.user,
                      isConnect: widget.isUser,
                      tab_value: 3),
                  LandingPage(
                      user: widget.user,
                      isConnect: widget.isUser,
                      tab_value: 4),
                  LandingPage(
                      user: widget.user,
                      isConnect: widget.isUser,
                      tab_value: 5),
                  LandingPage(
                      user: widget.user,
                      isConnect: widget.isUser,
                      tab_value: 6),
                  LandingPage(
                      user: widget.user,
                      isConnect: widget.isUser,
                      tab_value: 7),
                  LandingPage(
                      user: widget.user,
                      isConnect: widget.isUser,
                      tab_value: 8),
                  LandingPage(
                      user: widget.user,
                      isConnect: widget.isUser,
                      tab_value: 9),
                  LandingPage(
                      user: widget.user,
                      isConnect: widget.isUser,
                      tab_value: 10),
                  LandingPage(
                      user: widget.user,
                      isConnect: widget.isUser,
                      tab_value: 11),
                  LandingPage(
                      user: widget.user,
                      isConnect: widget.isUser,
                      tab_value: 12),
                  LandingPage(
                      user: widget.user,
                      isConnect: widget.isUser,
                      tab_value: 13),
                  LandingPage(
                      user: widget.user,
                      isConnect: widget.isUser,
                      tab_value: 14),
                  LandingPage(
                      user: widget.user,
                      isConnect: widget.isUser,
                      tab_value: 15),
                  LandingPage(
                      user: widget.user,
                      isConnect: widget.isUser,
                      tab_value: 16),
                  LandingPage(
                      user: widget.user,
                      isConnect: widget.isUser,
                      tab_value: 17),
                ],
              ),
              Container(),
            ],
          ),
          bottomNavigationBar: SizedBox(
            height: 127,
            child: Column(
            children: [
              Container(
                color: Colors.transparent,
                padding: EdgeInsets.all(5),
                child: AdmobBanner(
                  adUnitId: 'ca-app-pub-9120523919163473/1186325092',
                  adSize: AdmobBannerSize.FULL_BANNER,
                ),
              ),
              BottomNavigationBar(
                onTap: _onSwitchPage,
                type: BottomNavigationBarType.fixed,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home,
                        color: _selectedIndex == 0 ? Colors.teal : Colors.grey),
                    title: Text('A la une',
                        style: TextStyle(
                            color: _selectedIndex == 0 ? Colors.teal : Colors.grey,
                            fontSize: 11)),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.explore_rounded,
                        color: _selectedIndex == 1 ? Colors.teal : Colors.grey),
                    title: Text('Explorer',
                        style: TextStyle(
                            color: _selectedIndex == 1 ? Colors.teal : Colors.grey,
                            fontSize: 11)),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.group,
                        color: _selectedIndex == 2 ? Colors.teal : Colors.grey),
                    title: Text('Forum',
                        style: TextStyle(
                            color: _selectedIndex == 2 ? Colors.teal : Colors.grey,
                            fontSize: 11)),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.book_outlined,
                        color: _selectedIndex == 3 ? Colors.teal : Colors.grey),
                    title: Text('Magazine',
                        style: TextStyle(
                            color: _selectedIndex == 3 ? Colors.teal : Colors.grey,
                            fontSize: 11)),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.receipt_sharp,
                        color: _selectedIndex == 4 ? Colors.teal : Colors.grey),
                    title: Text("s'abonner",
                        style: TextStyle(
                            color: _selectedIndex == 4 ? Colors.teal : Colors.grey,
                            fontSize: 11)),
                  ),
                ],
              )
            ],
          ),
          )
      
      ),
    );
    ;
  }


}



//LANDING...

class LandingPage extends StatefulWidget {
  final int tab_value;
  final bool isConnect;
  final String pp;
  final String email;
  final Utilisateur user;

  LandingPage({this.user, this.tab_value, this.isConnect, this.email, this.pp, Key key}) : super(key:key);

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
  String suffix_foot =
      "&categories=63,65,1514,71,67,66,1648,1649,9548,9244,6897,57778,57777,35409,22736,57714,22747,22748";
  String suffix_basket =
      "&categories=75,32401,32402,1520,7987,6563,83,82,58110";
  String suffix_lamb = "&categories=72";
  String suffix_athletisme = "&categories=84";
  String suffix_rallye = "&categories=85";
  String suffix_combat =
      "&categories=92,22737,22738,22739,22740,17423,6564,22741";
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



    final response = await http.get(
        "https://wiwsport.com/wp-json/wp/v2/posts?per_page=20&page=$page&_embed$suffix&_fields=id,title,content,date,categories,link,_links.wp:featuredmedia,_links.wp:term");
    if (response.statusCode == 200) {
      articles = articles +
          (json.decode(response.body) as List).map((data) {
            return Post.fromJSON(data);
          }).toList();
      setState(() {
        isReload = false;
        print("EVENT RELOAD -> ${_scrollController.position.pixels}");
      });
    }
  }

  double mark = 6000;
  @override
  void initState() {
    _checkConection();

    setSuffix();
    _fetchPosts(suffix);

    WidgetsBinding.instance.addObserver(this);
    super.initState();
    //FirebaseAdMob.instance.initialize(appId:"ca-app-pub-9120523919163473~3676757066");

    // _CurrentScreen(suffix_name);

    _scrollController.addListener(() {
      if(_scrollController.position.pixels >= mark)
      {

        setState(() {
          this.isReload = true;
        });
        fetchMore(suffix);
        mark = _scrollController.position.maxScrollExtent +6000;
      }}
      );
    }
  @override
  void dispose() {
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
