import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart' as p;

import 'package:wiwmedia_wiwsport_v3/model/user.dart';
import 'package:wiwmedia_wiwsport_v3/pages/ExplorerNews.dart';
import 'package:wiwmedia_wiwsport_v3/screens/menu/page_newsletter.dart';
import '../MyDrawer.dart';
import 'ExplorerPage.dart';
import 'ForumPage.dart';
import 'HomePage.dart';

class kioske extends StatefulWidget {
  bool isUser;
  final Utilisateur user;

  kioske({Key key, this.isUser, this.user}) : super(key: key);

  @override
  _kioskeState createState() => _kioskeState();
}

class _kioskeState extends State<kioske> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ScrollController _scrollController =  new ScrollController();

  Future<List<Directory>> _getExternalStoragePath () {
    return p.getExternalStorageDirectories(
      type: p.StorageDirectory.documents,
    );
  }


  _launchUrl(String link) async {
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      throw 'Cannot launch $link';
    }
  }

  int _selectedIndex = 3;
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

  generateDate(int jour, int mois, int annee) {
    String _dateTime = "";
    if (mois == 1) {
      _dateTime = "le ${jour} Janv. ${annee}";
    } else if (mois == 2) {
      _dateTime = "le ${jour} Fév. ${annee} ";
    } else if (mois == 3) {
      _dateTime = "le ${jour} Mars ${annee} ";
    } else if (mois == 4) {
      _dateTime = "le ${jour} Avr. ${annee} ";
    } else if (mois == 5) {
      _dateTime = "le ${jour} Mai ${annee}  ";
    } else if (mois == 6) {
      _dateTime = "le ${jour} Juin ${annee} ";
    } else if (mois == 7) {
      _dateTime = "le ${jour} Juil. ${annee} ";
    } else if (mois == 8) {
      _dateTime = "le ${jour} Août ${annee} ";
    } else if (mois == 9) {
      _dateTime = "le ${jour} Sept. ${annee} ";
    } else if (mois == 10) {
      _dateTime = "le ${jour} Oct. ${annee} ";
    } else if (mois == 11) {
      _dateTime = "le ${jour} Nov. ${annee} ";
    } else if (mois == 12) {
      _dateTime = "le ${jour} Déc. ${annee} ";
    }
    return Text(_dateTime,
        style: TextStyle(
          fontSize: 17,
          fontWeight: null,
          fontFamily: "DINNextLTPro-MediumCond",
          color: Colors.black45,
        ));
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            " wiwsport Magazine",
            style: TextStyle(
                color: Colors.black,
                fontFamily: "Roboto",
                fontSize: 17,
                fontWeight: FontWeight.bold),
          ),
        ),
        actions: <Widget>[
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
              child: Text(" s'abonner ",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    fontFamily: "DINNextLTPro-MediumCond",
                    color: Colors.black,
                  )),
            ),
          ),
        ],
        backgroundColor: Color(0xffF7F8FA),
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
          Container(
            height: MediaQuery.of(context).size.height,
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('magasines')
                  .orderBy('date', descending: true)
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

                return ListView.builder(
                  controller: _scrollController ,
                  shrinkWrap: true ,
                  itemCount: snapshot.data.size,
                  itemBuilder: (context, i) {
                    print(
                        'document n$i : ${docs[i]['titre']} - ${docs[i]['date']}'
                    );
                    if (i == 0)
                      return Column(children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(44,7,55,7),
                          child: AdmobBanner(
                            adUnitId:
                            'ca-app-pub-9120523919163473/8613205507',
                            adSize: AdmobBannerSize.LARGE_BANNER,
                          ),
                        ),
                        _result(
                          docs[i]['titre'],
                          docs[i]['date'],
                          docs[i]['images'],
                          docs[i]['lien'],
                        )
                      ]);
                    else if(i==snapshot.data.size-1)
                      return Column(children: [
                        _result(
                          docs[i]['titre'],
                          docs[i]['date'],
                          docs[i]['images'],
                          docs[i]['lien'],
                        ),
                        SizedBox(height: 66)
                      ]);
                    else
                      return _result(
                        docs[i]['titre'],
                        docs[i]['date'],
                        docs[i]['images'],
                        docs[i]['lien'],
                      );
                  },
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(),
          ),
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
    );
  }

  Widget _result(title, date, image, link) {
    DateTime _date = date.toDate();
    date = _date.toString();
    var an = int.parse(date.substring(0, 4));
    var mois = int.parse(date.substring(5, 7));
    var jour = int.parse(date.substring(8, 10));
    //print('---------------------->_date: ${_date}');
    String pdfurl = link;
    return Container(
      padding: EdgeInsets.all(7),
      //margin: EdgeInsets.only(left: 50, right: 50),
      child: Column(
        children: [
          SizedBox(height: 15),
          Container(
            //padding: EdgeInsets.only(left: 55, right: 55),
            child: Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontFamily: "DINNextLTPro-MediumCond",
                      fontSize: 19,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10),
                generateDate(jour, mois, an),
              ],
            ),
          ),
          SizedBox(height: 20),
          InkWell(
            onTap: () =>_launchUrl(link),
            child: Container(
              padding: EdgeInsets.only(left: 55, right: 55),
              child: Image.network(image),
            ),
          ),
          SizedBox(height: 10),
          InkWell(
            onTap: () =>_launchUrl(link),
            child: Container(
              color: Colors.grey[200],
              height: 50,
              child: Stack(children: [
                Container(
                  padding: EdgeInsets.all(13.0),
                  alignment: Alignment.topLeft,
                  child: Text("lire le magazine",
                      style: TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold)),
                ),
                Container(
                  padding: EdgeInsets.all(13.0),
                  alignment: Alignment.topRight,
                  child: Text(
                    ">",
                    style: TextStyle(fontSize: 15, color: Colors.teal),
                  ),
                )
              ]),
            )
          ),
        ],
      ),
    );
  }


}
