import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/providers/init_data.dart';
import 'package:e_movies/providers/movies.dart';
import 'package:e_movies/screens/movie/movie_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class InTheatersGrid extends StatefulWidget {
  @override
  _InTheatersGridState createState() => _InTheatersGridState();
}

class _InTheatersGridState extends State<InTheatersGrid>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  PageController _pageController;
  bool isLoading = true;
  bool initLoaded = true;

  AnimationController _animationController;
  Timer _timer;

  int curr = 0;
  double imageScale = 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);    
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if(_pageController.hasClients)
      _pageController.nextPage(duration: Duration(seconds: 1), curve: Curves.ease);
    });
  }

  @override
  void didChangeDependencies() {
    if (initLoaded) {
      Provider.of<Movies>(context, listen: false)
          .fetchInTheaters(1)
          .then((value) {
        setState(() {
          isLoading = false;
          initLoaded = false;
        });
      });
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageViewChanged(int index) {
    setState(() {
      curr = index;
    });    
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    return Center(
      child: SpinKitCircle(
        size: 21,
        color: Theme.of(context).accentColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final inTheaters = Provider.of<Movies>(context).inTheaters;
    // print('length ------------> ${inTheaters.length}');
    // print('isLoading-------------> $isLoading');
    return Stack(
      children: [
        if (isLoading) _buildLoadingIndicator(context),
        if (!isLoading && inTheaters.isNotEmpty)
          Container(            
            child: PageView.builder(
              onPageChanged: _onPageViewChanged,
              physics: const BouncingScrollPhysics(),
              // itemCount: 10,
              controller: _pageController,
              itemBuilder: (ctx, i) {
                int currIndex = i;
                if (currIndex > 9) {
                  if (currIndex % 10 == 0)
                    currIndex = 0;
                  else if ((currIndex + 1) % 10 == 0)
                    currIndex = 9;
                  else if ((currIndex - 1) % 10 == 0)
                    currIndex = 1;
                  else
                    currIndex = i % 10;
                }
                return GridItem(inTheaters[currIndex]);
              },
            ),
          ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.all(10),
            height: 10,
            width: 190,
            // color: Colors.blue,
            child: ListView.separated(
              separatorBuilder: (ctx, i) {
                return SizedBox(width: 10);
              },
              itemCount: 10,
              scrollDirection: Axis.horizontal,
              itemBuilder: (ctx, i) {
                return Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: i == curr % 10
                        ? Colors.white.withOpacity(0.87)
                        : Colors.white.withOpacity(0.45),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class GridItem extends StatefulWidget {
  final MovieItem item;
  GridItem(this.item);

  @override
  _GridItemState createState() => _GridItemState();
}

class _GridItemState extends State<GridItem>
    with SingleTickerProviderStateMixin {
  double imageScale;
  AnimationController _animationController;

  void initState() {
    super.initState();
    // _animationController = AnimationController(
    //   vsync: this,
    //   duration: Duration(seconds: 3),
    //   lowerBound: 1,
    //   upperBound: 1.1,
    // )..addListener(() {
    //     setState(() {
    //       imageScale = _animationController.value;
    //     });

    //   })..forward()
    //   ..addStatusListener((status) {
    //     if(status == AnimationStatus.completed) {
    //       // _changeImage();
    //       // _pageController.nextPage(duration: Duration(seconds: 1), curve: Curves.ease);
    //       _animationController.reset();
    //       _animationController.forward();
    //     }
    //   })
    //   ;
  }

  String _getGenre() {
    return MOVIE_GENRES[widget.item.genreIDs[0]] ?? 'N/A';
  }

  String _getRating() {
    return (widget.item.voteAverage == null || widget.item.voteAverage == 0)
        ? 'NR'
        : widget.item.voteAverage.toString();
  }

  String _getYearAndDuration() {
    return DateFormat.yMMMd().format(widget.item.date);
    // String str = '';
    // if (item.date == null) {
    //   str += 'N/A';
    // } else {
    //   str += item.date.year.toString();
    // }
    // if (item.duration != null) {
    //   str = str + ' \u2022 ' + item.duration.toString() + ' min';
    // }
    // return str;
  }

  Route _buildRoute() {
   final initData = InitialData.formObject(widget.item);
    return PageRouteBuilder(
      settings: RouteSettings(arguments: initData),
      pageBuilder: (context, animation, secondaryAnimation) =>
          MovieDetailsScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(
            1, 0); // if x > 0 and y = 0 transition is from right to left
        var end =
            Offset.zero; // if y > 0 and x = 0 transition is from bottom to top
        // var curve = Curves.bounceIn;
        var tween =
            Tween(begin: begin, end: end); // .chain(CurveTween(curve: curve))
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(_buildRoute());
          },
          child: Stack(
            children: [
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: widget.item.backdropUrl,
                  fit: BoxFit.fill,
                ),
              ),
              Container(
                color: Colors.black.withOpacity(0.75),
              ),
              Positioned(
                left: 15,
                top: 10,
                child: Card(
                  elevation: 10,
                  color: Colors.transparent,
                  child: Container(
                    height: constraints.maxHeight * 0.8,
                    width: constraints.maxWidth * 0.30,
                    child: CachedNetworkImage(
                      imageUrl: widget.item.posterUrl,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: constraints.maxWidth * 0.30 + 25,
                top: constraints.maxHeight * 0.25,
                child: Container(
                  width: constraints.maxWidth * 0.65,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.title ?? 'N/A',
                        style: kTitleStyle,
                        softWrap: true,
                        // overflow: TextOverflow.ellipsis,
                        // maxLines: 1,
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.4),
                                    width: 2)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 1),
                              child: Text(_getGenre(), style: kBodyStyle2),
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            _getRating(),
                            style: kBodyStyle2,
                          ),
                          SizedBox(width: 5),
                          Icon(
                            Icons.favorite_border,
                            color: Theme.of(context).accentColor,
                            size: 30,
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Text(
                        _getYearAndDuration(),
                        style: kBodyStyle2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
