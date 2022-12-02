
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share/share.dart';
import 'package:wiwmedia_wiwsport_v3/model/user.dart';
import 'package:wiwmedia_wiwsport_v3/pages/User/Room.dart';
import 'package:wiwmedia_wiwsport_v3/screens/details_page.dart';
import 'package:wiwmedia_wiwsport_v3/model/post.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final bool isConnect;
  final Utilisateur user;
  //final String pp;
  //final String email;

  PostCard({@required this.post, this.isConnect, this.user});

  getImage(context){
    if(post.image == null){
      return Image.asset("assets/bug_img.jpeg");
    }
    else{
      if(post.content.contains("jeg_video_container")|| post.title.toLowerCase().contains('vidéo')){
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              child: FadeInImage.assetNetwork(
                placeholder: '',
                image: post.image,
                fit: BoxFit.fill,
              ),
            ),
            Center(
              child: Align(
                alignment: Alignment.center,
                child: IconButton(
                  icon: Image.asset("assets/icons/icon_player.png", height: 100, width:150),
                  color: Colors.transparent,
                  iconSize: 77,
                ),
              ),
            ),
          ],
        );
      }
      else {
        return Container(
          width: MediaQuery.of(context).size.width,
          child: FadeInImage.assetNetwork(
            placeholder: 'assets/reloading.gif',
            image: post.image,
            fit: BoxFit.fill,
          ),
        );
      }
    }
  }

  getDate() {
    DateTime dateTime = DateTime.parse(post.date);
    DateTime now = new DateTime.now();

    if(dateTime.day == now.day && dateTime.month== now.month && dateTime.year==now.year){
      String date = " · "+DateFormat("HH").format(dateTime)+'h'+DateFormat("mm").format(dateTime);
       return Text(date, style: TextStyle(
        fontSize: 13,
        fontWeight: null,
        fontFamily: "DINNextLTPro-MediumCond",
        color: Colors.black45,
      ));
    }
    else {
      String date = " · "+DateFormat("dd").format(dateTime)+'/'+DateFormat("MM").format(dateTime);
      return Text(date, style: TextStyle(
        fontSize: 13,
        fontWeight: null,
        fontFamily: "DINNextLTPro-MediumCond",
        color: Colors.black45,
      ));
    }
  }

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    String title = post.title;
    String subtitle;
    if(post.title.toString().length<50){
      subtitle = post.title;
    } else {
      subtitle = post.title.substring(0, 50);
    }

    String category = post.category;
    return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                settings: RouteSettings(name: subtitle+" ..."),
                builder: (BuildContext context) {
                  return isConnect ==null ? DetailsPage(post:this.post)
                      : isConnect ? DetailsPage(post:this.post, isConnect: this.isConnect, user: this.user,)
                        : DetailsPage(post:this.post);
                },
                fullscreenDialog: true),
          );
        },
        //child: Card(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 0, right: 0, top: 15, bottom: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 11, right:11),
                child: Text(title,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Roboto")),
              ),
              SizedBox(height: 3),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                    onTap: () async {},
                    child: Padding(
                      padding: EdgeInsets.only(left: 11, right:11),
                      child: Text(category,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: null,
                            fontFamily: "Arial",
                            color: Color(0xFF339966),
                          )),
                    ),
                  ),
                  getDate(),
                ],
              ),
              SizedBox(height: 10),
              getImage(context),
              footer(context)
            ],
          ),
        ));

    //);
  }

  Widget footer(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        height: 33,
        alignment: Alignment.topRight,
        child: Wrap(
            spacing: -10,
            children: <Widget>[
              IntrinsicWidth(
                child: InkWell(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder:(context)=>Room(fromHome:true,fromForum: false, article: post, user:user, isAnswer: false, isComment: false, answer:"", answerTo: "", answerType:""))),
                  child: StreamBuilder(
                    stream: _firestore
                        .collection('room-'+post.id.toString())
                        .snapshots(),
                    builder: (context, snapshot){
                      if (!snapshot.hasData) return Container(
                        padding: EdgeInsets.all(13.0),
                        child: Image.asset(
                          'assets/gifs/green_style.gif', height: 15, width: 15,),
                      );
                      return Container(
                        margin: EdgeInsets.only(top: 13),
                        child: Row(
                          children: [
                            Text(
                              "${snapshot.data.size}",
                              style: TextStyle(color:Colors.blueGrey,)
                            ),
                            SizedBox(width: 3),
                            Icon(Icons.chat, size: 23, color: Colors.teal,),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(width: 15),
              IconButton(
                icon: SvgPicture.asset("assets/icons/partager.svg",
                    height: 15, width: 20),
                onPressed: () => Share.share(post.link),
              ),
              Container(
               padding: EdgeInsets.only(top:17, right: 11),
                child: InkWell(
                  child: Text("Partager", style: TextStyle(
                    fontSize: 13,
                    fontWeight: null,
                    fontFamily: "DINNextLTPro-MediumCond",
                    color: Colors.black45,
                  )),
                  onTap: () => Share.share(post.link),
                )
              )
            ]
        ),
      ),
    );
  }
}
