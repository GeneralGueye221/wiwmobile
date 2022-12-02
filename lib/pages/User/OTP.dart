import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wiwmedia_wiwsport_v3/model/post.dart';
import 'package:wiwmedia_wiwsport_v3/model/user.dart';

import '../HomePage.dart';
import 'Room.dart';

class OTP extends StatefulWidget {
  //final String phone;
  //final String pseudo;
  final Utilisateur user;
  final Post post;
  final String code;
  final bool forRoom;
  final bool fromForum;
  const OTP({Key key, this.code, this.user, this.post, this.forRoom, this.fromForum}) : super(key: key);

  @override
  _OTPState createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<ScaffoldState> globalkey = new GlobalKey<ScaffoldState>();
  final _pinPutController = TextEditingController();
  final _pinPutFocusNode = FocusNode();
  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: const Color.fromRGBO(43, 46, 66, 1),
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: const Color.fromRGBO(126, 203, 224, 1),
    ),
  );

  SharedPreferences preferences;
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
  void initState()  {
    // TODO: implement initState
    super.initState();
    verifyPhone();
    initializePreference();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalkey,
      appBar: AppBar(
        title: Container(
          child: Text('Vérification du numéro'),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(40),
            child: Center(
              child: Text(
                  "Veuillez saisir le code qui sera envoyé par sms au ${widget.code} ${widget.user.numberphone}",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.normal
                ),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(30.0),
              child: PinPut(
                fieldsCount: 6,
                withCursor: true,
                textStyle: const TextStyle(fontSize: 25.0, color: Colors.white),
                eachFieldWidth: 40.0,
                eachFieldHeight: 55.0,
                //onSubmit: (String pin) => _showSnackBar(pin),
                focusNode: _pinPutFocusNode,
                controller: _pinPutController,
                submittedFieldDecoration: pinPutDecoration,
                selectedFieldDecoration: pinPutDecoration,
                followingFieldDecoration: pinPutDecoration,
                pinAnimationType: PinAnimationType.fade,
                onSubmit: (pin) async {
                  try {
                    await FirebaseAuth.instance
                        .signInWithCredential(PhoneAuthProvider.credential(verificationId: smsCode, smsCode: pin))
                        .then((val) async {
                      if(val.user != null) {
                        String _store = jsonEncode(widget.user.toJson());
                        await this.preferences.setString('user', _store).whenComplete(() async => await retrieveUser());
                        await _firestore.collection('Users')
                            .doc('${widget.user.id}')
                            .set({
                          'uuid': widget.user.id,
                          'pseudo': widget.user.pseudo,
                          'phone': widget.user.numberphone,
                          'pp':"",
                          'type': 'connexion via phone',
                        });
                        if(widget.forRoom) return Navigator.push(context, MaterialPageRoute(builder: (context)=> Room(user: widget.user, article: widget.post, fromForum: widget.fromForum,)));
                        else return Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage(isUser: true,user: widget.user)));
                        print(">>>>>>>>>>>>>>>> USER PASS VALID <<<<<<<<<<<<<<<<<<<");
                      }
                    });
                  } catch(err){
                    final snackbar = SnackBar(
                      backgroundColor: Colors.redAccent,
                      content: Text("Code OTP invalide !"),
                      duration: Duration(seconds: 2),
                    );
                    globalkey.currentState.showSnackBar(snackbar);
                  }
                },
              ),
          )
        ],
      ),
    );
  }
  //FONCTIONS
  String error="";
  String smsCode="";
  verifyPhone () async  {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "${widget.code}${widget.user.numberphone}",
      timeout: Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) {
        logIn(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        error = error+e.message;
        print("ERROR CONNECTION ----------------------------->$error");
      },
      codeSent: (String verificationId, int resendToken) {
        setState(() {
          smsCode = verificationId;
        });
        //PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
        //logIn(credential);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          smsCode = verificationId;
        });
      },
    );
  }

  logOut() {
    FirebaseAuth.instance.signOut();
  }

  logIn(AuthCredential authCredential) {

    FirebaseAuth.instance.signInWithCredential(authCredential)
    .then((value)async {
      if(value.user != null) {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> Room(user: widget.user, article: widget.post,)));
        return widget.forRoom ? Navigator.push(context, MaterialPageRoute(builder: (context)=> Room(user: widget.user, article:widget.post)))
            : Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage(isUser:true, user: widget.user)));
        print(">>>>>>>>>>>>>>>> USER CONNECTED <<<<<<<<<<<<<<<<<<<");
      }
    });
  }
}
