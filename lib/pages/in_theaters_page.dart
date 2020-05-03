import 'package:e_movies/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:async/async.dart';

import '../providers/movies_provider.dart' show MoviesProvider;
import '../widgets/movie_item.dart';

enum MovieLoaderStatus {
  STABLE,
  LOADING,
}

class InTheaters extends StatefulWidget {
  static const routeName = '/InTheathers-page';

  InTheaters({
    Key key,
  }) : super(key: key);

  @override
  _AllMoviesState createState() => _AllMoviesState();
}

class _AllMoviesState extends State<InTheaters>
    with AutomaticKeepAliveClientMixin {
  bool _initLoaded = true;
  bool _isFetching = false;
  ScrollController scrollController;
  MovieLoaderStatus loaderStatus = MovieLoaderStatus.STABLE;
  CancelableOperation movieOperation;

  var movies;
  int curPage = 1;

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    scrollController = ScrollController();
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_initLoaded) {
      Provider.of<MoviesProvider>(context, listen: false).fetchInTheaters(1);
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
          setState(() {
            _isFetching = true;
          });
          movieOperation = CancelableOperation.fromFuture(
                  Provider.of<MoviesProvider>(context, listen: false)
                      .fetchInTheaters(curPage + 1))
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

  Future<void> _refreshMovies(bool refresh) async {
    if (refresh)
      await Provider.of<MoviesProvider>(context, listen: false)
          .fetchInTheaters(1);
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
    var movies = Provider.of<MoviesProvider>(context).inTheaters;
    // print('------------> length: ${movies.length}');
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          child: TopBar(title: 'In Theaters'),
          preferredSize: Size.fromHeight(kToolbarHeight),
        ),
        body: NotificationListener(
          onNotification: onNotification,
          child: RefreshIndicator(
            onRefresh: () => _refreshMovies(movies.length == 0),
            backgroundColor: Theme.of(context).primaryColor,
            child: Column(
              children: [
                Flexible(
                  child: GridView.builder(
                    // padding: const EdgeInsets.only(bottom: APP_BAR_HEIGHT),
                    physics: const BouncingScrollPhysics(),
                    controller: scrollController,
                    key: PageStorageKey('InTheathersPage'),
                    cacheExtent: 12,
                    itemCount: movies.length,
                    itemBuilder: (ctx, i) {
                      return MovieItem(
                        movie: movies[i],
                      );
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1 / 2,
                      // mainAxisSpacing: 5,
                      // crossAxisSpacing: 5,
                    ),
                  ),
                ),
                if (_isFetching) _buildLoadingIndicator(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
