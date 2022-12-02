import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:wiwmedia_wiwsport_v3/pages/User/Room.dart';
import 'package:wiwmedia_wiwsport_v3/services/current_user.dart';

class Registration extends StatefulWidget {
  const Registration({Key key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final globalKey = GlobalKey<ScaffoldState>();

  //CONTROLLERS
 TextEditingController _usernameController = new TextEditingController();
 TextEditingController _numberphoneController = new TextEditingController();
 TextEditingController _emailController = new TextEditingController();
 TextEditingController _passwordController = new TextEditingController();
 TextEditingController _passwordConfirmController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.withOpacity(0.5),
      resizeToAvoidBottomInset: false,
      key: globalKey,
      body: SingleChildScrollView(
        child: Container(
          height: 600,
          padding: EdgeInsets.all(30.0),
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
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
                      child: Text(
                        "Inscription",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      hintText: "Entrer votre email... ",
                      border: const OutlineInputBorder()
                  ),
                  keyboardType: TextInputType.emailAddress,
                  //onChanged: (val) => _email=val,
                  validator: (value) =>
                  value.isEmpty ? "il faut remplir ce champs" : null,
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _numberphoneController,
                  decoration: InputDecoration(
                      hintText: "Numero de téléphone... ",
                      border: const OutlineInputBorder()
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                  value.isEmpty ? "il faut remplir ce champs" : null,
                  //onChanged: (val) => _email=val,
                ),
                SizedBox(height: 15),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                      hintText: "mot de passe...",
                      border: const OutlineInputBorder()
                  ),
                  obscureText: true,
                  autocorrect: false,
                  //onChanged: (val) => _password = val,
                ),
                SizedBox(height: 15),
                TextField(
                  controller: _passwordConfirmController,
                  decoration: InputDecoration(
                      hintText: "confirmez le mot de passe...",
                      border: const OutlineInputBorder()
                  ),
                  obscureText: true,
                  autocorrect: false,
                  //onChanged: (val) => _password = val,
                ),
                SizedBox(height: 30),
                RaisedButton(
                  onPressed: () {
                    if(_passwordController.text==_passwordConfirmController.text){
                      signUpUserByMail(_emailController.text, _passwordController.text, context);
                    } else {
                      final snackBar = SnackBar(
                        backgroundColor: Colors.redAccent,
                        content: Text("les mots de passe entrés ne conrrespondent pas !"),
                        duration: Duration(seconds: 2),
                      );
                      globalKey.currentState.showSnackBar(snackBar);
                    }
                  },
                  child: Center(
                    child: Text(
                        "S'inscrire",
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
                )

              ],
            ),
          ),
        )
      )
    );
  }
  //FONCTIONS
  void signUpUserByMail(String email, String pwd, BuildContext ctxt) async{
    CurrentUser _currentUser = Provider.of<CurrentUser>(ctxt, listen: false);
    try {
      String res = await _currentUser.signUpByMail(email, pwd);
      if(res == "success") {
        Navigator.pop(ctxt);
        Navigator.push(ctxt, MaterialPageRoute(builder: (ctxt)=>Room()));
      }
      else {
        final snackBar = SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(res),
          duration: Duration(seconds: 2),
        );
        globalKey.currentState.showSnackBar(snackBar);
      }
    } catch(e) {
      print("ERROR ON SIGN UP: $e");
    }
  }
}
