import 'dart:convert';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:overlay_screen/overlay_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:wiwmedia_wiwsport_v3/model/categories.dart';
import 'package:wiwmedia_wiwsport_v3/model/post.dart';
import 'package:wiwmedia_wiwsport_v3/model/user.dart';
import 'package:wiwmedia_wiwsport_v3/pages/ExplorerNews.dart';
import 'package:wiwmedia_wiwsport_v3/reusable/CustomSearchDelegate.dart';
import 'package:wiwmedia_wiwsport_v3/screens/menu/page_newsletter.dart';

import '../MyDrawer.dart';
import 'ExplorerPage.dart';
import 'HomePage.dart';
import 'KiosquePage.dart';
import 'ResearchPage.dart';
import 'User/Connexion.dart';
import 'User/Room.dart';

class Salon extends StatefulWidget {
  bool isUser;
  Utilisateur user;

  final bool isConnect;

  Salon({Key key, this.user, this.isUser, this.isConnect}) : super(key: key);

  @override
  _SalonState createState() => _SalonState();
}

class _SalonState extends State<Salon> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  bool isConnect = false;
  Post article;

  SharedPreferences preferences;

  Future<void> initializePreference() async{
    this.preferences = await SharedPreferences.getInstance();
    await retrieveUser();
  }
  Future<void> StoreUser() async {
    Utilisateur _user = Utilisateur(id: widget.user.id, email: widget.user.email, pp: widget.user.pp, pseudo: widget.user.pseudo);
    String _store = jsonEncode(_user.toJson());

    await this.preferences.setString('user', _store);
  }
  Future retrieveUser() async {
    String _resultStore = this.preferences.getString("user");
    Map<String,dynamic> decoded = jsonDecode(_resultStore);
    if(_resultStore.isEmpty || Utilisateur.fromJSON(decoded).id==null){
      if(widget.isUser) return StoreUser();
    } else {
      setState(() {
        widget.user = Utilisateur(id: Utilisateur.fromJSON(decoded).id, email: Utilisateur.fromJSON(decoded).email, pp: Utilisateur.fromJSON(decoded).pp, pseudo: Utilisateur.fromJSON(decoded).pseudo, numberphone: Utilisateur.fromJSON(decoded).numberphone);
        widget.isUser =true;
        print("USER STORED & RETRIEVED SUCESSFULLY -> id:${widget.user.id} pseudo:${widget.user.pseudo} isConnected:${widget.isUser}");
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    initializePreference().whenComplete((){
      setState(() {});
      if(widget.user!=null) {
        print("USER INFO HOME from store | username:${widget.user.pseudo}, email:${widget.user.email}, pp:${widget.user.pp}");
      }
    });

    if(widget.user!=null) print("USER INFO FORUM| username:${widget.user.pseudo}, numero:${widget.user.numberphone}, email:${widget.user.email}, pp:${widget.user.pp}");

    super.initState();

    if(widget.isUser==null) {widget.isUser=false;}
  }


  @override
  Widget build(BuildContext context) {
    OverlayScreen().saveScreens({
      'login': CustomOverlayScreen(
        backgroundColor: Colors.teal.withOpacity(0.5),
        content: ToConnect(isArticle: false),
      ),
    });
    return DefaultTabController(
        length: categories_salon.length,
        child: Scaffold(
          appBar: AppBar(
            title: Center(
                child: InkWell(
                  //onTap: () => _scrollUp(),
                  //onDoubleTap: () => _refresh(),
                  child: Text(
                    "Forum",
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
                                  builder: (context) => CustomSearchDelegate(isUser:widget.isUser, user: widget.user)));
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
            bottom: PreferredSize(
              preferredSize: Size(35,35),
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
                tabs: List.generate(
                    categories_salon.length,
                        (index) =>
                        Text(
                          categories_salon[index].nom,
                        )),
              ),
            ),
          ),

          drawer: widget.isUser != null ? TheDrawer(isConnect:widget.isUser, user: widget.user,): TheDrawer(isConnect: false),

          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              TabBarView(
                children: [
                  Container(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _firestore.collection('Forum')
                          .orderBy('date', descending:true)
                          .snapshots(),
                      builder: (context, snapshot){
                        if (!snapshot.hasData)
                          return Center(
                            child: Image.asset(
                              'assets/gifs/green_style.gif', height: 25, width: 25,),
                          );
                        List<DocumentSnapshot> docs = snapshot.data.docs;
                        return ListView.builder(
                          itemCount: snapshot.data.size,
                          itemBuilder: (context, i){
                            int size = docs[i]['users'].length-1;
                            if(i==0) return Column(children: [
                              Container(
                                padding: EdgeInsets.all(5),
                                child: AdmobBanner(
                                  adUnitId: 'ca-app-pub-9120523919163473/8613205507',
                                  adSize: AdmobBannerSize.LARGE_BANNER,
                                ),
                              ),
                              _result(docs[i]['article_image'],docs[i]['article_titre'],docs[i]['date'], docs[i]['article_id'],docs[i]['content'],docs[i]['users'][size],docs[i]['article_link'],docs[i]['article_category'],docs[i]['users'].length, docs[i]['article_slug'],docs[i]['type'])
                            ]);
                            else return _result(docs[i]['article_image'],docs[i]['article_titre'],docs[i]['date'], docs[i]['article_id'],docs[i]['content'],docs[i]['users'][size],docs[i]['article_link'],docs[i]['article_category'],docs[i]['users'].length, docs[i]['article_slug'],docs[i]['type']);
                          },
                        );
                      },
                    ),
                  ),
                  widget.user != null
                      ? Container(
                    child: StreamBuilder<QuerySnapshot> (
                      stream: _firestore.collection('Forum')
                          .orderBy('date', descending:true)
                          .snapshots(),
                      builder: (context, snapshot){
                        if(!snapshot.hasData) return Center(
                          child: Image.asset(
                            'assets/gifs/green_style.gif', height: 25, width: 25,),
                        );
                        List<DocumentSnapshot> docs = snapshot.data.docs;

                        return ListView.builder(
                          itemCount: snapshot.data.size,
                          itemBuilder: (context, i){
                            int size = docs[i]['users'].length-1;
                            return Column(children: [
                              i==0?Container(
                                padding: EdgeInsets.all(5),
                                child: AdmobBanner(
                                  adUnitId:
                                  'ca-app-pub-9120523919163473/8613205507',
                                  adSize: AdmobBannerSize.LARGE_BANNER,
                                ),
                              ):Container(),
                              docs[i]['users_id'].contains(widget.user.id)
                                  ? _result(
                                  docs[i]['article_image'],
                                  docs[i]['article_titre'],
                                  docs[i]['date'],
                                  docs[i]['article_id'],
                                  docs[i]['content'],
                                  docs[i]['users'][size],
                                  docs[i]['article_link'],
                                  docs[i]['article_category'],
                                  docs[i]['users'].length,
                                  docs[i]['article_slug'],
                                  docs[i]['type'],
                                  )
                                  : Container(
                                /*
                            child: Center(
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(
                                    3.0, 15.0, 9.0, 15.0),
                                padding:
                                const EdgeInsets.fromLTRB(
                                    3, 1, 3, 3),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color(0xFF339966),
                                      width: 1),
                                ),
                                child: InkWell(
                                  child: Text(
                                      " vous n'avez aucune discussion ",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight:
                                        FontWeight.normal,
                                        fontFamily:
                                        "DINNextLTPro-MediumCond",
                                        color: Colors.black,
                                      )),
                                ),
                              ),
                            ),
                             */
                              )
                            ]);
                          },
                        );
                      },
                    ),
                  )
                      : Container(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(5),
                          child: AdmobBanner(
                            adUnitId:
                            'ca-app-pub-9120523919163473/8613205507',
                            adSize: AdmobBannerSize.LARGE_BANNER,
                          ),
                        ),
                        Center(
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(3.0, 15.0, 9.0, 15.0),
                            padding: const EdgeInsets.fromLTRB(3, 1, 3, 3),
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFF339966), width: 1),
                            ),
                            child: InkWell(
                              onTap: () => login(),
                              child: Text(" connectez-vous pour y accéder ", style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                fontFamily: "DINNextLTPro-MediumCond",
                                color: Colors.black,
                              )),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Container(),
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
        )
    );
  }
  Widget _result(_image, String _title, _date, _id, String _content, _user, _link,_category, _nbr, _slug, _type){
    return InkWell(
      onTap: () {
        article = GetArticle(_id, _title, _image, _link, _category, _date, _slug);
        GetRoom(article);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5),
          Container(
            padding: EdgeInsets.only(left: 11, right: 11,),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //PP
                Container(
                  height:53,
                  width:53,
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      image: DecorationImage(
                          image: NetworkImage(_image),
                          fit: BoxFit.cover
                      )
                  ),
                  //child: Image.network(_image, fit: BoxFit.fill),
                ),
                SizedBox(width: 15),
                //CONTENT
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //titre & nombre message
                    Container(
                      width: MediaQuery.of(context).size.width-100,
                      child: Stack(
                          children: [
                            Container(
                              child: Text(_title.length<=30?_title: _title.substring(0,30)+"...",
                                textAlign: TextAlign.left,
                                style: new TextStyle(fontSize: 15.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  IntrinsicHeight(
                                    child: IntrinsicWidth(
                                      child: Container(
                                        width: 25,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(100),
                                          color: Colors.teal,
                                        ),
                                        child: Text(_nbr.toString(), textAlign: TextAlign.center, style: TextStyle(color: Colors.white),),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ]
                      ),
                    ),
                    //category
                    IntrinsicWidth(child: Text("$_category ", style: TextStyle(color: Colors.teal),)),
                    SizedBox(height: 5),
                    //contenu
                    Container(
                      width: MediaQuery.of(context).size.width-100,
                      child: Stack(
                        children: [
                          _type == "text"
                              ? RichText(
                              text: TextSpan(
                                  children:<TextSpan>[
                                    TextSpan(text:"$_user : ", style: TextStyle(color: Colors.black45, fontWeight: FontWeight.w500),),
                                    TextSpan(text:_content.length<=20&&_user.length<=15
                                        ?"$_content"
                                        : !(_user.length>15)?"${_content.substring(0,20)}..."
                                          :_content.length<=14?"${_content.substring(0,_content.length-3)}...":"${_content.substring(0,14)}...", style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: null,
                                      fontFamily: "DINNextLTPro-MediumCond",
                                      color: Colors.black45,
                                    ))
                                  ]
                              )
                          )
                              : Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('$_user : ', style: TextStyle(color: Colors.black45, fontWeight: FontWeight.w500),),
                              SizedBox(width: 3),
                              Icon(Icons.mic, color: Colors.grey,size: 15,),
                              SizedBox(width: 3),
                              Text('Audio', style: TextStyle(color: Colors.grey),)
                            ],
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.centerRight,
                            child: getDate(_date),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(indent: 77,endIndent: 21)
        ],
      )
    );
  }

  //FONCTIONS
  List<Widget> _results = [];
  int _selectedIndex=2;
  login() async {
    if(OverlayScreen().state == Screen.none) {
      OverlayScreen().show(
        context,
        identifier: 'login',
      );
      //print('-------------------------------------------------------------------> 0');
    }
    //Navigator.push(context, MaterialPageRoute(builder: (context)=>ToConnect(isArticle: false)));
  }

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

  Post GetArticle (id,title,image,link, category, date, slug) {
    Post _post = new Post(id: id, title: title, image: image, link: link, category: category, date: date, slug: slug);
    return _post;
  }
  /*
  GetRoom(Post _post, isComment, isAnswer, answer, answerTo, answerType) {
    OverlayScreen().saveScreens({
      'login': CustomOverlayScreen(
        backgroundColor: Colors.teal.withOpacity(0.5),
        content: ToConnect(fromForum: true,post: _post, isArticle: true),
      ),
    });
    return widget.isUser == null ?OverlayScreen().show(context, identifier: 'login')
        : widget.isUser ? Navigator.push(context, MaterialPageRoute(builder:(context)=>Room(fromForum: true,article: _post, user:widget.user, isAnswer: isAnswer, isComment: isComment, answer:answer, answerTo: answerTo, answerType:answerType)))
        : OverlayScreen().show(context, identifier: 'login');
    //Navigator.push(context, MaterialPageRoute(builder:(context)=>ToConnect(fromForum: true,post: _post, isArticle:true, )));
  }

   */
  GetRoom(Post _post) {
    return Navigator.push(context, MaterialPageRoute(builder:(context)=>Room(fromForum: true,article: _post, user:widget.user)));
  }
  getDate(articles) {
    DateTime dateTime = DateTime.parse(articles);
    DateTime now = new DateTime.now();

    if((dateTime.day == now.day)&&(dateTime.month == now.month)){
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

}