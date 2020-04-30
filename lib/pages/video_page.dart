import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/providers/movies_provider.dart';
import 'package:e_movies/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'package:e_movies/widgets/video_item.dart' as wid;

class VideoPage extends StatefulWidget {
  static const routeName = '/video-page';
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> with TickerProviderStateMixin {
  YoutubePlayerController _controller;
  PlayerState _playerState;
  YoutubeMetaData _youtubeMetaData;

  bool _initLoaded = true;
  bool _isFetching = true;
  bool _isEmpty = false;

  List<VideoItem> _videos;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Future.delayed(Duration.zero).then((value) {

    // _controller = YoutubePlayerController(
    //   initialVideoId: videos[0]['key'],
    // //   flags: YoutubePlayerFlags(
    // //     mute: false,
    // //     autoPlay: true,
    // //     disableDragSeek: false,
    // //     loop: false,
    // //     isLive: false,
    // //     forceHideAnnotation: true,
    // //     forceHD: false,
    // //     enableCaption: true,
    // //   ),
    // // )..addListener(listener);
    // );
  }

  @override
  void didChangeDependencies() {
    if (_initLoaded) {
      final id = ModalRoute.of(context).settings.arguments as int;
      print('id --------> $id');
      Provider.of<MoviesProvider>(context, listen: false)
          .fetchVideos(id)
          .then((value) {
        setState(() {
          _videos = Provider.of<MoviesProvider>(context, listen: false).videos;
          // print('first video----------------> ${_videos[0].name}');
          _isFetching = false;
          _initLoaded = false;

          // get the first video to set as initial video
          VideoItem trailerVideo;

          if (_videos.isEmpty) {
            _isEmpty = true;
          } else {
            trailerVideo = _videos[0];
            _controller = YoutubePlayerController(
              initialVideoId: trailerVideo.key,
              flags: YoutubePlayerFlags(
                mute: false,
                autoPlay: false,
                disableDragSeek: false,
                loop: false,
                isLive: false,
                forceHideAnnotation: true,
                forceHD: false,
                enableCaption: true,
              ),
            );
          }

          // print('trailerVidoe after(firstWhere) --------> ${trailerVideo.name}');
        });
      });
    }

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  //   void listener() {
  //   if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
  //     setState(() {
  //       _playerState = _controller.value.playerState;
  //       _videoMetaData = _controller.metadata;
  //     });
  //   }
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void _onTap(String key) {
    print('ontap ------------------> clicked');
    _controller.load(key);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _isFetching
            ? Center(
                child: SpinKitCircle(
                    size: 21, color: Theme.of(context).accentColor))
            : LayoutBuilder(
                builder: (context, constraints) {
                  return  Stack(
                          children: [
                            _isEmpty
                      ? Center(
                          child: Text(
                            'No Video Availabe!',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        )
                      :
                            ListView.separated(
                              shrinkWrap: true,
                              padding: EdgeInsets.only(
                                  top: constraints.maxHeight * 0.3 + APP_BAR_HEIGHT + 20),
                              physics: BouncingScrollPhysics(),
                              itemCount: _videos.length,
                              separatorBuilder: (context, index) {
                                return Divider(
                                  // thickness: 0.5,
                                  // color: Colors.white,
                                );
                              },
                              itemBuilder: (context, index) {
                                return wid.VideoItem(
                                  videoDetails: _videos[index],
                                  onTap: _onTap,
                                );
                              },
                            ),
                            Column(
                              children: [
                                TopBar(title: 'Videos'),
                                if(!_isEmpty)
                                Container(
                                  height: constraints.maxHeight * 0.3,
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: YoutubePlayer(
                                      controller: _controller,
                                      progressIndicatorColor: Colors.pink,
                                    ),
                                  ),
                                ),
                                Divider(
                                  thickness: 2,
                                  color: Colors.pink,
                                ),
                              ],
                            ),
                            SizedBox(),
                          ],
                        );
                },
              ),
        //     : YoutubePlayer(
        //         controller: _controller,
        //         progressIndicatorColor: Colors.pink,
        //       ),
      ),
    );
  }
}
