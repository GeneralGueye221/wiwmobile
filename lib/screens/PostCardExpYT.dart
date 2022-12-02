import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:wiwmedia_wiwsport_v3/reusable/players/youtube.dart';

import 'package:cached_network_image/cached_network_image.dart';


class PostCardExpYT extends StatefulWidget {
  final String VideoItemId;
  final  VideoItemDate;
  final String VideoItemTitle;
  final String VideoItemLink;

  PostCardExpYT({@required this.VideoItemId, this.VideoItemDate, this.VideoItemTitle,this.VideoItemLink});

  @override
  _PostCardExpYTState createState() => _PostCardExpYTState();
}


class _PostCardExpYTState extends State<PostCardExpYT> {
  @override
  Widget build(BuildContext context) {
    String title = widget.VideoItemTitle;
    String id = widget.VideoItemId;
    var _ifame = '<iframe title=$title width="500" height="281" src="https://www.youtube.com/embed/$id?feature=oembed" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen=""></iframe>';
    print('_Page IFRAME: $_ifame');
    return Padding(
      padding:const EdgeInsets.only(left: 0, right: 0, top: 15, bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 11, right: 9),
            child: Text(title,
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Roboto")),
          ),
          SizedBox(height: 7),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              InkWell(
                onTap: () async {},
                child: Padding(
                  padding: EdgeInsets.only(left: 11),
                  child: Text("Youtube",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: null,
                        fontFamily: "Arial",
                        color: Colors.grey,
                      )),
                ),
              ),
              //getDate(VideoItemDate),
              SizedBox(height: 11),
            ],
          ),
          SizedBox(height: 11),
          Card(
            child: Column(
              children: <Widget>[
                setView(widget.VideoItemId),
                //HtmlWidget(_ifame, webView: true),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: SvgPicture.asset("assets/icons/partager.svg",
                        height: 15, width: 20),
                    onPressed: () => Share.share(widget.VideoItemLink),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
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