import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/models/init_data.dart';
import 'package:e_movies/models/movie_model.dart';
import 'package:e_movies/widgets/image_clipper.dart';
import 'package:e_movies/widgets/loading_indicator.dart';
import 'package:e_movies/widgets/placeholder_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../my_lists_screen.dart';
import '../../../video_page.dart';

class BackgroundAndTitle extends StatefulWidget {
  const BackgroundAndTitle({
    Key key,
    @required this.initData,
    @required this.film,
    @required this.constraints,
    @required this.isLoading,
  }) : super(key: key);

  final InitData initData;
  final MovieModel film;
  final BoxConstraints constraints;
  final bool isLoading;

  @override
  _BackgroundAndTitleState createState() => _BackgroundAndTitleState();
}

class _BackgroundAndTitleState extends State<BackgroundAndTitle>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  // background image animation controller
  AnimationController _animationController;
  var _backgroundImageScale = 0.0;
  bool initLoaded = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1)).then((value) {
      _animationController = AnimationController(
        vsync: this,
        lowerBound: 0.0,
        upperBound: 1.0,
        duration: Duration(milliseconds: 200),
      )
        ..addListener(() {
          if (this.mounted)
            setState(() {
              // update image scale as animation controller value changes
              _backgroundImageScale = _animationController.value;
            });
        })
        ..forward();
    });

    initLoaded = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _getGenre() {
    // print('genreIDs-----------> ${widget.initData['genreIDs']}');
    return widget.initData.genreIDs == null || widget.initData.genreIDs.isEmpty
        ? 'N/A'
        : MOVIE_GENRES[widget.initData.genreIDs[0]] ?? 'N/A';
  }

  String _getRating() {
    return widget.initData.voteAverage == null
        ? 'N/A'
        : widget.initData.voteAverage == 0
            ? 'NR'
            : widget.initData.voteAverage.toString();
  }

  String _getYearAndDuration() {
    return widget.isLoading
        ? _getYear() + ' \u2022 ' + '00 mins'
        : _getYear() + ' \u2022 ' + '${_getDuration()} mins';
  }

  dynamic _getDuration() {
    return widget.film.duration ?? 'N/A';
  }

  String _getYear() {
    return widget.initData.releaseDate != null
        ? widget.initData.releaseDate.year.toString()
        : 'N/A';
  }

  Route _buildRoute(Widget toPage) {
    return MaterialPageRoute(
        builder: (context) => toPage,
        settings: RouteSettings(arguments: [widget.film.id, MediaType.Movie]));
  }

  @override
  Widget build(BuildContext context) {    
    super.build(context);    
    return Stack(      
      children: [
        Container(
          // color: BASELINE_COLOR,
          padding: const EdgeInsets.only(bottom: 80),
          height: widget.constraints.maxHeight * 0.55,
          child: Stack(
            children: [
              ClipPath(
                clipper: ImageClipper(),
                child: Transform.scale(
                  scale: _backgroundImageScale,
                  child: widget.initData.backdropUrl == null
                      ? PlaceHolderImage(widget.initData.backdropUrl ?? 'N/A')
                      : CachedNetworkImage(
                          imageUrl: widget.initData.backdropUrl,
                          fadeInCurve: Curves.easeIn,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: imageProvider,
                              ),
                            ),
                          ),
                        ),
                ),
              ),              
              // Build shadow on background image
              ClipPath(
                clipper: ImageClipper(),
                child: Container(
                  color: Colors.black45,
                ),
              ),
              Positioned(
                // to the center of background image
                top: widget.constraints.maxHeight * 0.275 - 100,                
                right: widget.constraints.maxWidth / 2 - 40,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(_buildRoute(VideoPage()));
                      },
                      // child: Image.asset('assets/icons/play.gif'),
                      child: SvgPicture.asset(
                        'assets/icons/play.svg',
                        color: Theme.of(context).accentColor,
                        height: 80,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Theme.of(context).accentColor,
                          width: 2,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Text(
                          'Trailer',
                          style: kBodyStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: widget.constraints.maxHeight * 0.55 -
              180, // (180 calculated from small poster height and padding given to the background image so the overlaps the background image)
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    left: DEFAULT_PADDING -
                        5, // TODO find source of the padding at the left
                    right: DEFAULT_PADDING,
                  ),
                  width: 130,
                  height: 180,
                  child: Card(
                    color: BASELINE_COLOR,
                    shadowColor: Colors.white12,
                    elevation: 5,
                    child: widget.initData.posterUrl == null
                        ? PlaceHolderImage(widget.initData.title ?? 'N/A')
                        : CachedNetworkImage(
                            imageUrl: widget.initData.posterUrl,
                            fit: BoxFit.fill,
                            placeholder: (context, url) {
                              return Center(
                                child: LoadingIndicator(),
                              );
                            },
                          ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: DEFAULT_PADDING,
                        top:
                            70), // part of the poster image that overlaps background image
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.initData.title ?? 'N/A',
                          style: kTitleStyle2,
                          softWrap: true,
                          // overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              _getRating(),
                              style: kSubtitle1,
                            ),
                            SizedBox(width: 5),
                            Icon(Icons.favorite_border,
                                color: Theme.of(context).accentColor),
                            SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 1),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color: kTextBorderColor, width: 2)),
                              child: Text(
                                // 'Action',
                                _getGenre(),
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white54),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        // if (!widget.isLoading)
                        Text(
                          _getYearAndDuration(),
                          style: kSubtitle1,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
