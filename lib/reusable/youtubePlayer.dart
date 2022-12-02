import 'package:flutter/material.dart';
import 'package:wiwmedia_wiwsport_v3/model/youtube/videos_list.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerYTScreen extends StatefulWidget {
  final String videoItemID;
  VideoPlayerYTScreen({this.videoItemID});

  @override
  _VideoPlayerYTScreenState createState() => _VideoPlayerYTScreenState();
}
class _VideoPlayerYTScreenState extends State<VideoPlayerYTScreen> {
  //
  YoutubePlayerController _controller;
  bool _isPlayerReady;
  @override
  void initState() {
    super.initState();
    _isPlayerReady = false;
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoItemID,
      flags: YoutubePlayerFlags(
        mute: true,
        autoPlay: false,
      ),
    );
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        onReady: () {
          _isPlayerReady = true;
        },
      ),
    );
  }
}