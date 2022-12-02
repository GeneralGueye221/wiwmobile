import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:wiwmedia_wiwsport_v3/model/user.dart';
import 'package:wiwmedia_wiwsport_v3/pages/User/AccountPage.dart';

class UserSettings extends StatefulWidget {
  Utilisateur user;

  UserSettings({Key key, this.user}) : super(key: key);

  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,color: Colors.black,),
            onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>AccountPage(user: widget.user,))),
          ),
          title: Text("Modifier mon compte", style: TextStyle(color: Colors.black))
      ),
      body: Column(
        children: [
          SizedBox(height: 30),
          Container(
            padding: EdgeInsets.only(left: 21),
            alignment: Alignment.topLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Mes identifiants de connexion", style: TextStyle(
                    fontFamily: "DINNextLTPro-MediumCond",
                    fontSize: 17,
                    fontWeight: FontWeight.bold)),
                SizedBox(height: 30),
                Stack(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      height: 77,
                      width: 77,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: widget.user.pp == null ? AssetImage("assets/images/person.png") : NetworkImage(widget.user.pp),
                            fit: BoxFit.fill
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(100))
                        ),
                      ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(top:21.0),
                      child: Center(
                        child: InkWell(
                          child: Text(
                            "Changer ma photo",
                            style: TextStyle(color: Colors.teal),
                          ),
                        )
                      ),
                    )
                  ],
                ),
                SizedBox(height: 15)
              ],
            ),
          ),
          Divider(thickness:2),
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.only(left: 21),
            alignment: Alignment.topLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("pseudonyme", style: TextStyle(
                    color: Colors.black54,
                    fontFamily: "DINNextLTPro-MediumCond",
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
                Padding(
                    padding: EdgeInsets.only(top:11.0, left: 13),
                    child: Text(widget.user.pseudo, style: TextStyle(
                        color: Colors.black,
                        fontFamily: "DINNextLTPro-MediumCond",
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 15)
              ],
            ),
          ),
          Divider(thickness:2),
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.only(left: 21),
            alignment: Alignment.topLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("email", style: TextStyle(
                    color: Colors.black54,
                    fontFamily: "DINNextLTPro-MediumCond",
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
                Padding(
                  padding: EdgeInsets.only(top:11.0, left: 13),
                  child: widget.user.email!=null
                      ? Text(widget.user.email, style: TextStyle(
                      color: Colors.black,
                      fontFamily: "DINNextLTPro-MediumCond",
                      fontSize: 15,
                      fontWeight: FontWeight.bold))
                      :TextField(
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.phone_rounded),
                          hintText: "entrer votre email... ",
                          border: const OutlineInputBorder()
                      ),
                      keyboardType: TextInputType.phone,
                      autocorrect: false,
                      onChanged: (val) {setState(() {
                        widget.user.email=val;
                      });
                      }
                  ),
                ),
                SizedBox(height: 15)
              ],
            ),
          ),
          Divider(thickness:2),
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.only(left: 21),
            alignment: Alignment.topLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("numéro de téléphone", style: TextStyle(
                    color: Colors.black54,
                    fontFamily: "DINNextLTPro-MediumCond",
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
                Padding(
                  padding: EdgeInsets.only(top:11.0, left: 13),
                  child: widget.user.numberphone!=null
                      ? Text(widget.user.numberphone, style: TextStyle(
                      color: Colors.black,
                      fontFamily: "DINNextLTPro-MediumCond",
                      fontSize: 15,
                      fontWeight: FontWeight.bold))
                      :TextField(
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.phone_rounded),
                          hintText: "entrer votre numero de téléphone... ",
                          border: const OutlineInputBorder()
                      ),
                      keyboardType: TextInputType.phone,
                      autocorrect: false,
                      onChanged: (val) {setState(() {
                        widget.user.email=val;
                      });
                      }
                  ),
                ),
                SizedBox(height: 15)
              ],
            ),
          ),
          Divider(thickness:2),
          SizedBox(height: 15),

        ],
      ),
    );
  }
}
