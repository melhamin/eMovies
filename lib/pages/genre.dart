import 'package:async/async.dart';
import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/providers/tv.dart';
import 'package:e_movies/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'package:e_movies/providers/movies.dart';
import 'package:e_movies/widgets/tv/tv_item.dart' as wid;

class Genre extends StatefulWidget {
  final int id;
  Genre(this.id);
  @override
  _GenreState createState() => _GenreState();
}

enum MovieLoaderStatus {
  STABLE,
  LOADING,
}

class _GenreState extends State<Genre> {
  bool _initLoaded = true;
  bool _isLoading = false;
  bool _isFetching = true;
  ScrollController scrollController;
  MovieLoaderStatus loaderStatus = MovieLoaderStatus.STABLE;
  CancelableOperation movieOperation;
  int curPage = 1;

  var movies = [];
  int genreId;

  // @override
  // // TODO: implement wantKeepAlive
  // bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController = ScrollController();
    _initLoaded = true;
    // Future.delayed(Duration.zero).then((value) {
    // setState(() {
    //   // genreId = ModalRoute.of(context).settings.arguments as int;
    //   // print('gernreID------------> $genreId');
    //   _initLoaded = true;
    // });
    // });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_initLoaded) {
      Provider.of<TV>(context, listen: false).getGenre(widget.id, 1).then((value) {
        setState(() {
          _isFetching = false;
          _initLoaded = false;
        });
      });
    }
    // _initLoaded = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  Future<void> getFuture() {}

  bool onNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
        if (loaderStatus != null && loaderStatus == MovieLoaderStatus.STABLE) {
          loaderStatus = MovieLoaderStatus.LOADING;
          setState(() {
            _isLoading = true;
          });
          movieOperation = CancelableOperation.fromFuture(
                  Provider.of<TV>(context, listen: false)
                      .getGenre(widget.id, curPage + 1))
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
    // print('------------> length: ${movies.length}');
    final items = Provider.of<TV>(context).genre;
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          child: TopBar(
            title: 'Action',
          ),
          preferredSize: Size.fromHeight(kToolbarHeight),
        ),
        body: _isFetching
            ? _buildLoadingIndicator(context)
            : Column(
                children: [
                  Flexible(
                    child: NotificationListener(
                      onNotification: onNotification,
                      child: RefreshIndicator(
                        onRefresh: () {},
                        // onRefresh: () => _refreshMovies(movies.length == 0),
                        backgroundColor: Theme.of(context).primaryColor,
                        child: GridView.builder(
                          physics: BouncingScrollPhysics(),
                          controller: scrollController,
                          // key: PageStorageKey('GenreItem'),
                          cacheExtent: 12,
                          itemCount: items.length,
                          itemBuilder: (ctx, i) {
                            return wid.TVItem(
                              item: items[i],
                              tappable: true,
                              withFooter: true,
                            );
                          },
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1 / 2,
                            // crossAxisSpacing: 5,
                            // mainAxisSpacing: 5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (_isLoading) _buildLoadingIndicator(context),
                ],
              ),
      ),
    );
  }
}
