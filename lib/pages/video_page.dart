import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  static const routeName = '/video-page';
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> with TickerProviderStateMixin {
  VideoPlayerController _playerController;
  ChewieController _chewieController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _playerController = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/videos/butterfly.mp4');
    _chewieController = ChewieController(
      videoPlayerController: _playerController,
      aspectRatio: 3 / 2,
      autoPlay: true,
      looping: true,
      showControls: true,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _playerController.dispose();
    _chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('player'),
      ),
      body: Chewie(
        controller: _chewieController,
      ),
    );
  }
}
