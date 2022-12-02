import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:youtube_plyr_iframe/youtube_plyr_iframe.dart';

class YoutubePlayers extends StatefulWidget {
  final String id;
  YoutubePlayers({@required this.id});

  @override
  _YoutubePlayersState createState() => _YoutubePlayersState();
}

class _YoutubePlayersState extends State<YoutubePlayers> {

  YoutubePlayerController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.id,
      params: YoutubePlayerParams(
        //playlist: ['nPt8bK2gbaU', 'gQDByCdjUXw'], // Defining custom playlist
        //startAt: Duration(seconds: 30),
        showControls: true,
        showFullscreenButton: true,
        autoPlay: true,

      ),
    )..listen((value) {
      if (value.isReady && !value.hasPlayed) {
        _controller
          ..play()
          ..hideTopMenu();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      FocusDetector(
        onVisibilityLost: () {
          print(
            'Visibility Lost.'
                '\nIt means the widget is no longer visible within your app.',
          );
          _controller.pause();
        },
        onVisibilityGained: () {
          print(
            'Visibility Gained.'
                '\nIt means the widget is now visible within your app.',
          );
          _controller.play();
        },
        child: Container(
          //padding: const EdgeInsets.all(20),
          child: AspectRatio(
            aspectRatio: 16/9,
            child: YoutubePlayerIFrame(
              controller: _controller,
            ),
          ),
        ),
      );
  }
}