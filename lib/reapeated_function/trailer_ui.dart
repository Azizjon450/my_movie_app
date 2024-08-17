import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TrailerWatch extends StatefulWidget {
  var trailerytid;
  TrailerWatch({this.trailerytid});

  @override
  State<TrailerWatch> createState() => _TrailerWatchState();
}

class _TrailerWatchState extends State<TrailerWatch> {

  late YoutubePlayerController  _controller;

  @override
  void initState() {
    final videoId = YoutubePlayer.convertUrlToId(widget.trailerytid);
    _controller = YoutubePlayerController(
      initialVideoId: videoId.toString(),
      flags: YoutubePlayerFlags(
        enableCaption: true,
        autoPlay: false,
        //mute: false,controlsVisibleAtStart: true,
        forceHD: true,
      )
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: YoutubePlayer(
        controller: _controller,
        thumbnail: Image.network(
          'https://img.youtube.com/vi/' + widget.trailerytid + '/hqdefault.jpg',
          fit: BoxFit.cover,
        ),
        controlsTimeOut: Duration(milliseconds: 1500),
        aspectRatio: 16 / 9,
        showVideoProgressIndicator: true,
        bufferIndicator: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
          ),
        ),
        progressIndicatorColor: Colors.red,
        bottomActions: [
          CurrentPosition(),
          ProgressBar(
            isExpanded: true,
            colors: ProgressBarColors(
              playedColor: Colors.white,
              handleColor: Colors.red,
            ),
          ),
          RemainingDuration(),
          FullScreenButton(),
        ],
      ),
    );
  }
}
