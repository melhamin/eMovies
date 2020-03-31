import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:async/async.dart';

import '../providers/movies.dart' show Movies;
import '../widgets/movie_item.dart';

enum MovieLoaderStatus {
  STABLE,
  LOADING,
}

class UpcomingMoviesPage extends StatefulWidget {
  UpcomingMoviesPage({
    Key key,
  }) : super(key: key);

  @override
  _AllMoviesState createState() => _AllMoviesState();
}

class _AllMoviesState extends State<UpcomingMoviesPage>
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
      Provider.of<Movies>(context, listen: false).fetchUpcomingMovies(1);
    }
    _initLoaded = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  bool onNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (scrollController.position.maxScrollExtent > scrollController.offset &&
          scrollController.position.maxScrollExtent - scrollController.offset <=
              50) {
        if (loaderStatus != null && loaderStatus == MovieLoaderStatus.STABLE) {
          loaderStatus = MovieLoaderStatus.LOADING;
          movieOperation = CancelableOperation.fromFuture(
                  Provider.of<Movies>(context, listen: false)
                      .fetchUpcomingMovies(curPage + 1))
              .then(
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
      await Provider.of<Movies>(context, listen: false).fetchUpcomingMovies(1);
      setState(() {
        curPage = 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var movies = Provider.of<Movies>(context).upcomingMovies;
    print('------------> length: ${movies.length}');
    return NotificationListener(
      onNotification: onNotification,
      child: RefreshIndicator(
        onRefresh: () => _refreshMovies(movies.length == 0),
        backgroundColor: Theme.of(context).primaryColor,
        child: GridView.builder(
          controller: scrollController,
          key: PageStorageKey('UpcomingMoviesPage'),
          cacheExtent: 12,
          itemCount: movies.length,
          itemBuilder: (ctx, i) {
            print('--------------> i: $i');
            print('--------------> i: $i    ${movies[i].title}');
            return MovieItem(
              movie: movies[i],
            );
          },
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2 / 3,
          ),
        ),
      ),
    );
  }
}
