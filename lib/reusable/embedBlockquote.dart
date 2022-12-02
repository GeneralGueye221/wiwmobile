import 'package:flutter/material.dart';
import 'package:social_embed_webview/social_embed_webview.dart';

class EmbedBlockquoteTwitter extends StatefulWidget {
  final String block;

  EmbedBlockquoteTwitter({ @required this.block});

  @override
  _EmbedBlockquoteTwitterState createState() => _EmbedBlockquoteTwitterState();
}

class _EmbedBlockquoteTwitterState extends State<EmbedBlockquoteTwitter> {
  CrossFadeState _crossFadeState = CrossFadeState.showFirst;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _crossFadeState = CrossFadeState.showSecond;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(firstChild: _loader(), secondChild: _result(widget.block), crossFadeState: _crossFadeState, duration: Duration(seconds: 3));
  }

  Widget _loader () {
    return Container(
        child: Image.asset('assets/reloading.gif')
    );
  }

  Widget _result (_blockquote) {
    return SocialEmbed(
      embedCode: _blockquote,
      type: SocailMediaPlatforms.twitter,
    );
  }
}


class EmbedBlockquoteInsta extends StatefulWidget {
  final String block;

  EmbedBlockquoteInsta({ @required this.block});

  @override
  _EmbedBlockquoteInstaState createState() => _EmbedBlockquoteInstaState();
}

class _EmbedBlockquoteInstaState extends State<EmbedBlockquoteInsta> {
  CrossFadeState _crossFadeState = CrossFadeState.showFirst;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _crossFadeState = CrossFadeState.showSecond;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _result(widget.block);
      //AnimatedCrossFade(firstChild: _loader(), secondChild: _result(widget.block), crossFadeState: _crossFadeState, duration: Duration(seconds: 3));
  }

  Widget _loader () {
    return Center( child: CircularProgressIndicator());
  }

  Widget _result (_blockquote) {
    return SocialEmbed(
      embedCode: _blockquote,
      type: SocailMediaPlatforms.instagram,
    );
  }
}
