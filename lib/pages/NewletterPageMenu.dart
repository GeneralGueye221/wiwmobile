import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wiwmedia_wiwsport_v3/pages/HomePage.dart';
import 'package:wiwmedia_wiwsport_v3/reusable/CustomSearchDelegate.dart';

class NewsLetterPageMenu extends StatefulWidget {
  @override
  _NewsLetterPageMenuState createState() => _NewsLetterPageMenuState();
}

class _NewsLetterPageMenuState extends State<NewsLetterPageMenu> {
  InAppWebViewController _webViewController;
  String url = "";
  double progress = 0;

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
        )
    );
  }
}
