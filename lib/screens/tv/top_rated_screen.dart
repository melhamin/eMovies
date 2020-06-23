import 'package:async/async.dart';
import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/providers/tv.dart' show TV;
import 'package:e_movies/widgets/back_button.dart';
import 'package:e_movies/widgets/movie/movie_item.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'package:e_movies/widgets/top_bar.dart';
import 'package:e_movies/widgets/tv/tv_item.dart';

enum MovieLoaderStatus {
  STABLE,
  LOADING,
}

class TopRatedScreen extends StatefulWidget {
  static const routeName = '/popular-screen';

  TopRatedScreen({
    Key key,
  }) : super(key: key);

  @override
  _AllMoviesState createState() => _AllMoviesState();
}

class _AllMoviesState extends State<TopRatedScreen> {
  bool _initLoaded = true;
  bool _isFetching = false;
  ScrollController scrollController;
  MovieLoaderStatus loaderStatus = MovieLoaderStatus.STABLE;
  CancelableOperation movieOperation;
  int curPage = 1;

  @override
  void initState() {
    scrollController = ScrollController();    
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_initLoaded) {
      Provider.of<TV>(context, listen: false).fetchTopRated(1);
    }
    _initLoaded = false;    
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  bool onNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
        if (loaderStatus != null && loaderStatus == MovieLoaderStatus.STABLE) {
          loaderStatus = MovieLoaderStatus.LOADING;
          setState(() {
            _isFetching = true;
          });
          movieOperation = CancelableOperation.fromFuture(
                  Provider.of<TV>(context, listen: false)
                      .fetchTopRated(curPage + 1))
              .then(
            (_) {
              loaderStatus = MovieLoaderStatus.STABLE;
              setState(() {
                curPage = curPage + 1;
                _isFetching = false;
              });
            },
          );
        }
      }
    }
    return true;
  }


  Widget _buildLoadingIndicator(BuildContext context) {
    return Center(
      child: SpinKitCircle(
        size: 30,
        color: Theme.of(context).accentColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var movies = Provider.of<TV>(context).topRated;
    // print('------------> length: ${movies.length}');
    return SafeArea(
      child: Scaffold(        
        body: NotificationListener(
          onNotification: onNotification,
          child: Stack(
            children: [
               GridView.builder(
                  // padding: const EdgeInsets.only(bottom: APP_BAR_HEIGHT),
                  
                  controller: scrollController,
                  key: const PageStorageKey('UpcomingScreen'),
                  cacheExtent: 12,
                  itemCount: movies.length,
                  itemBuilder: (ctx, i) {
                    return MovieItem(
                      item: movies[i],
                    );
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2 / 3.5,
                    // mainAxisSpacing: 5,
                    // crossAxisSpacing: 5,
                  ),
                ),
              if (_isFetching)
                Positioned.fill(
                  bottom: 10,                  
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: _buildLoadingIndicator(context),
                  ),
                ),
                Positioned(
                top: 10,
                left: 10,
                child: CustomBackButton(text: 'Top Rated'),
              ),
            ],
          ),
        ),        
        // NotificationListener(
        //   onNotification: onNotification,
        //   child: RefreshIndicator(
        //     onRefresh: () => _refreshMovies(movies.length == 0),
        //     backgroundColor: Theme.of(context).primaryColor,
        //     child: Column(
        //       children: [
        //         Flexible(
        //           child: GridView.builder(
        //             // padding: const EdgeInsets.only(bottom: APP_BAR_HEIGHT),
        //             
        //             controller: scrollController,
        //             key: PageStorageKey('TopRatedScreen'),
        //             cacheExtent: 12,
        //             itemCount: movies.length,
        //             itemBuilder: (ctx, i) {
        //               return TVItem(
        //                 item: movies[i],
        //               );
        //             },
        //             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //               crossAxisCount: 2,
        //               childAspectRatio: 2 / 3.5,
        //               // mainAxisSpacing: 5,
        //               // crossAxisSpacing: 5,
        //             ),
        //           ),
        //         ),
        //         if (_isFetching) _buildLoadingIndicator(context),
        //       ],
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
