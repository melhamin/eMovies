import 'package:e_movies/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:async/async.dart';

import '../providers/movies_provider.dart' show MoviesProvider;
import '../widgets/movie_item.dart';

enum MovieLoaderStatus {
  STABLE,
  LOADING,
}

class TopRated extends StatefulWidget {
  static const routeName = '/upcoming-page';  
  TopRated({
    Key key,
  }) : super(key: key);

  @override
  _AllMoviesState createState() => _AllMoviesState();
}

class _AllMoviesState extends State<TopRated>
    with AutomaticKeepAliveClientMixin {
  bool _initLoaded = false;
  ScrollController scrollController;
  MovieLoaderStatus loaderStatus = MovieLoaderStatus.STABLE;
  CancelableOperation movieOperation;
  int curPage = 1;

  var movies;

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    scrollController = ScrollController();
    // TODO: implement initState
    _initLoaded = true;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_initLoaded) {
      Provider.of<MoviesProvider>(context, listen: false).fetchTopRated(1);
    }
    _initLoaded = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  bool onNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
        if (loaderStatus != null && loaderStatus == MovieLoaderStatus.STABLE) {
          loaderStatus = MovieLoaderStatus.LOADING;
          movieOperation = CancelableOperation.fromFuture(
            Provider.of<MoviesProvider>(context, listen: false)
                .fetchTopRated(curPage + 1),
          ).then(
            (_) {
              loaderStatus = MovieLoaderStatus.STABLE;
              setState(() {
                curPage = curPage + 1;
              });
            },
          );
        }
      }
    }
    return true;
  }

  Future<void> _refreshMovies(bool refresh) async {
    if (refresh) {
      await Provider.of<MoviesProvider>(context, listen: false).fetchTopRated(1);
      setState(() {
        curPage = 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var movies = Provider.of<MoviesProvider>(context).topRated;
    // print('------------> length: ${movies.length}');
    return SafeArea(
      child: Scaffold(
        body: NotificationListener(
          onNotification: onNotification,
          child: RefreshIndicator(
            onRefresh: () => _refreshMovies(movies.length == 0),
            backgroundColor: Theme.of(context).primaryColor,
            child: GridView.builder(
              physics: BouncingScrollPhysics(),
              controller: scrollController,
              key: PageStorageKey('UpcomingMoviesPage'),
              cacheExtent: 12,
              itemCount: movies.length,
              itemBuilder: (ctx, i) {
                return MovieItem(
                  movie: movies[i],                  
                );
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2 / 3,
                // crossAxisSpacing: 5,
                // mainAxisSpacing: 5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
