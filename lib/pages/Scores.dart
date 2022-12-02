import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:wiwmedia_wiwsport_v3/MyDrawer.dart';
import 'package:wiwmedia_wiwsport_v3/model/user.dart';
import 'package:wiwmedia_wiwsport_v3/reusable/CustomSearchDelegate.dart';

class Score extends StatefulWidget {
  final Utilisateur user;
  final bool isUser;

  Score({this.user, this.isUser});
  @override
  _ScoreState createState() => _ScoreState();
}

class _ScoreState extends State<Score> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(
              child: InkWell(
                //onTap: () => _scrollUp(),
                //onDoubleTap: () => _refresh(),
                child: Text(
                  "Scrore",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Roboto",
                      fontSize: 17,
                      fontWeight: FontWeight.bold
                  ),
                ),
              )
          ),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Builder(
                builder: (context) =>
                    IconButton(
                      icon: SvgPicture.asset(
                        "assets/icons/search.svg",
                        height: 17,
                        width: 35,
                      ),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(
                                builder: (context) => CustomSearchDelegate(isUser:widget.isUser, user: widget.user,)));
                      },
                    ),
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: new Size(35, 35),
            child: TabBar(
              labelPadding: EdgeInsets.only(left: 5, right: 15, top: 0.0, bottom: 7),
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
                  //----->Fonction onTap & tabs pour date Lists<-----//
            ),
          ),
          //backgroundColor: currentIndex == 3 ? Color(0xffF7F8FA) : Colors.white,
          backgroundColor: Color(0xffF7F8FA),
          elevation: 8,
          centerTitle: false,
          titleSpacing: 0,
          iconTheme: IconThemeData(color: Colors.black54),
        ),
        drawer: widget.isUser != null ? TheDrawer(isConnect:widget.isUser, user: widget.user,): TheDrawer(isConnect: false), 
    );
  }
}