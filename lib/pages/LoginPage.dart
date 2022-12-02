import 'package:flutter/material.dart';

import 'SignUpPage.dart';

class Login extends StatelessWidget {
  const Login({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
          child: LoginForm()
      ),
    );
  }
}
///////////////////////////////////////////////LOGIN FORM//////////////////////////////////////////////////

class LoginForm extends StatelessWidget {
  const LoginForm({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: Text(
              "Connexion",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
          TextFormField(
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.alternate_email),
                hintText: "pseudo ou email"
            ),
          ),
          SizedBox(height: 20),
          TextFormField(
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.verified_user_rounded),
                hintText: "mot de passe"
            ),
          ),
          SizedBox(height: 20),
          RaisedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 100),
              child: Text(
                  "Se connecter",
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
          SizedBox(height: 30),
          FlatButton(
            child: Text("vous n'avez pas de compte? cliquez pour s'inscrire"),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) {
                  return SignUp();
                })
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          )
        ],
      ),
    );
  }
}
