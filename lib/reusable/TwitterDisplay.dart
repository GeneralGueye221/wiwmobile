import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:tweet_webview/tweet_webview.dart';

class TwitterDisplay extends StatefulWidget {
  final  tweet_id;
  final String title;
  final String link;
  final DateTime date;

  final String usr_img;
  final String usr_name;
  final String usr_scrname;

  TwitterDisplay({ @required this.tweet_id, this.title, this.link, this.date, this.usr_img, this.usr_name, this.usr_scrname});
  @override
  _TwitterDisplayState createState() => _TwitterDisplayState();
}

class _TwitterDisplayState extends State<TwitterDisplay> {
  String id ;
  bool fade =false;

  @override
  void initState() {
    id = widget.tweet_id;
    super.initState();
    Future.delayed(
      Duration(seconds: 3),
        () {
            fade = true;
        }
    );
    setState(() { });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Card(
          child: Column(
            children: <Widget>[
              SizedBox(height: 11),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                    onTap: () async {},
                    child: Padding(
                      padding: EdgeInsets.only(left: 11),
                      child: Text("Twitter",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: null,
                            fontFamily: "Arial",
                            color: Colors.grey,
                          )),
                    ),
                  ),
                  getDate(),
                ],
              ),
              SizedBox(height: 5),
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 2000),
                firstChild: _result(),
                secondChild: _loader(),
                crossFadeState:
                fade ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                firstCurve: const Interval(0.0, 0.3, curve: Curves.fastOutSlowIn),
                secondCurve: const Interval(0.7, 1.0, curve: Curves.fastOutSlowIn),
                sizeCurve: Curves.fastOutSlowIn,
              ),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: SvgPicture.asset("assets/icons/partager.svg",
                      height: 21, width: 27),
                  onPressed: () => Share.share(widget.link),
                ),
              ),
            ],
          ),
        ),
      ],
    );
      //AnimatedCrossFade(firstChild: _loader(), secondChild: _result(), crossFadeState: _crossFadeState, duration: Duration(seconds: 3));
  }

  Widget _loader () {
    return Container(
        child: Image.asset('assets/reloading.gif')
    );
  }

  Widget _result () {
    return Container(child: TweetWebView.tweetID(id));
  }


  //FONSTIONS
  getDate() {
    if(widget.date!=null){
      DateTime dateTime = widget.date;
      DateTime now = new DateTime.now();

      if(dateTime.day == now.day){
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
    else {
      return Container();
    }
  }
}
