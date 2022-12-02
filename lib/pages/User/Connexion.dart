import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:overlay_screen/overlay_screen.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


import 'package:wiwmedia_wiwsport_v3/model/post.dart';
import 'package:wiwmedia_wiwsport_v3/model/user.dart';
import 'package:wiwmedia_wiwsport_v3/pages/HomePage.dart';
import 'package:wiwmedia_wiwsport_v3/pages/User/OTP.dart';
import 'package:wiwmedia_wiwsport_v3/pages/User/Registration.dart';
import 'package:wiwmedia_wiwsport_v3/services/current_user.dart';

import 'Room.dart';


enum LoginType {
  email,
  google,
  facebook,
  phone
}

class Connexion extends StatefulWidget {
  final Post post;
  final Utilisateur user;
  final bool isArticle;
  final bool fromForum;
  const Connexion({Key key, this.fromForum, this.post, this.user, this.isArticle}) : super(key: key);

  @override
  _ConnexionState createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion> {
  final globalKey = GlobalKey<ScaffoldState>();
  static final FacebookLogin facebookSignIn = new FacebookLogin();

  //CONTROLLERS
  TextEditingController _numberphoneController = new TextEditingController();
  TextEditingController _pseudoController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  String _phoneNo;
  String _username;
  Utilisateur _user = Utilisateur(numberphone: "",pseudo: "", id: "");
  List<Utilisateur> _users = [];
  bool isUser = false;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isError =false;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          //height: 300,
          padding: EdgeInsets.all(20.0),
          child: Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow:  [
                  BoxShadow(
                      color: Colors.grey,
                      blurRadius: 10.0,
                      spreadRadius: 1.0,
                      offset: Offset(4.0,4.0)
                  ),
                ]
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        iconSize: 24,
                        color: Colors.black,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
                      child: Text("     "),
                    ),
                  ],
                ),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        height: 33,
                        child: IntrinsicWidth(child: _indicatif(),),
                      ),
                      //SizedBox(width: 25),
                      Container(
                        width: 150,
                        child: TextField(
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.phone_rounded),
                              hintText: "numéro ...",
                              //border: const OutlineInputBorder()
                          ),
                          controller: _numberphoneController,
                          keyboardType: TextInputType.number,
                          autocorrect: false,
                          onChanged: (val) {
                           if(val.length>=7){
                             checkUsers(val);
                             print("-------------------------------------------->taille numero = ${val.length}");
                           }
                          }
                        ),
                      )
                    ],
                  ),
                ),

                SizedBox(height: 15),

                _numberphoneController.text.length>=9 && isUser == false
                    ?TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: "nom d'utilisateur... ",
                      border: const OutlineInputBorder()

                  ),
                  controller: _pseudoController,
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                ) : Container(),
                SizedBox(height: 10),
                isError
                    ?Container(
                  child: Text(
                      "Informations entrées non valides ! Veuillez recommencer",style: TextStyle(color:Colors.redAccent),
                  ),
                ): Container(),
                SizedBox(height: 30),
                RaisedButton(
                  onPressed: () async {
                    if(_numberphoneController.text.length<9 || _pseudoController.text.length<3 ){
                      setState(() {
                        isError = true;
                      });
                    }
                    else {
                      if(isUser==false) {
                        setState(() {
                          _user.pseudo=_pseudoController.text;
                          _user.numberphone=_numberphoneController.text;
                          _user.id="id${indicatif}${_numberphoneController.text}";
                          isError = false;
                        });
                        /*
                        await _firestore.collection('Users')
                            .doc('${_user.id}')
                            .set({
                          'uuid': _user.id,
                          'pseudo': _user.pseudo,
                          'phone': _user.numberphone,
                          'pp':"",
                          'type': 'connexion via phone',
                        });
                        */
                      }
                      print("UTILISATEUR: PSEUDO-> ${_user.pseudo} id->${_user.id} N°-> ${indicatif} ${_user.numberphone} ");
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>OTP(user:_user, post: widget.post, code: indicatif,forRoom: widget.isArticle==null?false:widget.isArticle,fromForum: widget.fromForum,))) ;
                    }
                  },
                  child: Center(
                    child: Text(
                        "Suivant",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        )
                    ),
                  ),
                  color: Colors.teal,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)
                  ),
                ),
                SizedBox(height: 20),
                _buttonGoogle(context),
                _buttonFacebook()
              ],
            ),
          ),
        ),
      ),
    );
  }

  String indicatif = "+221";
  Widget _indicatif () {
    return Container(
      height: 30,
      width: 111,
      child: CountryListPick(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: Text('Choisir un pays'),
          ),
          // if you need custome picker use this
          pickerBuilder: (context, CountryCode countryCode){
            return Container(
              width: 77,
              decoration: BoxDecoration(
                border: Border.all(color:Colors.grey),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Row(
                children: [
                  //Image.asset(countryCode.flagUri,package: 'country_list_pick'),
                  //Text(countryCode.code),
                  Icon(Icons.arrow_drop_down,color: Colors.blueGrey,),
                  Text(countryCode.dialCode, style: TextStyle(fontSize: 17, color: Colors.grey)),
                ],
              )
            );
          },

          // To disable option set to false
          theme: CountryTheme(
            isShowFlag: true,
            isShowTitle: true,
            isShowCode: true,
            isDownIcon: true,
            showEnglishName: true,
          ),
          // Set default value
          initialSelection: indicatif,
          onChanged: (CountryCode code) {
            setState(()=>indicatif=code.dialCode);
            //print(">>>>>>>>>>>>>>> name : ${code.name}");
            //print(">>>>>>>>>>>>>>> code : ${indicatif}");
            print(code.dialCode);
            print(code.flagUri);
          },
          // Whether to allow the widget to set a custom UI overlay
          useUiOverlay: true,
          // Whether the country list should be wrapped in a SafeArea
          useSafeArea: false
      ),
    );
}
  Widget _buttonGoogle (_context) {
    return OutlineButton(
      onPressed: () {
        loginUser(type: LoginType.google, context: _context);
      },
      splashColor: Colors.grey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
      highlightElevation: 0,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset("assets/images/logo_gg.png", height: 20),
          //SizedBox(width: 10),
          Padding(
            padding: EdgeInsets.only(left:10),
            child: Text(
              "se connecter avec Google",
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey
              ),
            ),
          )
        ],
      ),
    );
  }
  Widget _buttonFacebook () {
    return OutlineButton(
      onPressed: null,
      splashColor: Colors.grey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
      highlightElevation: 0,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset("assets/images/logo_fb.png", height: 25),
          Padding(
            padding: EdgeInsets.only(left:10),
            child: Text(
              "se connecter avec Facebook",
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey
              ),
            ),
          )
        ],
      ),
    );
  }

  //FONCTIONS
  checkUsers(number) async {
    //print('------------------------------------------------------------->checking users list !!!');
    await _firestore.collection('Users').doc('id${indicatif}${number}')
      .get().then((doc) {
        if(!doc.exists){
          setState(() {
            isUser = false;
          });
          //print('------------------------------------------------------------->user id${indicatif}${number} not in the Database !!!');
        }
        else {
          setState(() {
            isUser = true;
            _user.numberphone=doc.get('phone');
            //_numberphoneController.text=doc.get('phone');
            _pseudoController.text = doc.get('pseudo');
            _user.id=doc.get('uuid');
            _user.pseudo=doc.get('pseudo');
          });
          //print('------------------------------------------------------------->user ${_user.pseudo} in the Database !!!');
        }
    });
  }

  loginUser(
      {LoginType type,
      String email,
      String password,
      String phone,
      String username,
      BuildContext context}) async {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    String res = "";
    try {
      switch(type){
        case LoginType.email:
          /*
          res = await _currentUser.signInByMail(email, password);
          if(res == "success") {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context)=> Room(mail: _currentUser.getEmeil)));
          } else {
            final snackBar = SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text(res),
              duration: Duration(seconds: 2),
            );
            globalKey.currentState.showSnackBar(snackBar);
          }
           */
          break;
        case LoginType.google:
          var userCred = await _currentUser.signInWithGoogle();
          if(userCred != null){
            print('------------------------------------------------------------------');
            print('USERNAME CONNECTED WITH GOOGLE ---->${userCred.user.displayName}');
            print('USER ACCOUNT CONNECTED WITH GOOGLE ---->${userCred.user.email}');
            print('-------------------------------------------------------------------');
            Navigator.pop(context);
            widget.isArticle == null ? Navigator.push(context, MaterialPageRoute(builder :(context)=> HomePage(isUser: true, user:_user)))
                : widget.isArticle ? Navigator.push(context, MaterialPageRoute(builder: (context)=> Room(fromForum: widget.fromForum,user:_user, article:widget.post)))
                : Navigator.push(context, MaterialPageRoute(builder :(context)=> HomePage(isUser: true, user:_user)));
          }
          break;
        case LoginType.phone:
          /*
          String res = await _currentUser.signInByPhone(phone);
          if((widget.pseudo.length>3)){
            return Future.delayed(Duration(seconds: 2), ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=> Room(fromForum: widget.fromForum,user:_user, article: widget.post,))));
          }
          else {
            final snackBar = SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text("une erreur est survenu($res)! veuillez recommencer."),
              duration: Duration(seconds: 2),
            );
            Future.delayed(Duration(seconds: 2), ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=> Room(mail: widget.pseudo, article: widget.post,))));
          }
           */
          break;
        case LoginType.facebook:
          var result = await _currentUser.SignInByFacebook();
          switch (result.status) {
            case FacebookLoginStatus.loggedIn:
              final FacebookAccessToken accessToken = result.accessToken;
              final graphResponse = await http.get(
                  'https://graph.facebook.com/v2.12/me?fields=name,picture,last_name,email&access_token=${accessToken.token}');
              final profile = jsonDecode(graphResponse.body);
              print('''
                     Logged in!
                     
                     Token: ${accessToken.token}
                     User id: ${accessToken.userId}
                     Expires: ${accessToken.expires}
                     Permissions: ${accessToken.permissions}
                     Declined permissions: ${accessToken.declinedPermissions}
             ''');
              Navigator.pop(context);
              widget.isArticle == null ? Navigator.push(context, MaterialPageRoute(builder :(context)=> HomePage(isUser: true, user:_user,)))
                  : widget.isArticle ? Navigator.push(context, MaterialPageRoute(builder: (context)=> Room(fromForum: widget.fromForum,user:_user, article:widget.post)))
                  : Navigator.push(context, MaterialPageRoute(builder :(context)=> HomePage(isUser: true, user:_user,)));
              break;
            case FacebookLoginStatus.cancelledByUser:
              print('FACEBOOK ERROR --------- Login cancelled by the user.');
              break;
            case FacebookLoginStatus.error:
              print('FACEBOOK ERROR --------- Something went wrong with the login process.\n'
                  'Here\'s the error Facebook gave us: ${result.errorMessage}');
              break;
          }
          break;
      }


    } catch(e) {
      print("ERROR ON SIGN IN: $e");
    }
  }

}


class ToConnect extends StatefulWidget {
  final Post post;
  final bool isArticle;
  final bool fromForum;
  const ToConnect({Key key, this.post, this.isArticle, this.fromForum}) : super(key: key);

  @override
  _ToConnectState createState() => _ToConnectState();
}

class _ToConnectState extends State<ToConnect> {
  final globalKey = GlobalKey<ScaffoldState>();
  static final FacebookLogin facebookSignIn = new FacebookLogin();


  //CONTROLLERS
  TextEditingController _numberphoneController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  String _phoneNo;
  String _username;
  SharedPreferences preferences;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializePreference();
  }
  Future<void> initializePreference() async{
    this.preferences = await SharedPreferences.getInstance();
  }
  Future retrieveUser() async {
    String _resultStore = this.preferences.getString("user");
    Map<String,dynamic> decoded = jsonDecode(_resultStore);
    var user = Utilisateur(id: Utilisateur.fromJSON(decoded).id, email: Utilisateur.fromJSON(decoded).email, pp: Utilisateur.fromJSON(decoded).pp, pseudo: Utilisateur.fromJSON(decoded).pseudo, numberphone: Utilisateur.fromJSON(decoded).numberphone);
    print("USER STORED SUCESSFULLY -> id:${user.id} pseudo:${user.pseudo}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        //height: 300,
        padding: EdgeInsets.all(20.0),
        child: Container(
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow:  [
                BoxShadow(
                    color: Colors.grey,
                    blurRadius: 10.0,
                    spreadRadius: 1.0,
                    offset: Offset(4.0,4.0)
                ),
              ]
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
                child: Row(
                  children: [
                    Container(
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () => OverlayScreen().pop(),
                        color: Colors.black,
                      ),
                    ),
                    Center(
                      child: Text(
                        "     Se connecter",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                        textAlign: TextAlign.center,
                      )
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              _buttonNumberPhone(context),
              _buttonGoogle(context),
              _buttonFacebook(context)
            ],
          ),
        ),
      ),
    );
  }

  //FONCTIONS
  loginUser(
      {LoginType type,
        String email,
        String password,
        String phone,
        String username,
        BuildContext context}) async {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    String res = "";
    try {
      switch(type){
        case LoginType.phone:
          //Navigator.pop(context);
          widget.isArticle ==null||widget.isArticle ? Navigator.push(context, MaterialPageRoute(builder: (context)=>Connexion(post: widget.post, isArticle:true)))
                : Navigator.push(context, MaterialPageRoute(builder: (context)=>Connexion(fromForum: widget.fromForum,post: widget.post, isArticle:false)));

          break;
        case LoginType.facebook:
          var result = await _currentUser.SignInByFacebook();
          switch (result.status) {
            case FacebookLoginStatus.loggedIn:
              final FacebookAccessToken accessToken = result.accessToken;
              final graphResponse = await http.get(
                  'https://graph.facebook.com/v2.12/me?fields=name,picture,last_name,email&access_token=${accessToken.token}');
              final profile = jsonDecode(graphResponse.body);
              print('''
                     Logged in!
                     
                     Token: ${accessToken.token}
                     User id: ${accessToken.userId}
                     Expires: ${accessToken.expires}
                     Permissions: ${accessToken.permissions}
                     Declined permissions: ${accessToken.declinedPermissions}
             ''');
              Utilisateur _user = Utilisateur(id:accessToken.userId, pseudo:profile['name'],email:profile['email'],pp: profile['picture']['data']['url']);
              String _store = jsonEncode(_user.toJson());
              await this.preferences.setString('user', _store).whenComplete(() async => await retrieveUser());

              OverlayScreen().pop();
              Navigator.pop(context);
              widget.isArticle == null ? Navigator.push(context, MaterialPageRoute(builder :(context)=> HomePage(isUser: true, user:_user,)))
                  : widget.isArticle ? Navigator.push(context, MaterialPageRoute(builder: (context)=> Room(fromForum: widget.fromForum,user:_user, article:widget.post)))
                  : Navigator.push(context, MaterialPageRoute(builder :(context)=> HomePage(isUser: true, user:_user,)));
              break;
            case FacebookLoginStatus.cancelledByUser:
              print('FACEBOOK ERROR --------- Login cancelled by the user.');
              break;
            case FacebookLoginStatus.error:
              print('FACEBOOK ERROR --------- Something went wrong with the login process.\n'
                  'Here\'s the error Facebook gave us: ${result.errorMessage}');
              break;
          }
          break;
        case LoginType.google:
          var userCred = await _currentUser.signInWithGoogle();
          if(userCred != null){
            print('------------------------------------------------------------------');
            print('USERNAME CONNECTED WITH GOOGLE ---->${userCred.user.displayName}');
            print('USER ACCOUNT CONNECTED WITH GOOGLE ---->${userCred.user.email}');
            print('-------------------------------------------------------------------');
            Utilisateur _user = Utilisateur(id:userCred.user.uid, numberphone: userCred.user.phoneNumber, pseudo:userCred.user.displayName,email:userCred.user.email,pp: userCred.user.photoURL);
            String _store = jsonEncode(_user.toJson());
            await this.preferences.setString('user', _store).whenComplete(() async => await retrieveUser());


            OverlayScreen().pop();
            widget.isArticle == null ? Navigator.push(context, MaterialPageRoute(builder :(context)=> HomePage(isUser: true, user:_user)))
                : widget.isArticle ? Navigator.push(context, MaterialPageRoute(builder: (context)=> Room(fromForum: widget.fromForum,user:_user, article:widget.post)))
                : Navigator.push(context, MaterialPageRoute(builder :(context)=> HomePage(isUser: true, user:_user)));
            }
          break;
      }

    } catch(e) {
      print("ERROR ON SIGN IN: $e");
    }

  }

  Widget _buttonGoogle (_context) {
    return OutlineButton(
      onPressed: () {
        //Future.delayed(Duration(seconds: 7), ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=> Room(mail: _username, article: widget.post,))));
        loginUser(type: LoginType.google, context: _context);
      },
      splashColor: Colors.grey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
      highlightElevation: 0,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset("assets/images/logo_gg.png", height: 20),
          //SizedBox(width: 10),
          Padding(
            padding: EdgeInsets.only(left:10),
            child: Text(
              "se connecter avec Google    ",
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey
              ),
            ),
          )
        ],
      ),
    );
  }
  Widget _buttonFacebook (BuildContext _context) {
    return OutlineButton(
      onPressed: () {
        //Future.delayed(Duration(seconds: 7), ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=> Room(mail: _username, article: widget.post,))));
        loginUser(type: LoginType.facebook, context: _context);
      },
      splashColor: Colors.grey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
      highlightElevation: 0,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset("assets/images/logo_fb.png", height: 20),
          //SizedBox(width: 10),
          Padding(
            padding: EdgeInsets.only(left:10),
            child: Text(
              "se connecter avec Facebook",
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey
              ),
            ),
          )
        ],
      ),
    );
  }
  Widget _buttonNumberPhone (_context) {
    return OutlineButton(
      onPressed: () {
        OverlayScreen().pop();
        loginUser(type: LoginType.phone, context: _context);
      },
      splashColor: Colors.grey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
      highlightElevation: 0,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.phone),
          Padding(
            padding: EdgeInsets.only(left:10),
            child: Text(
              "utiliser votre numéro de tél.",
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey
              ),
            ),
          )
        ],
      ),
    );
  }
}
