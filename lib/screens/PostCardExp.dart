
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:wiwmedia_wiwsport_v3/model/post.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import 'package:wiwmedia_wiwsport_v3/model/user.dart';
import 'package:wiwmedia_wiwsport_v3/reusable/players/twitter.dart';
import 'package:wiwmedia_wiwsport_v3/reusable/players/youtube.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'details_page.dart';
import 'notification_page.dart';

class PostCardExp extends StatefulWidget {
  final Post post;
  String type;
  final String content;
  final String title;
  final String link;
  final String slug;
  final String date;
  final Utilisateur user;


  PostCardExp({@required this.user, this.post, this.type, this.content, this.title, this.slug, this.link, this.date});
  @override
  _PostCardExpState createState() => _PostCardExpState();
}

class _PostCardExpState extends State<PostCardExp> {
  FormatDate(date) {
    //Wed Mar 24 2021 20:11:05 GMT+0000
    //to
    //2014–08–25T22:27:38.000
    var composant = date.toString().split(' ');
    var mois = composant[1];
    //print("mois ---> $mois");
    var jour = composant[2];
    //print("jour ---> $jour");
    var annee = composant[3];
    //print("annee ---> $annee");
    var heure = composant[4];
    //print("heure ---> $heure");
    if(mois == "Jan") {mois = "01";}
    else if(mois == "Feb") {mois = "02";}
    else if(mois == "Mar") {mois = "03";}
    else if(mois == "Apr") {mois = "04";}
    else if(mois == "May") {mois = "05";}
    else if(mois == "Jun") {mois = "06";}
    else if(mois == "Jul") {mois = "07";}
    else if(mois == "Aug") {mois = "08";}
    else if(mois == "Sep") {mois = "09";}
    else if(mois == "Oct") {mois = "10";}
    else if(mois == "Nov") {mois = "11";}
    else if(mois == "Dec") {mois = "12";}

    var newDate = annee+"-"+mois+"-"+jour+"T"+heure;
    //console.log();
    return newDate;

  }

  getDate() {
    //DateTime dateTime = DateTime.parse(FormatDate(date));
    DateTime now = new DateTime.now();
    //var timestamp = int.parse(date);
    //var _date = new DateTime.fromMicrosecondsSinceEpoch(timestamp);

    return Text(widget.date.toString());
  }

  goToArticle(BuildContext context, String slug) {
    return Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NotificationPage(
        post: null,
        link: slug,
        isExplorer: true,
        user: widget.user,
      );
    }));
  }

  bool show_off = false;
  setContent(String content) {

    if(content.contains("instagram-media")) {
      widget.type = "Instagram";
      String  tag  = "<blockquote";
      String end_tag = "</blockquote>";
      int startIndex = content.indexOf(tag);
      int endIndex = content.indexOf(end_tag)+end_tag.length;
      String _blockquote = content.substring(startIndex, endIndex);

      return Container();
      //SocialEmbed(socialMediaObj: FacebookVideoEmbedData(embedHtml: _blockquote));
    }
    if(content.contains("jeg_video_container")) {
      setState(()=>show_off=false);
      widget.type  =  "Youtube";
      String  tag  = "<iframe";
      String end_tag = "</iframe>";
      int startIndex = content.indexOf(tag);
      int endIndex = content.indexOf(end_tag)+end_tag.length;
      String _iframe = content.substring(startIndex, endIndex);
      print("---------------->iframe : $_iframe");
      String debut_src = "/embed/";
      int index_debut_src = _iframe.indexOf(debut_src)+debut_src.length;
      String fin_src ="?feature";
      String fin_src2 ="?start";
      int index_fin_src = _iframe.indexOf(fin_src);
      int index_fin_src2 = _iframe.indexOf(fin_src2);
      if(index_fin_src != -1) {
        String src = _iframe.substring(index_debut_src, index_fin_src);
        return setView(src);
      }
      else if(index_fin_src2 != -1) {
        String src = _iframe.substring(index_debut_src, index_fin_src2);
        return setView(src);
        //print("ID YOUTUBE -> $src");
      }
      else {
        return Text(_iframe);
      }
    }
    if(content.contains("video.php")) {
      widget.type = "Facebook";
      String  tag  = "<iframe";
      String end_tag = "</iframe>";
      int startIndex = content.indexOf(tag);
      int endIndex = content.indexOf(end_tag)+end_tag.length;
      String _iframe = content.substring(startIndex, endIndex);

      return Container();
    }
    else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell (
        onTap: () {},
        child: Padding(
          padding:const EdgeInsets.only(left: 0, right: 0, top: 15, bottom: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
          widget.type == "Facebook" || widget.type == "Instagram" ? Container(height: 0, width: 0) : Padding(
                padding: EdgeInsets.only(left: 11, right:11),
                child:  Text(widget.title,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Roboto")),
              ),
              SizedBox(height: 11),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  widget.type == "Facebook" || widget.type == "Instagram" ? Container(height: 0, width: 0) : InkWell(
                    onTap: () async {},
                    child: Padding(
                      padding: EdgeInsets.only(left: 11, right:11),
                      child: Text(widget.type,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: null,
                            fontFamily: "Arial",
                            color: Colors.grey,
                          )),
                    ),
                  ),
                  //getDate(),
                  SizedBox(height: 11),
                ],
              ),
              SizedBox(height: 11),
              widget.type == "Facebook" || widget.type == "Instagram" ? Container(height: 0, width: 0) : Column(
                children: <Widget>[
                  setContent(widget.content),
                  Container(
                    alignment: Alignment.topRight,
                    child: Wrap(
                      // to apply margin in the cross axis of the wrap
                        spacing: -10,
                        children: <Widget>[
                          IconButton(
                            icon: SvgPicture.asset("assets/icons/article.svg",
                                height: 20, width: 25),
                            onPressed: () => goToArticle(context, widget.slug),
                          ),
                          IconButton(
                            icon: SvgPicture.asset("assets/icons/partager.svg",
                                height: 15, width: 20),
                            onPressed: () => Share.share(widget.link),
                          ),
                        ]
                    ),
                  )
                ],
              ),
            ],
          ),
        )
    );
  }

  bool isVisible = true;
  Widget setView(id) {
    return isVisible ? _img(id) : _video(id);
  }

  Widget _img(String id){
    var icon = SvgPicture.asset("assets/playerYt.svg");
    print("=================================================================>id: $id");
    var img = CachedNetworkImage(
      imageUrl: "https://img.youtube.com/vi/$id/maxresdefault.jpg",
      placeholder: (context,url) => AspectRatio(
        aspectRatio: 16/9,
      ),
      //errorWidget: (context,url,error) => Image.network("https://img.youtube.com/vi/$id/hqdefault.jpg"),

      errorWidget: (context,url,error) => CachedNetworkImage(
        imageUrl: "https://img.youtube.com/vi/$id/hqdefault.jpg",
        placeholder: (context,url) => AspectRatio(
          aspectRatio: 16/9,
        ),
        errorWidget: (context,url,error) => Image.network("https://img.youtube.com/vi/$id/sddefault.jpg"),
      ),

    );
    
    return InkWell(
      onTap: (){
        setState(() {
          isVisible = false;
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          img,
          Center(
            child: Align (
              alignment: Alignment.bottomCenter,
              child: IconButton(
                icon: icon,
                iconSize: 77,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _video(String id) {
    return YoutubePlayers(id: id);
  }

}