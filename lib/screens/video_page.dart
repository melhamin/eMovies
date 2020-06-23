import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/models/video_model.dart';
import 'package:e_movies/providers/movies.dart';
import 'package:e_movies/providers/tv.dart';
import 'package:e_movies/screens/my_lists_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'package:e_movies/widgets/video_item.dart';

class VideoPage extends StatefulWidget {
  static const routeName = '/video-page';
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> with TickerProviderStateMixin {
  YoutubePlayerController _controller;

  bool _initLoaded = true;
  bool _isFetching = true;
  bool _isEmpty = false;

  List<VideoModel> _videos;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_initLoaded) {
      final args = ModalRoute.of(context).settings.arguments as List;
      // print('id --------> $id');
      final int id = args[0];
      final MediaType mediaType = args[1];

      // print('id ----------> $id\ntype -------------> $mediaType');

      if (mediaType == MediaType.Movie) {
        Provider.of<Movies>(context, listen: false)
            .fetchVideos(id)
            .then((value) {
          setState(() {
            _videos = Provider.of<Movies>(context, listen: false).videos;
            // print('first video----------------> ${_videos[0].name}');
            _isFetching = false;
            _initLoaded = false;

            // get the first video to set as initial video
            VideoModel trailerVideo;

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
          });
        });
      } else {
        Provider.of<TV>(context, listen: false).getVideos(id).then((value) {
          setState(() {
            _videos = Provider.of<TV>(context, listen: false).videos;
            // print('first video----------------> ${_videos[0].name}');
            _isFetching = false;
            _initLoaded = false;

            // get the first video to set as initial video
            VideoModel trailerVideo;

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
          });
        });
      }
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onTap(String key) {
    // print('ontap ------------------> clicked');
    _controller.load(key);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Videos', style: kTitleStyle),
          centerTitle: true,
        ),
        body: _isFetching
            ? Center(
                child: SpinKitCircle(
                    size: 21, color: Theme.of(context).accentColor))
            : LayoutBuilder(
                builder: (ctx, constraints) {
                  return _videos.isEmpty
                      ? Center(
                          child:
                              Text('No video available!', style: kTitleStyle),
                        )
                      : Column(
                          children: [
                            Container(
                              // color: Colors.red,
                              // height: constraints.maxHeight * 0.45,
                              child: YoutubePlayer(
                                controller: _controller,
                                progressIndicatorColor:
                                    Theme.of(context).accentColor,
                              ),
                            ),
                            SizedBox(height: 10),
                            Flexible(
                              child: ListView.separated(
                                shrinkWrap: true,
                                physics:const AlwaysScrollableScrollPhysics(),
                                itemCount: _videos.length,
                                separatorBuilder: (context, index) {
                                  return SizedBox(height: 10);
                                },
                                itemBuilder: (context, index) {
                                  return VideoItem(
                                    videoDetails: _videos[index],
                                    onTap: _onTap,
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                },
              ),
      ),
    );
  }
}
