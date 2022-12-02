import 'package:html/parser.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';

import 'package:wiwmedia_wiwsport_v3/model/categories.dart';
import 'package:wiwmedia_wiwsport_v3/model/results.dart';
import 'package:wiwmedia_wiwsport_v3/model/user.dart';

import 'package:wiwmedia_wiwsport_v3/pages/landings/landing_page_explorer.dart';
import 'package:wiwmedia_wiwsport_v3/reusable/CustomSearchDelegate.dart';
import 'package:wiwmedia_wiwsport_v3/reusable/players/twitter.dart';
import 'package:wiwmedia_wiwsport_v3/screens/PostCardExp.dart';
import 'package:wiwmedia_wiwsport_v3/screens/PostCardExpYT.dart';
import 'package:wiwmedia_wiwsport_v3/screens/menu/page_newsletter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../MyDrawer.dart';
import 'ForumPage.dart';
import 'HomePage.dart';
import 'KiosquePage.dart';




class ExplorerNews extends StatefulWidget {
  bool isUser;
  final Utilisateur user;

  ExplorerNews({this.user,this.isUser,});
  @override
  _ExplorerNewsState createState() => _ExplorerNewsState();
}

class _ExplorerNewsState extends State<ExplorerNews> with WidgetsBindingObserver {
  GlobalKey<LandingPageBuzzState> buzzKey = GlobalKey<LandingPageBuzzState>();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKeyBuzz =
  new GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKeyFoot =
  new GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKeyBasket =
  new GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKeyCombat =
  new GlobalKey<RefreshIndicatorState>();

  ScrollController _scrollController =new ScrollController();
  ScrollController _scrollControllerBuzz =new ScrollController();
  ScrollController _scrollControllerFoot =new ScrollController();
  ScrollController _scrollControllerBasket =new ScrollController();
  ScrollController _scrollControllerCombat =new ScrollController();

  static const _adUnitID = "ca-app-pub-9120523919163473/1283696274";


  //REFRESH PAGE
  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    return  Navigator.push(
        context,
        MaterialPageRoute(
            builder: (content) {
              return ExplorerNews();
            }
        )
    );

  }

  Future<Null> _refreshTv() async {
    await Future.delayed(Duration(seconds: 1));
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
  Future<Null> _refreshLive() async {
    await Future.delayed(Duration(seconds: 1), () {
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
    });
  }

  bool isLoading =true;
  ScrollController scrollController = new ScrollController();


  _scrollUp () {
    return _scrollController.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  }
  _scrollUpLive () {
    return buzzKey.currentState.scrollController.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  }
  _scrollUpTv () {
    return _scrollControllerFoot.jumpTo(0);
  }


  int _selectedIndex=1;
  int _currentIndex=0;
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
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('--------------------------------------------------------------------->explorer state = $state');
    if (state==AppLifecycleState.resumed) _refreshLive();
  }
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: categories_explorer.length,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Center(
              child: InkWell(
                onTap: () => _scrollUp(),
                onDoubleTap: () => _refresh(),
                child: Text(
                  "Explorer",
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
          backgroundColor: Color(0xffF7F8FA),
          elevation: 8,
          centerTitle: false,
          titleSpacing: 0,
          iconTheme: IconThemeData(color: Colors.black54),
        ),
        drawer: widget.isUser != null ? TheDrawer(isConnect:widget.isUser, user: widget.user,): TheDrawer(isConnect: false),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
                child: setContent(0),
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
      ),
    );
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //FONCTIONS

  var resultats = FirebaseFirestore.instance.collection('resultats').orderBy('date',descending: true);
  var resultats_live = FirebaseFirestore.instance.collection('resultats_live').orderBy('date',descending: true);
  var resultats_tv = FirebaseFirestore.instance.collection('wiwsport_tv').orderBy('date',descending: true);

  setContent (int _index) {
    if(_index==0) {
      return _renderNews(resultats);
    }
    else if(_index==1) {
      return _renderLive(resultats_live);
    }
    else if(_index==2) {
      return _renderTv(resultats_tv);
    }
  }

  Widget _renderLive(data) {
    List<Resultat> results = new List();
    return RefreshIndicator(
        key: _refreshIndicatorKeyCombat,
        onRefresh: _refreshLive,
        child:  StreamBuilder<QuerySnapshot>(
          stream: data.snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('-Something went wrong to load this data-');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Image.asset(
                  'assets/gifs/green_style.gif', height: 25, width: 25,),
              );
            }
            final list = snapshot.data.docs;            
            return ListView.builder(
                shrinkWrap: true,
                controller: _scrollControllerCombat,
                itemCount:snapshot.data.size,
                itemBuilder: (BuildContext context, index){
                  if(list[index]["type"]=="twitter"){
                    if(index == 0 ){
                      return Column(
                        children: [
                          SizedBox(height: 20,),
                          /*
                          Container(
                            padding: EdgeInsets.all(5),
                            child: AdmobBanner(
                              adUnitId: 'ca-app-pub-9120523919163473/5738781727',
                              adSize: AdmobBannerSize.LARGE_BANNER,
                            ),
                          ),
                          */
                          TwitterCardPlus(id:list[index]['numero'], isExplorer: true, title:  parse(list[index]["title"]).documentElement.text, slug: list[index]['slug'],),
                        ],
                      );
                    }
                    else if(index != 0 && index%4 ==0) {
                      return Column(
                        children: [
                          SizedBox(height: 20,),
                          TwitterCardPlus(id:list[index]['numero'], isExplorer: true, title:  parse(list[index]["title"]).documentElement.text, slug: list[index]['slug'],),
                          Container(
                            padding: EdgeInsets.all(5),
                            child: AdmobBanner(
                              adUnitId: 'ca-app-pub-9120523919163473/6172909881',
                              adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                            ),
                          ),
                        ],
                      );
                    }
                    else {
                      return Column(
                        children: [
                          SizedBox(height: 20,),
                          TwitterCardPlus(id:list[index]['numero'], isExplorer: true, title:  parse(list[index]["title"]).documentElement.text, slug: list[index]['slug'],),
                        ],
                      );
                    }
                  }
                  else if(list[index]["type"]=="Youtube*"){
                    if(index == 0 ){
                      return Column(
                        children: [
                          SizedBox(height: 20,),
                          /*
                          Container(
                            padding: EdgeInsets.all(5),
                            child: AdmobBanner(
                              adUnitId: 'ca-app-pub-9120523919163473/5738781727',
                              adSize: AdmobBannerSize.LARGE_BANNER,
                            ),
                          ),
                          */
                          PostCardExpYT(VideoItemId: list[index]['numero'], VideoItemDate: null, VideoItemTitle: list[index]['title'], VideoItemLink: list[index]['link']),
                        ],
                      );
                    }
                    else if(index != 0 && index%4 ==0) {
                      return Column(
                        children: [
                          SizedBox(height: 20,),
                          PostCardExpYT(VideoItemId: list[index]['numero'], VideoItemDate: null, VideoItemTitle: list[index]['title'], VideoItemLink: list[index]['link']),
                          Container(
                            padding: EdgeInsets.all(5),
                            child: AdmobBanner(
                              adUnitId: 'ca-app-pub-9120523919163473/6172909881',
                              adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                            ),
                          ),
                        ],
                      );
                    }
                    else {
                      return Column(
                        children: [
                          SizedBox(height: 20,),
                          PostCardExpYT(VideoItemId: list[index]['numero'], VideoItemDate: null, VideoItemTitle: list[index]['title'], VideoItemLink: list[index]['link']),
                        ],
                      );
                    }
                  }
                  else {
                    if(index == 0 ){
                      return Column(
                        children: [
                          SizedBox(height: 20,),
                          /*
                          Container(
                            padding: EdgeInsets.all(5),
                            child: AdmobBanner(
                              adUnitId: 'ca-app-pub-9120523919163473/5738781727',
                              adSize: AdmobBannerSize.LARGE_BANNER,
                            ),
                          ),
                          */
                          PostCardExp(title: parse(list[index]["title"]).documentElement.text, content: list[index]['content'], type: list[index]['type'], link: list[index]['link'], slug: list[index]['slug'], date: list[index]['date'].toString(),),
                        ],
                      );
                    }
                    else if(index != 0 && index%4 ==0) {
                      return Column(
                        children: [
                          SizedBox(height: 20,),
                          PostCardExp(title: parse(list[index]["title"]).documentElement.text, content: list[index]['content'], type: list[index]['type'], link: list[index]['link'], slug: list[index]['slug'], date: list[index]['date'].toString(),),
                          Container(
                            padding: EdgeInsets.all(5),
                            child: AdmobBanner(
                              adUnitId: 'ca-app-pub-9120523919163473/6172909881',
                              adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                            ),
                          ),
                        ],
                      );
                    }
                    else {
                      return Column(
                        children: [
                          SizedBox(height: 20,),
                          PostCardExp(title: parse(list[index]["title"]).documentElement.text, content: list[index]['content'], type: list[index]['type'], link: list[index]['link'], slug: list[index]['slug'], date: list[index]['date'].toString(),),
                        ],
                      );
                    }
                  }
                }
            );
            return ListView(
              children: snapshot.data.docs.map((document) {
                if(document["type"]=="twitter"){
                  return Column(
                    children: [
                      SizedBox(height: 20,),
                      TwitterCardPlus(id:document['numero'], isExplorer: true, title:  parse(document["title"]).documentElement.text, slug: document['slug'],),
                    ],
                  );
                }

                else if(document["type"]=="Youtube*"){
                  return Column(
                    children: [
                      SizedBox(height: 20,),
                      PostCardExpYT(VideoItemId: document['numero'], VideoItemDate: null, VideoItemTitle: document['title'], VideoItemLink: document['link']),
                    ],
                  );
                }

                else {
                  return Column(
                    children: [
                      SizedBox(height: 20,),
                      PostCardExp(title: parse(document["title"]).documentElement.text, content: document['content'], type: document['type'], link: document['link'], slug: document['slug'], date: document['date'].toString(),),
                    ],
                  );
                }

              }).toList(),
            );
          },
        )
    );
  }

  Widget _renderTv(data) {
    return RefreshIndicator(
        key: _refreshIndicatorKeyBasket,
        onRefresh: _refreshTv,
        child:   StreamBuilder<QuerySnapshot>(
          stream: data.snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('-Something went wrong to load this data-');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Image.asset(
                  'assets/gifs/green_style.gif', height: 25, width: 25,),
              );
            }

            final list = snapshot.data.docs;
            return ListView(
              children: snapshot.data.docs.map((document) {
                if(document["type"]=="twitter"){
                  return Column(
                    children: [
                      SizedBox(height: 20,),
                      TwitterCardPlus(id:document['numero'], isExplorer: true, title:  parse(document["title"]).documentElement.text, slug: document['slug'],),
                    ],
                  );
                }

                else if(document["type"]=="Youtube*"){
                  return Column(
                    children: [
                      SizedBox(height: 20,),
                      PostCardExpYT(VideoItemId: document['numero'], VideoItemDate: null, VideoItemTitle: document['title'], VideoItemLink: document['link']),
                    ],
                  );
                }

                else {
                  return Column(
                    children: [
                      SizedBox(height: 20,),
                      PostCardExp(title: parse(document["title"]).documentElement.text, content: document['content'], type: document['type'], link: document['link'], slug: document['slug'], date: document['date'].toString(),),
                    ],
                  );
                }

              }).toList(),
            );
            return ListView.builder(
                shrinkWrap: true,
                controller: _scrollControllerBasket,
                itemCount:snapshot.data.size,
                itemBuilder: (BuildContext context, index){
                  if(list[index]["type"]=="twitter"){
                    if(index == 0 ){
                      return Column(
                        children: [
                          SizedBox(height: 20,),
                          /*
                          Container(
                            padding: EdgeInsets.all(5),
                            child: AdmobBanner(
                              adUnitId: 'ca-app-pub-9120523919163473/5738781727',
                              adSize: AdmobBannerSize.LARGE_BANNER,
                            ),
                          ),
                          */
                          TwitterCardPlus(id:list[index]['numero'], isExplorer: true, title:  parse(list[index]["title"]).documentElement.text, slug: list[index]['slug'],),
                        ],
                      );
                    }
                    else if(index != 0 && index%4 ==0) {
                      return Column(
                        children: [
                          SizedBox(height: 20,),
                          TwitterCardPlus(id:list[index]['numero'], isExplorer: true, title:  parse(list[index]["title"]).documentElement.text, slug: list[index]['slug'],),
                          Container(
                            padding: EdgeInsets.all(5),
                            child: AdmobBanner(
                              adUnitId: 'ca-app-pub-9120523919163473/6172909881',
                              adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                            ),
                          ),
                        ],
                      );
                    }
                    else {
                      return Column(
                        children: [
                          SizedBox(height: 20,),
                          TwitterCardPlus(id:list[index]['numero'], isExplorer: true, title:  parse(list[index]["title"]).documentElement.text, slug: list[index]['slug'],),
                        ],
                      );
                    }
                  }
                  else if(list[index]["type"]=="Youtube*"){
                    if(index == 0 ){
                      return Column(
                        children: [
                          SizedBox(height: 20,),
                          /*
                          Container(
                            padding: EdgeInsets.all(5),
                            child: AdmobBanner(
                              adUnitId: 'ca-app-pub-9120523919163473/5738781727',
                              adSize: AdmobBannerSize.LARGE_BANNER,
                            ),
                          ),
                          */
                          PostCardExpYT(VideoItemId: list[index]['numero'], VideoItemDate: list[index]['date'], VideoItemTitle: list[index]['title'], VideoItemLink: list[index]['link']),
                        ],
                      );
                    }
                    else if(index != 0 && index%4 ==0) {
                      return Column(
                        children: [
                          SizedBox(height: 20,),
                          PostCardExpYT(VideoItemId: list[index]['numero'], VideoItemDate: list[index]['date'], VideoItemTitle: list[index]['title'], VideoItemLink: list[index]['link']),
                          Container(
                            padding: EdgeInsets.all(5),
                            child: AdmobBanner(
                              adUnitId: 'ca-app-pub-9120523919163473/6172909881',
                              adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                            ),
                          ),
                        ],
                      );
                    }
                    else {
                      return Column(
                        children: [
                          SizedBox(height: 20,),
                          PostCardExpYT(VideoItemId: list[index]['numero'], VideoItemDate: list[index]['date'], VideoItemTitle: list[index]['title'], VideoItemLink: list[index]['link']),
                        ],
                      );
                    }
                  }
                  else {
                    if(index == 0 ){
                      return Column(
                        children: [
                          SizedBox(height: 20,),
                          /*
                          Container(
                            padding: EdgeInsets.all(5),
                            child: AdmobBanner(
                              adUnitId: 'ca-app-pub-9120523919163473/5738781727',
                              adSize: AdmobBannerSize.LARGE_BANNER,
                            ),
                          ),
                          */
                          PostCardExp(title: parse(list[index]["title"]).documentElement.text, content: list[index]['content'], type: list[index]['type'], link: list[index]['link'], slug: list[index]['slug'], date: list[index]['date'].toString(),),
                        ],
                      );
                    }
                    else if(index != 0 && index%4 ==0) {
                      return Column(
                        children: [
                          SizedBox(height: 20,),
                          PostCardExp(title: parse(list[index]["title"]).documentElement.text, content: list[index]['content'], type: list[index]['type'], link: list[index]['link'], slug: list[index]['slug'], date: list[index]['date'].toString(),),
                          Container(
                            padding: EdgeInsets.all(5),
                            child: AdmobBanner(
                              adUnitId: 'ca-app-pub-9120523919163473/6172909881',
                              adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                            ),
                          ),
                        ],
                      );
                    }
                    else {
                      return Column(
                        children: [
                          SizedBox(height: 20,),
                          PostCardExp(title: parse(list[index]["title"]).documentElement.text, content: list[index]['content'], type: list[index]['type'], link: list[index]['link'], slug: list[index]['slug'], date: list[index]['date'].toString(),),
                        ],
                      );
                    }
                  }
                }
            );
          },
        )
    );
  }

  Widget _renderNews(data) {
    return RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child:  StreamBuilder<QuerySnapshot>(
          stream: data.snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('-Something went wrong to load this data-');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Image.asset(
                  'assets/gifs/green_style.gif', height: 25, width: 25,),
              );
            }

            final list = snapshot.data.docs;
            return ListView.builder (
                shrinkWrap: true,
                controller: _scrollController,
                itemCount:snapshot.data.size,
                itemBuilder: (BuildContext context, index){
                  if(list[index]["type"]=="twitter"){
                    if(index == 0 ){
                      return Column(
                        children: [
                          SizedBox(height: 20,),
                          
                          Container(
                            padding: EdgeInsets.all(5),
                            child: AdmobBanner(
                              adUnitId: 'ca-app-pub-9120523919163473/5738781727',
                              adSize: AdmobBannerSize.LARGE_BANNER,
                            ),
                          ),
                          
                          TwitterCardPlus(id:list[index]['numero'], isExplorer: true, title:  parse(list[index]["title"]).documentElement.text, slug: list[index]['slug'],),
                        ],
                      );
                    }
                    else if(index != 0 && index%4 ==0) {
                      return Column(
                        children: [
                          SizedBox(height: 20,),
                          TwitterCardPlus(id:list[index]['numero'], isExplorer: true, title:  parse(list[index]["title"]).documentElement.text, slug: list[index]['slug'],),
                          Container(
                            padding: EdgeInsets.all(5),
                            child: AdmobBanner(
                              adUnitId: 'ca-app-pub-9120523919163473/6172909881',
                              adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                            ),
                          ),
                        ],
                      );
                    }
                    else {
                      return Column(
                        children: [
                          SizedBox(height: 20,),
                          TwitterCardPlus(id:list[index]['numero'], isExplorer: true, title:  parse(list[index]["title"]).documentElement.text, slug: list[index]['slug'],),
                        ],
                      );
                    }
                  }
                  else if(list[index]["type"]=="Youtube*"){
                    if(index == 0 ){
                      return Column(
                        children: [
                          SizedBox(height: 20,),
                          /*
                          Container(
                            padding: EdgeInsets.all(5),
                            child: AdmobBanner(
                              adUnitId: 'ca-app-pub-9120523919163473/5738781727',
                              adSize: AdmobBannerSize.LARGE_BANNER,
                            ),
                          ),
                          */
                          PostCardExpYT(VideoItemId: list[index]['numero'], VideoItemDate: list[index]['date'], VideoItemTitle: list[index]['title'], VideoItemLink: list[index]['link']),
                        ],
                      );
                    }
                    else if(index != 0 && index%4 ==0) {
                      return Column(
                        children: [
                          SizedBox(height: 20,),
                          PostCardExpYT(VideoItemId: list[index]['numero'], VideoItemDate: list[index]['date'], VideoItemTitle: list[index]['title'], VideoItemLink: list[index]['link']),
                          Container(
                            padding: EdgeInsets.all(5),
                            child: AdmobBanner(
                              adUnitId: 'ca-app-pub-9120523919163473/6172909881',
                              adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                            ),
                          ),
                        ],
                      );
                    }
                    else {
                      return Column(
                        children: [
                          SizedBox(height: 20,),
                          PostCardExpYT(VideoItemId: list[index]['numero'], VideoItemDate: list[index]['date'], VideoItemTitle: list[index]['title'], VideoItemLink: list[index]['link']),
                        ],
                      );
                    }
                  }
                  else {
                    if(index == 0 ){
                      return Column(
                        children: [
                          SizedBox(height: 20,),
                          /*
                          Container(
                            padding: EdgeInsets.all(5),
                            child: AdmobBanner(
                              adUnitId: 'ca-app-pub-9120523919163473/5738781727',
                              adSize: AdmobBannerSize.LARGE_BANNER,
                            ),
                          ),
                          */
                          PostCardExp(title: parse(list[index]["title"]).documentElement.text, content: list[index]['content'], type: list[index]['type'], link: list[index]['link'], slug: list[index]['slug'], date: list[index]['date'].toString(),),
                        ],
                      );
                    }
                    else if(index != 0 && index%4 ==0) {
                      return Column(
                        children: [
                          SizedBox(height: 20,),
                          PostCardExp(title: parse(list[index]["title"]).documentElement.text, content: list[index]['content'], type: list[index]['type'], link: list[index]['link'], slug: list[index]['slug'], date: list[index]['date'].toString(),),
                          Container(
                            padding: EdgeInsets.all(5),
                            child: AdmobBanner(
                              adUnitId: 'ca-app-pub-9120523919163473/6172909881',
                              adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                            ),
                          ),
                        ],
                      );
                    }
                    else {
                      return Column(
                        children: [
                          SizedBox(height: 20,),
                          PostCardExp(title: parse(list[index]["title"]).documentElement.text, content: list[index]['content'], type: list[index]['type'], link: list[index]['link'], slug: list[index]['slug'], date: list[index]['date'].toString(),),
                        ],
                      );
                    }
                  }
                }
            );
            return ListView(
              children: snapshot.data.docs.map((document) {
                if(document["type"]=="twitter"){
                  return Column(
                    children: [
                      SizedBox(height: 20,),
                      TwitterCardPlus(id:document['numero'], isExplorer: true, title:  parse(document["title"]).documentElement.text, slug: document['slug'],),
                    ],
                  );
                }

                else if(document["type"]=="Youtube*"){
                  return Column(
                    children: [
                      SizedBox(height: 20,),
                      PostCardExpYT(VideoItemId: document['numero'], VideoItemDate: null, VideoItemTitle: document['title'], VideoItemLink: document['link']),
                    ],
                  );
                }

                else {
                  return Column(
                    children: [
                      SizedBox(height: 20,),
                      PostCardExp(title: parse(document["title"]).documentElement.text, content: document['content'], type: document['type'], link: document['link'], slug: document['slug'], date: document['date'].toString(),),
                    ],
                  );
                }

              }).toList(),
            );
      
            
            new ListView(
              controller: _scrollController,
              shrinkWrap: true,
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                var titre = parse( document.data()['title']).documentElement.text;
                if(document.data()['type']=="twitter"){
                  return TwitterCardPlus(id:document.data()['numero'], isExplorer: true, title:  titre, slug: document.data()['slug'],);
                }
                else if(document.data()['type']=="Youtube*"){
                  return PostCardExpYT(VideoItemId: document.data()['numero'], VideoItemDate: document.data()['date'], VideoItemTitle: document.data()['title'], VideoItemLink: document.data()['link']);
                }
                else {
                  return PostCardExp(title:titre, content: document.data()['content'], type: document.data()['type'], link: document.data()['link'], slug: document.data()['slug'], date: document.data()['date'].toString(),);
                }
              }).toList(),
            );
          },
        )
    );
  }
}

