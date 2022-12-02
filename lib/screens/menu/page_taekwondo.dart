import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:wiwmedia_wiwsport_v3/model/menu/combat.dart';
import 'package:wiwmedia_wiwsport_v3/model/user.dart';
import 'package:wiwmedia_wiwsport_v3/pages/ExplorerNews.dart';
import 'package:wiwmedia_wiwsport_v3/pages/ExplorerPage.dart';
import 'package:wiwmedia_wiwsport_v3/pages/ForumPage.dart';
import 'package:wiwmedia_wiwsport_v3/pages/HomePage.dart';
import 'package:wiwmedia_wiwsport_v3/pages/KiosquePage.dart';

import 'package:wiwmedia_wiwsport_v3/reusable/CustomSearchDelegate.dart';
import 'package:wiwmedia_wiwsport_v3/screens/menu/LandingPages/taekwondo.dart';
import 'package:wiwmedia_wiwsport_v3/screens/menu/page_newsletter.dart';

import '../../MyDrawer.dart';

class PageArtMars extends StatefulWidget {
  final int index;
  bool isUser;
  Utilisateur user;
  PageArtMars(this.user, this.isUser, this.index);
  @override
  _PageArtMarsState createState() => _PageArtMarsState();
}

class _PageArtMarsState extends State<PageArtMars> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int currentIndex = 0;
  int tab_value = 1;
  var _search = new TextEditingController();
  bool isSearching = false;

  _PageArtMarsState() {
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

  void changePage(int index) {
    if (index == 3) {
      this._scaffoldKey.currentState.openEndDrawer();
    }
    setState(() {
      currentIndex = index;
    });
  }

  int _initIndex = 2;
  @override
  void initState() {
    _initIndex = widget.index;
    super.initState();
  }

  int _selectedIndex = 0;
  PageController _pageController = PageController(initialPage: 1);
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
        length: category_combat_taekwondo.length,
        initialIndex: _initIndex,
        child: Scaffold(
            key: _scaffoldKey,
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
                preferredSize: Size(35, 35),
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
                  onTap: (int) {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> PageArtMars(widget.user, widget.isUser, int)));
                },    
                  tabs: List.generate(
                      category_combat_taekwondo.length,
                      (index) => Text(
                            category_combat_taekwondo[index].nom,
                          )),
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
                    LandingArtMars(user: widget.user,tab_value: 0),
                    LandingArtMars(user: widget.user,tab_value: 1),
                    LandingArtMars(user: widget.user,tab_value: 2),
                    LandingArtMars(user: widget.user,tab_value: 3),
                    LandingArtMars(user: widget.user,tab_value: 4),
                    LandingArtMars(user: widget.user,tab_value: 5),
                    LandingArtMars(user: widget.user,tab_value: 6),
                    LandingArtMars(user: widget.user,tab_value: 7),
                    LandingArtMars(user: widget.user,tab_value: 8),
                  ],
                ),
                Container(
                    height: 75,
                    color: Colors.transparent,
                    child: IntrinsicHeight(
                      child: AdmobBanner(
                          adUnitId: 'ca-app-pub-9120523919163473/1186325092',
                          adSize: AdmobBannerSize.FULL_BANNER),
                    )),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
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
        ));
  }
}