import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/providers/movies.dart';

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

  String url = '';

  List<VideoItem> _videos;

  @override
  void initState() {
    super.initState();    
    
    _controller = YoutubePlayerController(
      initialVideoId: url,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHideAnnotation: false,
        forceHD: false,
        enableCaption: true,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    if (_initLoaded) {
      final id = ModalRoute.of(context).settings.arguments as int;
      // print('id --------> $id');
      Provider.of<Movies>(context, listen: false).fetchVideos(id).then((value) {
        setState(() {
          _videos = Provider.of<Movies>(context, listen: false).videos;
          // print('first video----------------> ${_videos[0].name}');
          _isFetching = false;
          _initLoaded = false;

          if (_videos == null || _videos.isEmpty) {
            _isEmpty = true;
          } else {
            url = _videos[0].key;
          }
        });
      });
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap(String key) {
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
                builder: (context, constraints) {
                  return Stack(
                    children: <Widget>[
                      _isEmpty
                          ? Center(
                              child: Text(
                                'No Video Availabe!',
                                style: kTitleStyle,
                              ),
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              padding: EdgeInsets.only(
                                  top: constraints.maxHeight * 0.3 + 10),
                              physics: BouncingScrollPhysics(
                                  parent: AlwaysScrollableScrollPhysics()),
                              itemCount: _videos.length,
                              separatorBuilder: (context, index) {
                                return Divider();
                              },
                              itemBuilder: (context, index) {
                                return wid.VideoItem(
                                  videoDetails: _videos[index],
                                  onTap: _onTap,
                                );
                              },
                            ),
                      Container(
                        // color: Colors.red,
                        height: constraints.maxHeight * 0.3,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: YoutubePlayer(
                            controller: _controller,
                            progressIndicatorColor:
                                Theme.of(context).accentColor,
                          ),
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
