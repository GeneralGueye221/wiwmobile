import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wiwmedia_wiwsport_v3/model/user.dart';
import 'package:wiwmedia_wiwsport_v3/pages/HomePage.dart';
import 'package:wiwmedia_wiwsport_v3/pages/User/AccountSetting.dart';

class AccountPage extends StatefulWidget {
  final Utilisateur user;

  AccountPage({Key key, this.user}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: Colors.black,),
          onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage(isUser: true, user: widget.user,))),
        ),
        title: Text("         Mon compte", style: TextStyle(color: Colors.black),)
      ),
      body: Column(
        children: [
          _info(widget.user.pseudo, widget.user.pp, widget.user.email),
          _menu()
        ],
      ),
    );
  }

  Widget _info(String username, String photo, String email) {
    return Container(
      padding: EdgeInsets.all(11.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.topLeft,
              height: 77,
              width: 77,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: widget.user.pp == null ? AssetImage("assets/images/person.png") : NetworkImage(widget.user.pp),
                      fit: widget.user.pp == null ? BoxFit.cover:BoxFit.fill
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(100))
              ),
            ),
            SizedBox(height: 10),
            Text(widget.user.pseudo == null? "" : widget.user.pseudo, style:TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(widget.user.email == null? "" : widget.user.email, style:TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 30)
          ],
        ),
      ),
    );
  }

  Widget _menu() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(),
        /*
        ListTile(
          title: Text(
            "modifier mes informations",
            style: TextStyle(color: Colors.teal),
          ),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>UserSettings(user:widget.user))),
        ),
        Divider(),

         */
        ListTile(
          title: Text(
              "se déconnecter",
            style: TextStyle(color: Colors.redAccent),
          ),
          onTap: () {
             removeUser();
             var dec = removeUser();
             Navigator.pop(context);
             Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage(isUser: false,)));
             print("USER DELETED -> $dec");
            //Navigator.of(context).popUntil((route) => route.isFirst);
          }
        ),
        Divider()
      ],
    );
  }
  Future<bool> removeUser() async{
    SharedPreferences preferences  = await SharedPreferences.getInstance();
    return preferences.remove("user");
  }
}
