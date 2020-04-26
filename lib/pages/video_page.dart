import 'package:flutter/material.dart';

import 'package:chewie/chewie.dart';

class VideoPage extends StatefulWidget {
  static const routeName = '/video-page';
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> with TickerProviderStateMixin {  

  // YoutubePlayerController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('player'),
      ),
      // body: YoutubePlayer(
      //   context: context,
      //   source: 'plIxrmV63kg',
      //   quality: YoutubeQuality.HIGH,
      // ),
    );
  }
}
