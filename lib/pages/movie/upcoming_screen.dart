import 'package:async/async.dart';
import 'package:e_movies/consts/consts.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'package:e_movies/providers/movies.dart' show Movies;
import 'package:e_movies/widgets/movie/movie_item.dart';

import 'package:e_movies/widgets/temp.dart' as temp;

import '../../consts/consts.dart';
import '../../consts/consts.dart';
import '../../consts/consts.dart';

enum MovieLoaderStatus {
  STABLE,
  LOADING,
}

class UpcomingScreen extends StatefulWidget {
  static const routeName = '/upcoming';

  UpcomingScreen({
    Key key,
  }) : super(key: key);

  @override
  _AllMoviesState createState() => _AllMoviesState();
}

class _AllMoviesState extends State<UpcomingScreen>
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
      Provider.of<Movies>(context, listen: false).fetchUpcoming(1);
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
                  Provider.of<Movies>(context, listen: false)
                      .fetchUpcoming(curPage + 1))
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
        size: 21,
        color: Theme.of(context).accentColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var movies = Provider.of<Movies>(context).upcoming;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Upcoming', style: kTitleStyle),
        ),
        body: NotificationListener(
          onNotification: onNotification,
          child: Column(
            children: [
              Flexible(
                child: GridView.builder(
                  // padding: const EdgeInsets.only(bottom: APP_BAR_HEIGHT),
                  physics: const BouncingScrollPhysics(),
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
              ),
              if (_isFetching) _buildLoadingIndicator(context),
            ],
          ),
        ),
      ),
    );
  }
}
