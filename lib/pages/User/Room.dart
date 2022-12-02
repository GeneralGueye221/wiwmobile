import 'dart:async';
import 'dart:io';
import 'dart:io' as io;

import 'package:admob_flutter/admob_flutter.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:overlay_screen/overlay_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wiwmedia_wiwsport_v3/model/post.dart';
import 'package:wiwmedia_wiwsport_v3/model/user.dart';

import 'package:wiwmedia_wiwsport_v3/model/post.dart';
import 'package:wiwmedia_wiwsport_v3/model/user.dart';
import 'package:wiwmedia_wiwsport_v3/pages/ForumPage.dart';
import 'package:wiwmedia_wiwsport_v3/screens/details_page.dart';
import 'package:wiwmedia_wiwsport_v3/screens/notification_page.dart';

import '../HomePage.dart';
import 'Connexion.dart';
//import 'Connexion.dart';

class Room extends StatefulWidget {
  //final String mail;
  //final String email;
  //final String pp;
  Utilisateur user;
  //final int phone;
  final Post article;
  final bool isAnswer;
  bool fromForum;
  bool fromHome;
  final bool isComment;
  final String answer;
  final String answerTo;
  final String answerType;
  Room(
      {this.fromHome,
      this.user,
      this.fromForum,
      this.article,
      this.isComment,
      this.isAnswer,
      this.answer,
      this.answerTo,
      this.answerType});

  @override
  _RoomState createState() => _RoomState();
}

class _RoomState extends State<Room> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  bool _isPlaying;
  bool _isUploading;
  bool _isRecorded;
  bool _isRecording;

  bool _isSending = false;
  String sendType = "";
  String sendContent = "";

  bool _isAnswer = false;
  String answerType = "";
  String answerContent = "";
  String answerTo = "";

  String _filePath = "";
  FlutterAudioRecorder _audioRecorder;
  final assetsAudioPlayer = AssetsAudioPlayer();
  final audio_onpress = Audio("assets/audios/audio-602.mp3");
  final audio_onrealase = Audio("assets/audios/audio-603.mp3");
  final audio_onerror = Audio("assets/audios/audio-604.mp3");

  AudioPlayer _audioPlayer = AudioPlayer();
  List<bool> isplayings = [];
  Timer timer;
  int cpt = 0;

  bool isWritting = false;

  bool _showAppbar = false;
  bool isScrollingDown = false;
  int taille_comment = 0;

  Timer _timer;
  Timer _timerError;
  bool iserrorvocal = false;

  _RoomState() {
    messageController.addListener(() {
      if (messageController.text.isEmpty) {
        setState(() {
          isWritting = false;
        });
      } else {
        setState(() {
          isWritting = true;
        });
      }

      if (_height < 50)
        return setState(() {
          _height = 50;
        });
      setState(() {
        _presentSize = messageController.text.length;
      });
      if (messageController.text.length >= 0 &&
          messageController.text.length < 31)
        return setState(() {
          _height = 50;
        });
      else if (messageController.text.length >= 31 &&
          messageController.text.length < 66)
        return setState(() {
          _height = 75;
        });
      else if (messageController.text.length >= 66 &&
          messageController.text.length < 97)
        return setState(() {
          _height = 100;
        });
      else if (messageController.text.length >= 97 &&
          messageController.text.length < 132)
        return setState(() {
          _height = 125;
        });
      else if (messageController.text.length >= 132 &&
          messageController.text.length < 173)
        return setState(() {
          _height = 150;
        });
      else if (messageController.text.length >= 173 &&
          messageController.text.length < 194)
        return setState(() {
          _height = 175;
        });
      else if (messageController.text.length >= 194 &&
          messageController.text.length < 225)
        return setState(() {
          _height = 200;
        });
      else if (messageController.text.length >= 225 &&
          messageController.text.length < 256)
        return setState(() {
          _height = 225;
        });
      else if (messageController.text.length >= 256 &&
          messageController.text.length < 287)
        return setState(() {
          _height = 250;
        });
      else if (messageController.text.length >= 287 &&
          messageController.text.length < 318)
        return setState(() {
          _height = 275;
        });
      else if (messageController.text.length >= 318 &&
          messageController.text.length < 349)
        return setState(() {
          _height = 300;
        });
      //else if(messageController.text.length>=318&&messageController.text.length<380) return setState(() {_height=325;});
      //else return setState(()=>_height=(messageController.text.length/31).toInt()*50);
    });
  }

  @override
  Widget build(BuildContext context) {
    OverlayScreen().saveScreens({
      'login': CustomOverlayScreen(
        backgroundColor: Colors.teal.withOpacity(0.5),
        content: ToConnect(
          isArticle: true,
          fromForum: widget.fromForum,
          post: widget.article,
        ),
      ),
      'report': CustomOverlayScreen(
        backgroundColor: Colors.teal.withOpacity(0.5),
        content: reported(),
      ),
    });
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            AnimatedContainer(
                height: _showAppbar ? 56.0 : 0.0, //56 -> 107
                duration: Duration(milliseconds: 200),
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppBar(
                      backgroundColor: Colors.white,
                      leading: IconButton(
                        icon: Icon(Icons.close_sharp),
                        color: Colors.black,
                        onPressed: () {
                          widget.fromForum
                              ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Salon(
                                      isUser: widget.user == null
                                          ? false
                                          : true,
                                      user: widget.user)))
                              : widget.fromHome
                              ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage(
                                    isUser: widget.user == null
                                        ? false
                                        : true,
                                    user: widget.user,
                                  )))
                              : Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      NotificationPage(
                                          link: widget.article.slug,
                                          fromRoom: true,
                                          isExplorer: false,
                                          user: widget.user)));
                        },
                      ),
                      title: InkWell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundImage:
                              NetworkImage(widget.article.image),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 7, top: 11),
                              child: Text(
                                widget.article.title.length <= 17
                                    ? widget.article.title
                                    : widget.article.title.substring(0, 19) +
                                    "...",
                                textAlign: TextAlign.left,
                                style: new TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NotificationPage(
                                    fromRoom: true,
                                    user: widget.user,
                                    link: widget.article.slug,
                                    post: widget.article))),
                      ),
                      actions: <Widget>[
                        IconButton(
                          icon: Icon(Icons.ios_share),
                          color: Colors.black,
                          onPressed: () {
                            Share.share(widget.article.link, subject: "");
                          },
                        )
                      ],
                    )
                  ],
                )),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('room-' + widget.article.id.toString())
                    .orderBy('date')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: Image.asset(
                        'assets/gifs/green_style.gif',
                        height: 25,
                        width: 25,
                      ),
                    );
                  List<DocumentSnapshot> docs = snapshot.data.docs;

                  if (tampon != snapshot.data.docs.length) {
                    Timer(
                        Duration(seconds: 1),
                            () => scrollController.animateTo(
                          scrollController.position.maxScrollExtent + 100,
                          duration: Duration(seconds: 1),
                          curve: Curves.fastOutSlowIn,
                        ));
                    tampon = snapshot.data.docs.length;
                  }

                  for (int i = 0; i < snapshot.data.docs.length; i++) {
                    isplayings.add(false);
                  }

                  return snapshot.data.docs.length == 0
                      ? _Header(context, widget.article)
                      : ListView.builder(
                    controller: scrollController,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      var doc = docs[index];
                      print(
                          "--------------------------------------------------->index $index : from -> ${doc['from']}  date -> ${doc['date']}");
                      if (widget.user != null) {
                        if (doc['uid'] == widget.user.id) {
                          widget.user.pseudo = doc['from'];
                        }
                      }
                      if (index == 0) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _Header(context, widget.article),
                            SizedBox(height: 15),
                            Center(
                              //padding: EdgeInsets.all(5),
                              child: AdmobBanner(
                                adUnitId:
                                'ca-app-pub-9120523919163473/2499635678',
                                adSize: AdmobBannerSize.LARGE_BANNER,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            setFirstDate(
                                doc['date'] == null ? '' : doc['date']),
                            SizedBox(height: 30),
                            Dismissible(
                              key: UniqueKey(),
                              movementDuration: Duration(milliseconds: 5),
                              child: _Message(
                                  id: doc.id,
                                  from: doc['from'],
                                  uid: doc['uid'],
                                  pp: doc['pp'],
                                  answerTo: doc['answerTo'],
                                  content: doc['content'],
                                  date: doc['date'],
                                  answer: doc['answer'],
                                  answerType: doc['answerType'],
                                  type: doc['type'],
                                  timing: doc['duration'],
                                  me: widget.user == null
                                      ? false
                                      : widget.user.id == doc['uid'],
                                  index: index),
                              onDismissed: (direction) {
                                if (widget.user != null) {
                                  setState(() {
                                    answerType = doc['type'];
                                    answerContent = doc['content'];
                                    answerTo = doc['from'];
                                    _isAnswer = true;
                                    print(
                                        '----------| answer -> $answerContent type->$answerType to-> $answerTo');
                                  });
                                } else {
                                  setState(() {
                                    answerType = "";
                                    answerContent = "";
                                    answerTo = "";
                                    _isAnswer = false;
                                  });
                                }
                              },
                            ),
                          ],
                        );
                      } else {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            setDate(doc['date'], docs[index - 1]['date']),
                            Dismissible(
                              key: UniqueKey(),
                              movementDuration: Duration(milliseconds: 5),
                              child: _Message(
                                  id: doc.id,
                                  from: doc['from'],
                                  uid: doc['uid'],
                                  pp: doc['pp'],
                                  answerTo: doc['answerTo'],
                                  content: doc['content'],
                                  date: doc['date'],
                                  answer: doc['answer'],
                                  answerType: doc['answerType'],
                                  type: doc['type'],
                                  timing: doc['duration'],
                                  me: widget.user == null
                                      ? false
                                      : widget.user.id == doc['uid'],
                                  index: index),
                              onDismissed: (direction) {
                                if (widget.user != null) {
                                  setState(() {
                                    answerType = doc['type'];
                                    answerContent = doc['content'];
                                    answerTo = doc['from'];
                                    _isAnswer = true;
                                    print(
                                        '----------| answer -> $answerContent type->$answerType to-> $answerTo');
                                  });
                                } else {
                                  setState(() {
                                    answerType = "";
                                    answerContent = "";
                                    answerTo = "";
                                    _isAnswer = false;
                                  });
                                }
                              },
                            ),
                            //(index==snapshot.data.docs.length-2 && showTampon)?_Tampon():Container(height: 7),
                          ],
                        );
                      }
                    },
                  );
                },
              ),
            ),
            (showTampon) ? _Tampon() : Container(height: 7),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _isAnswer
                    ? Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      setState(() {
                        answerType = "";
                        answerContent = "";
                        answerTo = "";
                        _isAnswer = false;
                      });
                    },
                    child: Container(
                      child: _AnswerTo(
                          user: widget.user.pseudo,
                          type: answerType,
                          content: answerContent),
                      width: MediaQuery.of(context).size.width,
                    ))
                    : Container(),
                _isRecording ? _VocalField() : _MessageField(),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _Header(BuildContext _context, Post _article) {
    return InkWell(
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(_context).size.width,
            height: 150,
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(_context).size.width,
                  child: Image.network(_article.image, fit: BoxFit.cover),
                ),
                Container(
                    width: MediaQuery.of(_context).size.width,
                    color: Colors.black.withOpacity(0.5)),
                InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationPage(
                              fromRoom: true,
                              user: widget.user,
                              link: widget.article.slug,
                              post: widget.article))),
                  child: Container(
                      alignment: Alignment.bottomCenter,
                      padding: EdgeInsets.only(left: 11, right: 9, bottom: 10),
                      child: IntrinsicHeight(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _article.title,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.white),
                            ),
                            Expanded(
                              child: StreamBuilder<QuerySnapshot>(
                                stream: _firestore
                                    .collection('room-${_article.id}')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData)
                                    return Center(
                                      child: Image.asset(
                                        'assets/gifs/green_style.gif',
                                        height: 25,
                                        width: 25,
                                      ),
                                    );
                                  return Row(
                                    children: [
                                      Icon(Icons.message_outlined,
                                          color: Colors.white, size: 15),
                                      SizedBox(width: 5),
                                      Text(
                                        snapshot.data.size > 1
                                            ? "${snapshot.data.size} commentaires"
                                            : "${snapshot.data.size} commentaire",
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      )),
                ),
              ],
            ),
          ),
          Align(
              alignment: Alignment.topRight,
              child: InkWell(
                  onTap: () => Share.share(widget.article.link, subject: ""),
                  child: Container(
                    padding: EdgeInsets.only(right: 15, top: 13),
                    child: Icon(
                      Icons.ios_share,
                      color: Colors.white,
                    ),
                  ))),
          SizedBox(width: 10),
          IconButton(
            icon: Icon(Icons.close),
            color: Colors.white,
            onPressed: () {
              widget.fromForum
                  ? Navigator.push(
                  _context,
                  MaterialPageRoute(
                      builder: (_context) => Salon(
                          isUser: widget.user == null ? false : true,
                          user: widget.user)))
                  : widget.fromHome
                  ? Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_context) => HomePage(
                        isUser: widget.user == null ? false : true,
                        user: widget.user,
                      )))
                  : Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_context) => NotificationPage(
                          link: widget.article.slug,
                          fromRoom: true,
                          isExplorer: false,
                          user: widget.user)));
            },
          ),
        ],
      ),
    );
  }

  int _height = 50;
  int _presentSize = 1;
  int _pastSize = 0;
  Widget _MessageField() {
    return IntrinsicHeight(
        child: Column(
          children: [
            iserrorvocal
                ? Bubble(
              color: Colors.redAccent,
              child: Text(
                'Faire un appui long pour enregistrer puis relâcher pour envoyer.',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            )
                : Container(),
            widget.isAnswer != null && widget.isAnswer
                ? Dismissible(
                key: UniqueKey(),
                onDismissed: (direction) {
                  setState(() {
                    _isAnswer = false;
                    answerContent = "";
                    answerType = "";
                    answerTo = "";
                  });
                },
                child: Container(
                  child: _AnswerTo(
                      user: widget.answerTo,
                      type: widget.answerType,
                      content: widget.answer),
                  width: MediaQuery.of(context).size.width,
                ))
                : Container(),
            widget.user == null
                ? OutlineButton(
              onPressed: () {
                return checkConnexion();
              },
              splashColor: Colors.grey,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0)),
              highlightElevation: 0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Text(
                      "se connecter pour laisser un commentaire",
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  )
                ],
              ),
            )
                : Container(
              padding: EdgeInsets.only(bottom: 5.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                        height: _height.toDouble(),
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          color: Colors.teal.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Container(
                            padding: EdgeInsets.only(left: 7),
                            //margin: EdgeInsets.all(7),
                            child: _isRecorded
                                ? Center(
                              child: Text("envoi en cours ...",
                                  style: TextStyle(
                                    color: Colors.grey,
                                  )),
                            )
                                : TextField(
                              //inputFormatters: [LengthLimitingTextInputFormatter(30)],f
                              maxLines: _presentSize <= 32 ? 1 : 11,
                              keyboardType: TextInputType.multiline,
                              onSubmitted: (value) => sendMessage(),
                              decoration: InputDecoration(
                                hintText: "écrire un commentaire...",
                                border: InputBorder.none,
                              ),
                              controller: messageController,
                              onChanged: (val) {
                                //print("********************Taille comment => ${val.length} and ex: $_pastSize");
                                //print("********************Hauteur comment => $_height");
                              },
                              autofocus: widget.isAnswer != null &&
                                  widget.isAnswer ||
                                  widget.isComment != null &&
                                      widget.isComment
                                  ? true
                                  : false,
                              enableSuggestions: true,
                            ))),
                  ),
                  SizedBox(width: 10),
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: isWritting
                        ? GestureDetector(
                      onTap: sendMessage,
                      child: _isUploading || _isSending
                          ? Center(
                        child: Image.asset(
                            'assets/gifs/green_style.gif',
                            height: 7,
                            width: 7),
                      )
                          : Icon(Icons.send, color: Colors.white),
                    )
                        : Listener(
                      onPointerDown: (details) async {
                        assetsAudioPlayer.open(audio_onpress);
                        _timer =
                        new Timer(const Duration(seconds: 1), () {
                          _onRecordButtonPressed();
                        });
                        _timerError =
                        new Timer(const Duration(seconds: 3), () {
                          //_onRecordButtonPressed();
                        });
                      },
                      onPointerUp: (details) {
                        if (_timer.isActive || _timerError.isActive) {
                          assetsAudioPlayer.open(audio_onerror);
                          _isRecording = false;
                          _audioRecorder.stop();
                          print(
                              "***************************************************ERROR ON SEND VOCAL");
                          _timer.cancel();
                          _onError();
                        } else {
                          assetsAudioPlayer.open(audio_onrealase);
                          //_onRecordButtonPressed();
                          Future.delayed(Duration(seconds: 1)).then((value) => _onRecordButtonPressed());
                        }
                      },
                      child: Icon(Icons.mic, color: Colors.white),
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }

  Widget _VocalField() {
    return IntrinsicHeight(
      //padding: EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          /*
          _isUploading
              ? Center(
            child: Image.asset(
              'assets/gifs/green_style.gif', height: 15, width: 15,),
          )
              : _isRecorded ? InkWell(
            onTap: () => _onPlayButtonPressed(),
            child: Icon( _isPlaying ? Icons.pause:Icons.play_arrow, color: Colors.black,),
          ) : InkWell(
            onTap: () => null,
            child: Icon( Icons.circle, color: Colors.redAccent,),
          ),
           */
          Expanded(
            child: Container(
                height: 50,
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Padding(
                    padding: EdgeInsets.all(7.0),
                    child: _isRecorded
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.replay),
                          onPressed: _onRecordAgainButtonPressed,
                        ),
                        IconButton(
                          icon: Icon(_isPlaying
                              ? Icons.pause
                              : Icons.play_arrow),
                          onPressed: _onPlayButtonPressed,
                        ),
                        IconButton(
                          icon: Icon(Icons.upload_file),
                          //onPressed: sendVocal,
                        ),
                      ],
                    )
                        : Text(
                      _isUploading
                          ? "envoi ..."
                          : "enregistrement vocal en cours ...",
                      style: TextStyle(color: Colors.black54),
                    ))),
          ),
          SizedBox(width: 10),
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.circular(100),
            ),
            child: GestureDetector(
              //onTap: _rec,
              child: Icon(
                  _isRecorded
                      ? _isSending
                      ? Center(
                    child: Image.asset('assets/gifs/green_style.gif',
                        height: 7, width: 7),
                  )
                      : Icons.send
                      : _isRecording
                      ? Icons.fiber_manual_record
                      : Icons.mic,
                  color: Colors.white),
            ),
          )
        ],
      ),
    );
  }


  Widget _AnswerTo({user, type, content}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      //color: Colors.teal.withOpacity(0.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 66,
            width: 10,
            color: Colors.teal,
          ),
          Container(
              height: 66,
              width: MediaQuery.of(context).size.width - 10.0,
              color: Colors.grey[100].withOpacity(0.5),
              padding: EdgeInsets.only(right: 50),
              child: Stack(
                children: [
                  type == "audio"
                      ? Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.all(9.0),
                          child: Column(
                            children: [
                              Container(
                                  padding: EdgeInsets.only(left: 9.0),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    answerTo,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  )),
                              Container(
                                  padding: EdgeInsets.only(left: 9.0),
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.mic,
                                        color: Colors.black,
                                      ),
                                      SizedBox(width: 7),
                                      Container(
                                        child: Text(
                                          "Audio",
                                          style: TextStyle(
                                            fontSize: 17,
                                          ),
                                        ),
                                      )
                                    ],
                                  ))
                            ],
                          ),
                        )
                      : Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.all(9.0),
                          child: Column(
                            children: [
                              Container(
                                  padding: EdgeInsets.only(left: 9.0),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    user,
                                    style: TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  )),
                              Container(
                                  padding: EdgeInsets.only(left: 9.0),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    content.length <= 27
                                        ? content
                                        : content.substring(0, 27) + "...",
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ))
                            ],
                          ),
                        )
                ],
              ))
        ],
      ),
    );
  }

  Widget reported() {
    return IntrinsicHeight(
      child: Center(
        child: Container(
          height: 200,
          width: 400,
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey,
                    blurRadius: 10.0,
                    spreadRadius: 1.0,
                    offset: Offset(4.0, 4.0)),
              ]),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
                child: Center(
                    child: Text(
                      "   WIWSPORT",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                      textAlign: TextAlign.center,
                    )),
              ),
              Text(
                "le commentaire a été signalé.",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 20.0,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 15),
              Divider(),
              SizedBox(height: 15),
              Container(
                child: InkWell(
                  child: Text("OK", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.lightBlueAccent),),
                  onTap: () => OverlayScreen().pop(),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }

  Widget _Message(
      {
      id,
      uid,
      from,
      pp,
      me,
      content,
      type,
      date,
      answer,
      answerTo,
      answerType,
      timing,
      index}) {
    return Column(
      crossAxisAlignment:
          me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: me ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            //me ? Icon(Icons.flag_outlined, color: Colors.redAccent,): Container(height: 0, width: 0),
            !(type == "audio")
                ? Bubble(
                margin: me
                  ? BubbleEdges.only(top: 10, left: 40)
                    : BubbleEdges.only(top: 10, right: 20),
                color: me ? Color.fromRGBO(225, 255, 199, 1.0) : Colors.white70,
                nip: me ? BubbleNip.rightTop : BubbleNip.leftTop,
                alignment: me ? Alignment.topRight : Alignment.topLeft,
                child: IntrinsicWidth(
                  child: IntrinsicWidth(
                      child: Column(
                        children: [
                          answer.length > 1
                              ? _answerTo(me, answer, answerTo, answerType)
                              : Container(width: 0, height: 0),
                          Row(
                            mainAxisAlignment: me
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  me || from == null
                                      ? Container(
                                    height: 0.0,
                                    width: 0,
                                  )
                                      : IntrinsicWidth(
                                      child: Text(from,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  Container(
                                    width: answer.length > 1 || content.length > 30
                                        ? 222
                                        : null,
                                    //padding: EdgeInsets.only(top:1, left:3),
                                    child: Text(content, textAlign: TextAlign.left),
                                  ),
                                ],
                              ),
                              SizedBox(width: 10),
                              getDateMessage(date)
                            ],
                          ),
                        ],
                      )),
                ))
                : Bubble(
                margin: BubbleEdges.only(top: 7),
                color: me ? Color.fromRGBO(225, 255, 199, 1.0) : Colors.white70,
                nip: me ? BubbleNip.rightTop : BubbleNip.leftTop,
                alignment: me ? Alignment.topRight : Alignment.topLeft,
                child: IntrinsicWidth(
                  child: IntrinsicWidth(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          answer.length > 1
                              ? _answerTo(me, answer, answerTo, answerType)
                              : Container(width: 0, height: 0),
                          SizedBox(height: 5, width: 0),
                          IntrinsicWidth(
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(from,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            )),
                          SizedBox(height: 5, width: 0),    
                          Row(
                            mainAxisAlignment: me
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    child: CircleAvatar(
                                      //backgroundColor: Colors.black,
                                      backgroundImage: pp == null
                                          ? AssetImage(isplayings[index]
                                          ? 'assets/audio_wave.gif'
                                          : 'assets/audio_wave.jpg')
                                          : NetworkImage(pp),
                                      //child: Image.asset(),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 10),
                              Container(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      onTap: () => getVocal(timing, content, index),
                                      child: content.length == 0
                                          ? Container(
                                          height: 15,
                                          width: 15,
                                          child: CircularProgressIndicator())
                                          : Icon(
                                          isplayings[index]
                                              ? Icons.pause
                                              : Icons.play_arrow,
                                          color: Colors.blueGrey,
                                          size: 33),
                                    ),
                                    !isplayings[index]
                                        ? Container(
                                      height: 1,
                                      width: 90,
                                      color: Colors.grey,
                                    )
                                        : Container(
                                        height: 30,
                                        width: 90,
                                        child: Image.asset(
                                          "assets/audio.gif",
                                          fit: BoxFit.fill,
                                        )),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              getDateMessage(date)
                            ],
                          ),
                        ],
                      )),
                )),
            me ? Container(height: 0, width: 0)
                :InkWell(
              onTap: () => widget.user == null ? checkConnexion() :report("$id", widget.article.title, widget.user.pseudo, from, widget.user.email == null ? widget.user.numberphone : widget.user.email, "$uid", type == "audio"? "audio": content, date),
              child: Icon(Icons.flag_outlined, color: Colors.grey ,size: 20),
            )
          ],
        )
      ],
    );
  }

  Widget _answerTo(me, answer, answerTo, answerType) {
    return Container(
      width: 270,
      child: Row(
        mainAxisAlignment: me ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            height: answerType == "audio" ? 65 : 60,
            width: 10,
            color: me ? Colors.teal : Colors.grey,
          ),
          Container(
              height: answerType == "audio" ? 65 : 60,
              width: 260,
              color: me
                  ? Colors.teal.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.3),
              padding: EdgeInsets.only(right: 50),
              child: Stack(
                children: [
                  answerType == "audio"
                      ? Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.all(9.0),
                          child: Column(
                            children: [
                              Container(
                                  padding: EdgeInsets.only(left: 9.0),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    answerTo.length > 25
                                        ? answerTo.substring(0, 25) + "..."
                                        : answerTo,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  )),
                              SizedBox(height: 5),
                              Container(
                                  padding: EdgeInsets.only(left: 9.0),
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.mic,
                                        color: Colors.black,
                                      ),
                                      SizedBox(width: 7),
                                      Container(
                                        child: Text(
                                          "Audio",
                                          style: TextStyle(
                                            fontSize: 9,
                                          ),
                                        ),
                                      )
                                    ],
                                  ))
                            ],
                          ),
                        )
                      : Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.all(9.0),
                          child: Column(
                            children: [
                              Container(
                                  //padding: EdgeInsets.only(left:9.0),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    answerTo.length >= 17
                                        ? answerTo.substring(0, 17) + "..."
                                        : answerTo,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  )),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                  //padding: EdgeInsets.only(left:9.0),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    answer.length >= 27
                                        ? answer.substring(0, 27) + "..."
                                        : answer,
                                    style: TextStyle(
                                      fontSize: 13,
                                    ),
                                  ))
                            ],
                          ),
                        )
                ],
              ))
        ],
      ),
    );
  }

  Widget _Tampon() {
    String date = DateTime.now().toString();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Bubble(
            margin: BubbleEdges.only(top: 7),
            color: Color.fromRGBO(225, 255, 199, 1.0),
            nip: BubbleNip.rightTop,
            alignment: Alignment.topRight,
            child: IntrinsicWidth(
              child: IntrinsicWidth(
                  child: Column(
                children: [
                  answerContent.length > 1
                      ? _answerTo(true, answerContent, answerTo, answerType)
                      : Container(width: 0, height: 0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        children: [
                          Container(
                            child: CircleAvatar(
                              //backgroundColor: Colors.black,
                              backgroundImage: widget.user.pp == null
                                  ? AssetImage('assets/audio_wave.jpg')
                                  : NetworkImage(widget.user.pp),
                              //child: Image.asset(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 15),
                      Container(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              child: Container(
                                height: 15,
                                width: 15,
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            Container(
                              height: 1,
                              width: 90,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                      SizedBox(width: 15),
                      getDateMessage(date)
                    ],
                  ),
                ],
              )),
            ))
      ],
    );
  }

  @override
  void initState() {
    _isPlaying = false;
    _isUploading = false;
    _isRecorded = false;
    _isRecording = false;

    if (widget.fromForum == null) {
      setState(() => widget.fromForum = false);
    }
    if (widget.fromHome == null) {
      setState(() => widget.fromHome = false);
    }
    if (!(widget.isAnswer == null)) {
      setState(() {
        _isAnswer = widget.isAnswer;
        answerTo = widget.answerTo;
        answerContent = widget.answer;
        answerType = widget.answerType;
      });
    }

    super.initState();

    scrollController = new ScrollController();
    scrollController.addListener(() {
     // print(
         // "-------------------------------------------------------------------Scroll Value:${scrollController.position.pixels}");
      if (scrollController.position.pixels >= 150) {
        setState(() => _showAppbar = true);
      } else {
        setState(() => _showAppbar = false);
      }
      /*
      if (scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          _showAppbar = false;
          setState(() {});
        }
      }
      if (scrollController.position.userScrollDirection == ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          _showAppbar = true;
          setState(() {});
        }
      }
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels == 0) {
          setState(() {
            _showAppbar = false;
          });
        }
      }
*/
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _timerError.cancel();
    scrollController.removeListener(() {});
    scrollController.dispose();
    super.dispose();
  }

  //FONCTIONS
  bool _buttonPressed = false;
  bool _loopActive = false;
  int numberMessage = 0;
  int numberUser = 0;
  int tampon = 0;
  bool isTampon = false;
  bool showTampon = false;

  Future<bool> removeUser() async{
    SharedPreferences preferences  = await SharedPreferences.getInstance();
    return preferences.remove("user");
  }

  Future<void> sendMessage() async {
    if(widget.user.pseudo.length>1){
      var date  =  DateTime.now().toUtc();
      if (messageController.text.length > 0) {
        await _firestore.collection('room-' + widget.article.id.toString()).add({
          'content': messageController.text,
          'type': 'text',
          'duration': 0,
          'from': widget.user.pseudo,
          'pp': widget.user.pp,
          'uid': widget.user.id,
          'answer': answerContent,
          //_isAnswer ?answerContent:"",
          'answerType': answerType,
          //_isAnswer? answerType: "",
          'answerTo': answerTo,
          //_isAnswer ? answerTo : "",
          'date': date.toIso8601String().toString(),
        });
        await FirebaseFirestore.instance
            .collection("Forum")
            .doc(widget.article.id.toString())
            .get()
            .then((DocumentSnapshot) {
          if (!DocumentSnapshot.exists) {
            users.add(widget.user.pseudo);
            users_id.add(widget.user.id);
            numberMessage = 1;
            numberUser = 1;
          } else {
            users = DocumentSnapshot.get('users');
            if (users.contains(widget.user.pseudo)) {
              numberUser = DocumentSnapshot.get('nbr_user');
            } else {
              numberUser = DocumentSnapshot.get('nbr_user') + 1;
            }
            users.add(widget.user.pseudo);
            users_id.add(widget.user.id);
            numberMessage = users.length;
          }
        });

        await _firestore
            .collection('Forum')
            .doc('${widget.article.id.toString()}')
            .set({
          'users': users,
          'users_id': users_id,
          'date': DateTime.now().toIso8601String().toString(),
          'type': 'text',
          'content': messageController.text,
          'nbr_message': numberMessage,
          'nbr_user': numberUser,
          'coef': numberMessage * numberUser,
          'article_id': widget.article.id.toString(),
          'article_titre': widget.article.title,
          'article_category': widget.article.category,
          'article_date': widget.article.date,
          'article_image': widget.article.image,
          'article_link': widget.article.link,
          'article_slug': widget.article.slug
        });
        messageController.clear();
        _isAnswer = false;
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        );
      }

      setState(() {
        _isAnswer = false;
        answerContent = "";
        answerTo = "";
        answerType = "";
      });
    } else {
      removeUser();
      var dec = removeUser();
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage(isUser: false,)));
      print("USER DELETED -> $dec");
    }
  }

  Future<void> sendVocal(int audioduration) async {
      if(widget.user.pseudo.length>1){
        FirebaseStorage firebaseStorage = FirebaseStorage.instance;
      String doc_ref = DateTime.now().toString();
      setState(() {
        _isUploading = true;
      });
      try {
        await _firestore
            .collection('room-' + widget.article.id.toString())
            .doc(doc_ref)
            .set({
          'content': '',
          'type': 'audio',
          'duration': 0,
          'from': widget.user.pseudo,
          'pp': widget.user.pp,
          'uid': widget.user.id,
          'answer': answerContent,
          //_isAnswer ?answerContent:"",
          'answerType': answerType,
          //_isAnswer? answerType:"",
          'answerTo': answerTo,
          //_isAnswer ? answerTo :"",
          'date': DateTime.now().toIso8601String().toString(),
        });

        var ref = await firebaseStorage.ref('upload-voice-firebase').child(
            _filePath.substring(_filePath.lastIndexOf('/'), _filePath.length));

        UploadTask uploadTask = ref.putFile(File(_filePath));
        var audiolink;

        uploadTask.then((res) {
          res.ref.getDownloadURL().then((value) async {
            setState(() {
              audiolink = value;
              //print(">>>>>>>>>>>>>>>>>>> AUDIO URI -> ${value}");
            });
            await _firestore
                .collection('room-' + widget.article.id.toString())
                .doc(doc_ref)
                .update({
              'content': audiolink,
              'duration': audioduration,
            });

            await FirebaseFirestore.instance
                .collection("Forum")
                .doc(widget.article.id.toString())
                .get()
                .then((DocumentSnapshot) {
              if (!DocumentSnapshot.exists) {
                users.add(widget.user.pseudo);
                users_id.add(widget.user.id);
                numberMessage = 1;
                numberUser = 1;
                print('USERS LIST* ---->${users}');
                print('USERS LEN* ---->${numberMessage}');
              } else {
                users = DocumentSnapshot.get('users');
                if (users.contains(widget.user.pseudo)) {
                  numberUser = DocumentSnapshot.get('nbr_user');
                } else {
                  numberUser = DocumentSnapshot.get('nbr_user') + 1;
                }
                users.add(widget.user.pseudo);
                users_id.add(widget.user.id);
                numberMessage = users.length;
                print('USERS LIST ---->${users}');
                print('USERS LEN ---->${numberMessage}');
              }
            });

            await _firestore
                .collection('Forum')
                .doc('${widget.article.id.toString()}')
                .set({
              'users': users,
              'users_id': users_id,
              'date': DateTime.now().toIso8601String().toString(),
              'type': 'audio',
              'content': "",
              'nbr_message': numberMessage,
              'nbr_user': numberUser,
              'coef': numberMessage * numberUser,
              'article_id': widget.article.id.toString(),
              'article_titre': widget.article.title,
              'article_category': widget.article.category,
              'article_date': widget.article.date,
              'article_image': widget.article.image,
              'article_link': widget.article.link,
              'article_slug': widget.article.slug
            });
          });
        });
      } catch (error) {
        print('Error occured while uplaoding to Firebase ${error.toString()}');
      } finally {
        setState(() {
          _isRecorded = false;
          _isUploading = false;
          _isAnswer = false;
          answerContent = "";
          answerType = "";
          answerTo = "";
        });
      }
    } else {
      removeUser();
      var dec = removeUser();
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage(isUser: false,)));
      print("USER DELETED -> $dec");
    }
  }

  Future<void> _onRecordButtonPressed() async {
    if (_isRecording) {
      int audioduration;
      _audioRecorder.stop().then((value) {
        setState(() {
          audioduration = value.duration.inSeconds;
        });
        sendVocal(audioduration);
      });
      _isRecording = false;
      _isRecorded = true;
      //await sendVocal();
    } else {
      _isRecorded = false;
      _isRecording = true;

      await _startRecording();
    }
    setState(() {});
  }

  Future<void> _startRecording() async {
    final bool hasRecordingPermission =
        await FlutterAudioRecorder.hasPermissions;
    if (hasRecordingPermission) {
      Directory directory = await getApplicationDocumentsDirectory();
      String filepath = directory.path +
          '/' +
          DateTime.now().millisecondsSinceEpoch.toString() +
          '.aac';
      _audioRecorder =
          FlutterAudioRecorder(filepath, audioFormat: AudioFormat.AAC);
      await _audioRecorder.initialized;
      _audioRecorder.start();
      _filePath = filepath;
      print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>FILE EXIST ===> $_filePath<<<<<<<<<');
      setState(() {});
    } else {
      print(
          '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Please enable recording permission<<<<<<<<<');
      /*Scaffold.of(context).showSnackBar(SnackBar(
        content: Center(
          child: Text('Please enable recording permission'),
        ),
      ));*/
    }
  }

  void _onRecordAgainButtonPressed() {
    setState(() {
      _isRecorded = false;
    });
  }

  void _onPlayButtonPressed() {
    /*
    if (!_isPlaying) {
      _isPlaying = true;

      _audioPlayer.play(_filePath, isLocal: true);
      _audioPlayer.onPlayerCompletion.listen((duration) {
        setState(() {
          _isPlaying = false;
        });
      });
    } else {
      _audioPlayer.pause();
      _isPlaying = false;
    }
    setState(() {});

     */
  }

  bool _onError() {
    setState(() => iserrorvocal = true);
    _timerError = new Timer(const Duration(seconds: 3), () {
      setState(() => iserrorvocal = false);
    });
  }

  checkConnexion() {
    if (widget.user == null) {
      OverlayScreen().show(
        context,
        identifier: 'login',
      );
    } else {
      sendMessage();
      print('USER CONNECTED !');
    }
  }

  void report(id, title, username, toUser, contact, toContact, com, date) async {
    //allow less secure app access  x

    String username = 'abdallahgueye221@gmail.com';
    String password = 'Dallah94';

    final smtpServer = gmail(username, password);

    String email_report = '''
        Bonjour,

        Le commentaire ci-dessous a été signalé par, $username - $contact, utilisateur de l’application wiwsport :
        - message : $id
        - salon : room-${widget.article.id}
        - $title
        - $toUser - $toContact
        - $com 
        - $date
        
        Merci de prendre les mesures nécessaires sur ce message et son auteur pour garantir le respect de la charte des commentaires aux publications wiwsport. 
        
        L’Equipe wiwsport
        www.wiwsport.com  
  ''';
    final message = Message()
      ..from = Address(username, 'Your name')
      ..recipients.add('contact@wiwsport.com')
      ..subject = 'wiwsport - Signalement commentaire $id'
      ..text = email_report;
      //..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
      //..bccRecipients.add(Address('bccAddress@example.com'))
      //..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";

    try {
      final sendReport = await send(message, smtpServer);
      print('Report sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('=================================================================>Problem in REPORT: ${p.code}: ${p.msg}');
      }
    }

    OverlayScreen().show(
      context,
      identifier: 'report',
    );
  }

  List users = [];
  List users_id = [];
  bool isUsers = false;

  setDate(String _date, String __date) {
    DateTime date = DateTime.parse(_date);
    DateTime date2 = DateTime.parse(__date);
    DateTime now = DateTime.now();
    if (date.day == date2.day &&
        date.month == date2.month &&
        date.year == date2.year) {
      return Container();
    } else {
      if (date.day == now.day &&
          date.month == now.month &&
          date.year == now.year) {
        return Container(
          padding: EdgeInsets.only(top: 7, bottom:7),
          child: Bubble(
            alignment: Alignment.center,
            color: Color.fromRGBO(212, 234, 244, 1.0),
            child: Text("Aujourd'hui",
                textAlign: TextAlign.center, style: TextStyle(fontSize: 11.0)),
          ),
        );
        return Bubble(
          alignment: Alignment.center,
          color: Color.fromRGBO(212, 234, 244, 1.0),
          child: Text("Aujourd'hui",
              textAlign: TextAlign.center, style: TextStyle(fontSize: 11.0)),
        );
      } else {
        if (date.isBefore(now)) {
          if (date.day == (now.day - 1) &&
              date.month == now.month &&
              date.year == now.year) {
            return Container(
              padding: EdgeInsets.only(top: 7, bottom:7),
              child: Bubble(
                alignment: Alignment.center,
                color: Color.fromRGBO(212, 234, 244, 1.0),
                child: Text("hier",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11.0)),
              ),
            );
            return Bubble(
              alignment: Alignment.center,
              color: Color.fromRGBO(212, 234, 244, 1.0),
              child: Text("hier",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11.0)),
            );
          } else if (date.day < (now.day - 1) &&
              date.day > (now.day - 7) &&
              date.month == now.month &&
              date.year == now.year) {
            return Container(
              padding: EdgeInsets.only(top: 7, bottom:7),
              child: Bubble(
                alignment: Alignment.center,
                color: Color.fromRGBO(212, 234, 244, 1.0),
                child: Text(setDay(date),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11.0)),
              ),
            );
            return Bubble(
              alignment: Alignment.center,
              color: Color.fromRGBO(212, 234, 244, 1.0),
              child: Text(setDay(date),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11.0)),
            );
          } else if ((date.day > (now.day - 7) &&
                  date.month == now.month &&
                  date.year == now.year) ||
              date.month != now.month ||
              date.year != now.year) {
            return Container(
              padding: EdgeInsets.only(top: 7, bottom:7),
              child: Bubble(
                alignment: Alignment.center,
                color: Color.fromRGBO(212, 234, 244, 1.0),
                child: Text(
                    "${setDay(date)}, ${date.day} ${setMonth(date)} ${date.year}",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11.0)),
              ),
            );
            return Bubble(
              alignment: Alignment.center,
              color: Color.fromRGBO(212, 234, 244, 1.0),
              child: Text(
                  "${setDay(date)}, ${date.day} ${setMonth(date)} ${date.year}",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11.0)),
            );
          } else
            return Container(
              padding: EdgeInsets.only(top: 7, bottom:7),
              child: Bubble(
                alignment: Alignment.center,
                color: Color.fromRGBO(212, 234, 244, 1.0),
                child: Text(
                    "${setDay(date)}, ${date.day} ${setMonth(date)} ${date.year}",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11.0)),
              ),
            );
            return Bubble(
              alignment: Alignment.center,
              color: Color.fromRGBO(212, 234, 244, 1.0),
              child: Text(
                  "${setDay(date)}, ${date.day} ${setMonth(date)} ${date.year}",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11.0)),
            );
        } else {
          return Container();
        }
      }
    }
  }

  setFirstDate(String _date) {
    DateTime date = DateTime.parse(_date);
    DateTime now = DateTime.now();
    if (date.day == now.day &&
        date.month == now.month &&
        date.year == now.year) {
      return Container(
        padding: EdgeInsets.only(top: 7, bottom:7),
        child: Bubble(
          alignment: Alignment.center,
          color: Color.fromRGBO(212, 234, 244, 1.0),
          child: Text("Aujourd'hui",
              textAlign: TextAlign.center, style: TextStyle(fontSize: 11.0)),
        ),
      );
    } else {
      if (date.isBefore(now)) {
        if (date.day == (now.day - 1) &&
            date.month == now.month &&
            date.year == now.year) {
          return Container(
            padding: EdgeInsets.only(top: 7, bottom:7),
            child: Bubble(
              alignment: Alignment.center,
              color: Color.fromRGBO(212, 234, 244, 1.0),
              child: Text("hier",
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 11.0)),
            ),
          );
          return ;
        } else if (date.day < (now.day - 1) &&
            date.day > (now.day - 7) &&
            date.month == now.month &&
            date.year == now.year) {
          return Container(
            padding: EdgeInsets.only(top: 7, bottom:7),
            child: Bubble(
              alignment: Alignment.center,
              color: Color.fromRGBO(212, 234, 244, 1.0),
              child: Text(setDay(date),
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 11.0)),
            ),
          );
          return ;
        } else if ((date.day > (now.day - 7) &&
                date.month == now.month &&
                date.year == now.year) ||
            date.month != now.month ||
            date.year != now.year) {
          return Container(
            padding: EdgeInsets.only(top: 7, bottom:7),
            child: Bubble(
              alignment: Alignment.center,
              color: Color.fromRGBO(212, 234, 244, 1.0),
              child: Text(
                  "${setDay(date)}, ${date.day} ${setMonth(date)} ${date.year}",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11.0)),
            ),
          );
          return Bubble(
            alignment: Alignment.center,
            color: Color.fromRGBO(212, 234, 244, 1.0),
            child: Text(
                "${setDay(date)}, ${date.day} ${setMonth(date)} ${date.year}",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11.0)),
          );
        } else {
          return Container(
            padding: EdgeInsets.only(top: 7, bottom:7),
            child: Bubble(
              alignment: Alignment.center,
              color: Color.fromRGBO(212, 234, 244, 1.0),
              child: Text(
                  "${setDay(date)}, ${date.day} ${setMonth(date)} ${date.year}",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11.0)),
            ),
          );
          return Bubble(
            alignment: Alignment.center,
            color: Color.fromRGBO(212, 234, 244, 1.0),
            child: Text(
                "${setDay(date)}, ${date.day} ${setMonth(date)} ${date.year}",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11.0)),
          );
        }
      } else {
        return Container();
      }
    }
  }

  String setDay(DateTime _date) {
    if (_date.weekday == 1) {
      return 'lundi';
    }
    if (_date.weekday == 2) {
      return 'mardi';
    }
    if (_date.weekday == 3) {
      return 'mercrdi';
    }
    if (_date.weekday == 4) {
      return 'jeudi';
    }
    if (_date.weekday == 5) {
      return 'vendredi';
    }
    if (_date.weekday == 6) {
      return 'samedi';
    }
    if (_date.weekday == 7) {
      return 'diamnche';
    }
  }

  String setMonth(DateTime date) {
    if (date.month == 1) {
      return 'janvier';
    }
    if (date.month == 2) {
      return 'fevrier';
    }
    if (date.month == 3) {
      return 'mars';
    }
    if (date.month == 4) {
      return 'avril';
    }
    if (date.month == 5) {
      return 'mai';
    }
    if (date.month == 6) {
      return 'juin';
    }
    if (date.month == 7) {
      return 'juillet';
    }
    if (date.month == 8) {
      return 'aout';
    }
    if (date.month == 9) {
      return 'septembre';
    }
    if (date.month == 10) {
      return 'octobre';
    }
    if (date.month == 11) {
      return 'novembre';
    }
    if (date.month == 12) {
      return 'decembre';
    }
  }

  getDateMessage(_date) {
    DateTime dateTime = DateTime.parse(_date);
    DateTime now = new DateTime.now();

    String date = DateFormat("HH").format(dateTime) +
        'h' +
        DateFormat("mm").format(dateTime);
    return Text("$date",
        textAlign: TextAlign.right,
        style: TextStyle(
          fontSize: 13,
          fontWeight: null,
          fontFamily: "DINNextLTPro-MediumCond",
          color: Colors.black45,
        ));
  }

  getVocal(overtime, content, index) async {
    if (isplayings[index]) {
      await _audioPlayer.pause();
      setState(() => isplayings[index] = false);
    } else {
      double time = overtime + 1.5;
      if (isplayings.contains(true)) {
        print(
            "----------------------------------------------------deux audio ne peuvent se lire en même temps");
        return null;
      } else {
        await _audioPlayer
            .play(content)
            .whenComplete(() => startTimer(time, index));
        //startTimer(time);
        setState(() => isplayings[index] = true);
      }
    }
  }

  void startTimer(overtime, index) {
    const onSec = const Duration(seconds: 1);
    timer = new Timer.periodic(onSec, (timer) {
      //print("******************** LE COMPTEUR POUR $overtime secs est lancé !! *********************");
      if (cpt >= overtime) {
        //Future.delayed(Duration(seconds: 1), ()=>setState(()=>isplaying=false));
        setState(() => isplayings[index] = false);
        setState(() => cpt = 0);
        //print("********************************************************LE COMPTEUR s'EST ARRET3");
        timer.cancel();
      } else {
        setState(() => cpt++);
        //print("********************************************************LE COMPTEUR EST A $cpt");
      }
    });
  }
}
////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class MessageCard extends StatefulWidget {
  final String from;
  final String pp;
  final String content;
  final String type;
  final String date;

  final Post post;
  final Utilisateur user;

  final bool me;
  final bool isConnect;
  final int timer;
  final int index;

  MessageCard(
      {this.index,
      this.timer,
      this.isConnect,
      this.pp,
      this.user,
      this.post,
      this.from,
      this.content,
      this.type,
      this.me,
      this.date});

  @override
  _MessageCardState createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  AudioPlayer _audioPlayer = AudioPlayer();
  List<bool> isplayings = [];
  Timer timer;
  int cpt = 0;

  Duration duration = new Duration();
  Duration position = new Duration();

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  getDate(_date) {
    DateTime dateTime = DateTime.parse(_date);
    DateTime now = new DateTime.now();

    String date = DateFormat("HH").format(dateTime) +
        'h' +
        DateFormat("mm").format(dateTime);
    return Text("$date",
        textAlign: TextAlign.right,
        style: TextStyle(
          fontSize: 13,
          fontWeight: null,
          fontFamily: "DINNextLTPro-MediumCond",
          color: Colors.black45,
        ));
  }

  getVocal(overtime, content, index) async {
    if (isplayings[index]) {
      await _audioPlayer.pause();
      setState(() => isplayings[index] = false);
    } else {
      double time = overtime + 1.5;
      if (isplayings.contains(true)) {
        print(
            "----------------------------------------------------deux audio ne peuvent se lire en même temps");
        return null;
      } else {
        await _audioPlayer
            .play(content)
            .whenComplete(() => startTimer(time, index));
        //startTimer(time);
        setState(() => isplayings[index] = true);
      }
    }
  }

  void startTimer(overtime, index) {
    const onSec = const Duration(seconds: 1);
    timer = new Timer.periodic(onSec, (timer) {
      //print("******************** LE COMPTEUR POUR $overtime secs est lancé !! *********************");
      if (cpt >= overtime) {
        //Future.delayed(Duration(seconds: 1), ()=>setState(()=>isplaying=false));
        setState(() => isplayings[index] = false);
        setState(() => cpt = 0);
        //print("********************************************************LE COMPTEUR s'EST ARRET3");
        timer.cancel();
      } else {
        setState(() => cpt++);
        //print("********************************************************LE COMPTEUR EST A $cpt");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.me == null
        ? Container(
            child: CommentCard(widget.content, widget.from, widget.type),
          )
        : Container(
            child: Column(
              crossAxisAlignment:
                  widget.me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.from,
                  style: widget.me
                      ? TextStyle(color: Colors.grey[300])
                      : TextStyle(color: Colors.grey[400]),
                ),
                Container(
                  width: 300,
                  child: Material(
                    color: widget.me ? Colors.teal : Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    elevation: 6.0,
                    child: widget.type == "audio"
                        ? IntrinsicWidth(
                            child: IntrinsicWidth(
                                child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: widget.me
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          child: CircleAvatar(
                                            //backgroundColor: Colors.black,
                                            backgroundImage: AssetImage(
                                                isplayings[widget.index]
                                                    ? 'assets/audio_wave.gif'
                                                    : 'assets/audio_wave.jpg'),
                                            //child: Image.asset(),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 5),
                                    IntrinsicWidth(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          InkWell(
                                              // onTap: () => getVocal(),
                                              //child: Icon(isplayings[index]? Icons.pause: Icons.play_arrow, color: Colors.blueGrey, size: 33),
                                              ),
                                          _slider(),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    getDate(widget.date)
                                  ],
                                ),
                              ],
                            )),
                          )
                        : Container(
                            child: Text(
                              widget.content,
                              textAlign: TextAlign.left,
                              style: widget.me
                                  ? TextStyle(color: Colors.grey[100])
                                  : TextStyle(color: Colors.black),
                            ),
                          ),
                  ),
                )
              ],
            ),
          );
  }

  Widget CommentCard(
    String _text,
    String username,
    String type,
  ) {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(height: 11),
          Container(
              //width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left: 11),
              child: Stack(
                children: <Widget>[
                  //****************************HEADER*********************//
                  Row(
                    children: <Widget>[
                      getDateVocal(widget.date),
                      SizedBox(width: 7),
                      Container(
                          child: Container(
                        //width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              username,
                              style: TextStyle(
                                  fontFamily: "DINNextLTPro-MediumCond",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.0,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                ],
              )),
          SizedBox(height: 3),
          //****************************TEXT*********************//
          Container(
            //padding: EdgeInsets.only(left: 11),
            alignment: Alignment.topLeft,
            child: Container(
              padding: EdgeInsets.all(11.0),
              child: type == "audio"
                  ? IntrinsicWidth(
                      child: IntrinsicWidth(
                          child: Column(
                        children: [
                          Row(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    child: CircleAvatar(
                                      //backgroundColor: Colors.black,
                                      backgroundImage: widget.pp == null
                                          ? AssetImage(
                                              "assets/images/person.png")
                                          : NetworkImage(widget.pp),
                                      //child: Image.asset(),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 5),
                              Container(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      onTap: () => getVocal(widget.timer,
                                          widget.content, widget.index),
                                      child: widget.content.length == 0
                                          ? Container(
                                              height: 15,
                                              width: 15,
                                              child:
                                                  CircularProgressIndicator())
                                          : Icon(Icons.mic,
                                              color: Colors.teal, size: 33),
                                    ),
                                    Container(
                                      child: Text("Audio"),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width: 5),
                              //getDateMessage(widget.date)
                            ],
                          ),
                        ],
                      )),
                    )
                  : Text(_text),
            ),
          ),
          SizedBox(height: 3),
          //setDuration(widget.timer),
          //****************************FOOTER*********************//
          //SizedBox(height: 25,),
          /*
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(left: 11),
            child: InkWell(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder:(context)=>Room(fromForum: false, article: widget.post, user: widget.user, isAnswer: true, isComment: true, answer:widget.content, answerTo: widget.from, answerType:widget.type))),
              child: Row(
                children: [
                  Text(
                    "répondre",
                    style: TextStyle(color: Colors.teal, fontSize: 15),
                  ),
                  SizedBox(width: 10)
                ],
              ),
            ),
          ),
          */
        ],
      ),
    );
  }

  Widget _slider() {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: Colors.grey,
        inactiveTrackColor: Colors.grey[300],
        trackHeight: 3.0,
        thumbColor: Colors.blueGrey,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5.0),
        overlayColor: Colors.purple.withAlpha(32),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 14.0),
      ),
      child: Slider(
          min: 0.0,
          max: duration.inSeconds.toDouble(),
          value: position.inSeconds.toDouble(),
          onChanged: (double value) {
            setState(() {
              _audioPlayer.seek(value);
            });
          }),
    );
  }

  getDateVocal(_date) {
    DateTime dateTime = DateTime.parse(_date);
    DateTime now = new DateTime.now();

    String date = DateFormat("HH").format(dateTime) +
        'h' +
        DateFormat("mm").format(dateTime);
    return Text("$date",
        textAlign: TextAlign.right,
        style: TextStyle(
          fontSize: 13,
          fontWeight: null,
          fontFamily: "DINNextLTPro-MediumCond",
          color: Colors.black45,
        ));
  }

  getDateMessage(_date) {
    DateTime dateTime = DateTime.parse(_date);
    DateTime now = new DateTime.now();

    String date = DateFormat("HH").format(dateTime) +
        'h' +
        DateFormat("mm").format(dateTime);
    return Text("$date",
        textAlign: TextAlign.right,
        style: TextStyle(
          fontSize: 13,
          fontWeight: null,
          fontFamily: "DINNextLTPro-MediumCond",
          color: Colors.black45,
        ));
  }

  setDuration(seconds) {
    int minutes = (seconds / 60).truncate();
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    return Text(
      minutesStr,
      style: TextStyle(color: Colors.black45),
    );
  }

  GetRoom(Post _post, isComment, isAnswer, answer, answerTo, answerType) {
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Room(
                fromForum: false,
                article: widget.post,
                user: widget.user,
                isAnswer: true,
                isComment: true,
                answer: answer,
                answerTo: widget.from,
                answerType: answerType)));
    /*
      widget.isConnect == null ? Navigator.push(context, MaterialPageRoute(builder:(context)=>ToConnect(post: widget.post, isArticle: true)))
        : widget.isConnect ? Navigator.push(context, MaterialPageRoute(builder:(context)=>Room(fromForum: false, article: widget.post, user: widget.user, isAnswer: true, isComment: true, answer:answer, answerTo: answerTo, answerType:answerType)))
        : Navigator.push(context, MaterialPageRoute(builder:(context)=>ToConnect(post: widget.post, isArticle:true, )));
   */
  }
}
