import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:meedu_player/meedu_player.dart';



class MyVideoPlayer extends StatefulWidget {
  final String videoUrl;

  MyVideoPlayer({this.videoUrl});


  @override
  _MyVideoPlayerState createState() => _MyVideoPlayerState();
}

class _MyVideoPlayerState extends State<MyVideoPlayer> {
  final videoController = MeeduPlayerController(
    controlsStyle: ControlsStyle.primary,
    showPipButton: false,
    controlsEnabled: false,
    // use false to hide pip button in the player
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videoController.setDataSource(
      DataSource(
        type: DataSourceType.network,
        source: widget.videoUrl,
      ),
      autoplay: false,

    );
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onVisibilityLost: () {
        print(
          'Visibility Lost.'
              '\nIt means the widget is no longer visible within your app.',
        );
        videoController
            .pause();
      },
      onVisibilityGained: () {
        print(
          'Visibility Gained.'
              '\nIt means the widget is now visible within your app.',
        );
        videoController.play();
      },
      child: InkWell(
        onTap: () => unMute(),
        child: MeeduVideoPlayer(
          controller: videoController,
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    videoController.dispose();
  }

  void unMute() {
    setState(() {
      if(videoController.playerStatus.playing){
        videoController.pause();
      } else {
        videoController.play();
      }
    });
  }
}