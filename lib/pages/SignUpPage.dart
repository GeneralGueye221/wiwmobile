import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'LoginPage.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: ListView(
                padding: EdgeInsets.all(20.0),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      BackButton(),
                    ],
                  ),
                  SignUpForm(),
                ],
              )
          )
        ],
      ),
    );
  }
}
///////////////////////////////////////////////    FORMS   ///////////////////////////////////////////////
class SignUpForm extends StatefulWidget {
  const SignUpForm({Key key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  List<Step> steps = [
    Step(
      title: const Text('Identifiant'),
      content: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(hintText: "nom"),
            keyboardType: TextInputType.name,
          ),
          SizedBox(height:20.0),
          TextFormField(
            decoration: InputDecoration(hintText: "prenom"),
            keyboardType: TextInputType.name,
          ),
          SizedBox(height:20.0),
          TextFormField(
            decoration: InputDecoration(hintText: "numérode telephone"),
            keyboardType: TextInputType.numberWithOptions(),
          ),
          SizedBox(height:20.0),
          TextFormField(
            decoration: InputDecoration(hintText: "email"),
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height:20.0),
        ],
      ),
    ),
    Step(
      title: const Text('Pseudo'),
      content: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(hintText: "nom utilisateur"),
          ),
          SizedBox(height:20.0),
        ],
      ),
    ),
    Step(
       title: const Text('Mot de passe'),
      //subtitle: const Text("Error!"),
      content: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(hintText: "mot de passe"),
            keyboardType: TextInputType.visiblePassword,
          ),
          SizedBox(height:20.0),
          TextFormField(
            decoration: InputDecoration(hintText: "comfirmer mot de passe"),
            keyboardType: TextInputType.visiblePassword,
          ),
          SizedBox(height:20.0),
        ],
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Create an account'),
        ),
        body: Column(children: <Widget>[
          Expanded(
            child: Stepper(
              steps: steps,
            ),
          ),
        ]));
  }
}
