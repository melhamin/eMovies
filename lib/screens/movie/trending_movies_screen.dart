import 'package:async/async.dart';
import 'package:e_movies/widgets/back_button.dart';
import 'package:e_movies/widgets/loading_indicator.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:e_movies/providers/movies.dart' show Movies;
import 'package:e_movies/widgets/movie/movie_item.dart';

enum MovieLoaderStatus {
  STABLE,
  LOADING,
}

class TrendingMoviesScreen extends StatefulWidget {
  static const routeName = '/TrendingMoviesScreen';

  TrendingMoviesScreen({
    Key key,
  }) : super(key: key);

  @override
  _TrendingMoviesScreenState createState() => _TrendingMoviesScreenState();
}

class _TrendingMoviesScreenState extends State<TrendingMoviesScreen>
    with AutomaticKeepAliveClientMixin {
  bool _initLoaded = true;
  bool _isLoading = true;
  ScrollController scrollController;
  MovieLoaderStatus loaderStatus = MovieLoaderStatus.STABLE;
  CancelableOperation movieOperation;

  var movies;
  int curPage = 1;

  @override  
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();    
  }

  @override
  void didChangeDependencies() {
    if (_initLoaded) {
      Provider.of<Movies>(context, listen: false).fetchTrending(1).then((value) {       
          _isLoading = false;        
      });
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
            _isLoading = true;
          });
          movieOperation = CancelableOperation.fromFuture(
                  Provider.of<Movies>(context, listen: false)
                      .fetchTrending(curPage + 1))
              .then(
            (_) {
              loaderStatus = MovieLoaderStatus.STABLE;
              setState(() {
                curPage = curPage + 1;
                _isLoading = false;
              });
            },
          );
        }
      }
    }
    return true;
  }
  

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var movies = Provider.of<Movies>(context).trending;    
    return SafeArea(
      child: Scaffold(
        body: NotificationListener(
          onNotification: onNotification,
          child: Stack(
            children: [
              GridView.builder(
                // padding: const EdgeInsets.only(bottom: APP_BAR_HEIGHT),
                
                controller: scrollController,
                key: const PageStorageKey('TrendingMoviesScreen'),
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
              Positioned(
                top: 10,
                left: 0,
                child: CustomBackButton(text: 'Trending'),
              ),
              if (_isLoading)
                Positioned.fill(
                  bottom: 10,                  
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child:LoadingIndicator(),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
