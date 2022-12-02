import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:wiwmedia_wiwsport_v3/model/user.dart';
import 'package:wiwmedia_wiwsport_v3/pages/ExplorerNews.dart';
import 'package:wiwmedia_wiwsport_v3/pages/ExplorerPage.dart';
import 'package:wiwmedia_wiwsport_v3/pages/HomePage.dart';
import 'package:wiwmedia_wiwsport_v3/pages/KiosquePage.dart';
import 'package:wiwmedia_wiwsport_v3/pages/ResearchPage.dart';
import 'package:wiwmedia_wiwsport_v3/pages/ForumPage.dart';
import 'package:wiwmedia_wiwsport_v3/reusable/CustomSearchDelegate.dart';

class NewsLetterPage extends StatefulWidget {
  bool isUser;
  final Utilisateur user;

  NewsLetterPage({this.isUser, this.user,});
  @override
  _NewsLetterPageState createState() => _NewsLetterPageState();
}

class _NewsLetterPageState extends State<NewsLetterPage> {
  InAppWebViewController _webViewController;
  String url = "";
  double progress = 0;

  int _selectedIndex=3;
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
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.user!=null) print("USER INFO ABONNE| username:${widget.user.pseudo}, email:${widget.user.email}, pp:${widget.user.pp}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:  AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            iconSize: 24,
            color: Colors.black,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) { return HomePage();}));
            },
          ),
          title: Center(
              child: Image.asset('assets/images/logo_wiwsport.png', height: 300, width: 120),
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CustomSearchDelegate()));
                  },
                ),
              ),
            ),
          ],
          backgroundColor: Colors.white,
          elevation: 8,
          centerTitle: false,
          titleSpacing: 0,
          iconTheme: IconThemeData(color: Colors.black54),
        ),
        body: Container(
        child: InAppWebView(
          initialUrl: "https://landing.mailerlite.com/webforms/landing/v9i8h2",
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
            debuggingEnabled: true,
            ),
        ),
        onWebViewCreated: (InAppWebViewController controller) {
        _webViewController = controller;
        },
        onLoadStart: (InAppWebViewController controller, String url) {
            setState(() {
              this.url = url;
            });
        },
        onLoadStop: (InAppWebViewController controller, String url) async {
            setState(() {
                this.url = url;
            });
        },
      ),
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
    );
  }
}
