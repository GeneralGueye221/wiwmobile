import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';


class MyAudio extends StatefulWidget {
  MyAudio({Key key,this.url, this.isplaying}) : super(key: key);
  final String url;
  bool isplaying;

  @override
  _MyAudioState createState() => _MyAudioState();
}

class _MyAudioState extends State<MyAudio> {
  var uuid = Uuid();
  AudioPlayer _audioPlayer;
  Duration duration = new Duration();
  Duration position = new Duration();

  @override
  void initState(){
    _audioPlayer = AudioPlayer(playerId: uuid.toString());
    _audioPlayer.onPlayerStateChanged.listen((s) {
      if (s == AudioPlayerState.STOPPED||s == AudioPlayerState.COMPLETED) {
        setState(() {
          position = duration;
          widget.isplaying = false;
          position = new Duration(seconds: 0);
        });
      }
    });
    _audioPlayer.onDurationChanged.listen((Duration d) =>setState(() => duration = d));
    _audioPlayer.onAudioPositionChanged.listen((p) => setState(() => position = p));
  }



  getVocal() async {
    if(widget.isplaying){
      await _audioPlayer.pause();
      setState(() => widget.isplaying=false);
    } else {
      await _audioPlayer.play(widget.url);
      //setState(() => duration = _audioPlayer.duration);
      setState(() => widget.isplaying=true);
    }
  }
  getDateAudio(_date) {
    DateTime dateTime = DateTime.parse(_date);
    DateTime now = new DateTime.now();

    String date = DateFormat("HH").format(dateTime)+'h'+DateFormat("mm").format(dateTime);
    return Text("$date", textAlign: TextAlign.right, style: TextStyle(
      fontSize: 13,
      fontWeight: null,
      fontFamily: "DINNextLTPro-MediumCond",
      color: Colors.black45,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () => getVocal(),
          child: Icon(widget.isplaying? Icons.pause: Icons.play_arrow, color: Colors.blueGrey, size: 33),
        ),
        widget.isplaying?IntrinsicWidth(
          child: ProgressBar(
            progress: position,
            //buffered: _audioPlayer.duration,
            total: duration,
            onSeek: (duration) {
              print('User selected a new time: $duration');
            },
          ),
        ):Container(height: 1, width:90, color:Colors.grey,),
        /*
                                Container(
                                    //padding: EdgeInsets.(20.0),
                                    child: LinearProgressIndicator(
                                      value: animation.value,
                                    )),
                                 */
        //_slider(),
      ],
    );
  }
}
