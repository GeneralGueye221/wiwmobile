import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wiwmedia_wiwsport_v3/model/user.dart';
import 'package:wiwmedia_wiwsport_v3/pages/User/Connexion.dart';
import 'package:wiwmedia_wiwsport_v3/pages/User/Room.dart';

class CurrentUser extends ChangeNotifier{
  String _uid;
  String _email;
  String _numberphoneID;
  String username;

  String get getUid => _uid;
  String get getEmeil => _email;

  //INSTANCE FIREBASE
  FirebaseAuth _auth = FirebaseAuth.instance;
  static final FacebookLogin facebookSignIn = new FacebookLogin();

  //INSCRIPTION
  Future<String> signUpByMail(String mail, String pwd) async {
    var reVal="error";
    try {
      UserCredential _userCred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: mail,
          password: pwd
      );
      if(_userCred.user != null) {
        reVal = "success";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      reVal = e;
      print(e);
    }

    return reVal;
  }

  //CONNEXION
  Future<String> signInByMail(String mail, String pwd) async {
    String reVal="error";
    try {
      UserCredential _userCred = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: mail,
          password: pwd
      );
      if(_userCred.user != null) {
        _uid = _userCred.user.uid;
        _email = _userCred.user.email;
        reVal = "success";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      reVal = "$e";
      print(e);
    }

    return reVal;
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<String> signInByGoogle() async {
    String reVal="error";
    GoogleSignIn _googleAccount = GoogleSignIn(
      scopes: ['email', 'https://www.googleapis.com/auth/contacts.readonly']
    );
    try {
      GoogleSignInAccount _googleUser = await _googleAccount.signIn();
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(idToken: _googleAuth.idToken, accessToken: _googleAuth.accessToken);
      UserCredential _userCred = await _auth.signInWithCredential(credential);
      if(_userCred.user != null) {
        _uid = _userCred.user.uid;
        _email = _userCred.user.email;
        //_numberphone = _userCred.user.phoneNumber;
        reVal = "success";
      }
    }  catch (e) {
      reVal = "$e";
      print("GOOGLE ERROR -->"+e);
    }

    return reVal;
  }

  Future<String> signInByPhone(String numberphone) async {
    String error = "error -";
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+221$numberphone",
      verificationCompleted: (PhoneAuthCredential credential) {

      },
      verificationFailed: (FirebaseAuthException e) {
        error = error+e.message;
        print("ERROR CONNECTION ----------------------------->$error");
      },
      codeSent: (String verificationId, int resendToken) {
        String smsCode = 'xxxx';
        PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
        logIn(credential);

        username = "user"+numberphone.substring(4,6);
        _numberphoneID = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _numberphoneID = verificationId;
      },
    );
    return (_numberphoneID==null) ? error : _numberphoneID ;
  }

  Future SignInByFacebook() async {
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);
    return result;
  }


  //FONCTIONS
  handleAuth(Utilisateur user) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
            if(snapshot.hasData){
              return Room(user: user);
            }
            else {
              return Connexion();
            }
        },
    );
  }

  logOut() {
    FirebaseAuth.instance.signOut();
  }

  logIn(AuthCredential authCredential) {
    FirebaseAuth.instance.signInWithCredential(authCredential);
  }
}