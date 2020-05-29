import 'package:async/async.dart';
import 'package:e_movies/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'package:e_movies/providers/movies.dart';
import 'package:e_movies/widgets/movie/movie_item.dart' as wid;

class MovieGenreItem extends StatefulWidget {
  final int id;
  MovieGenreItem(this.id);
  @override
  _MovieGenreItemState createState() => _MovieGenreItemState();
}

enum MovieLoaderStatus {
  STABLE,
  LOADING,
}

class _MovieGenreItemState extends State<MovieGenreItem> {
  bool _initLoaded = true;
  bool _isLoading = false;
  bool _isFetching = true;
  ScrollController scrollController;
  MovieLoaderStatus loaderStatus = MovieLoaderStatus.STABLE;
  CancelableOperation movieOperation;
  int curPage = 1;

  var movies = [];
  int genreId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController = ScrollController();            
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
      Provider.of<Movies>(context, listen: false)
          .getGenre(widget.id, 1)
          .then((value) {
        setState(() {
          _initLoaded = false;
          _isFetching = false;
        });
      });      
    }    
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
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
                      .getGenre(widget.id, curPage + 1))
              .then(
            (_) {
              // print('future is ---------> $getFuture()');
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
    final movies = Provider.of<Movies>(context).genre;    
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(          
          title: Text(MOVIE_GENRES[widget.id], style: kTitleStyle),          
          centerTitle: true,
        ),
        body: _isFetching ? _buildLoadingIndicator(context) :
        Column(
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
                    itemCount: movies.length,
                    itemBuilder: (ctx, i) {
                      return wid.MovieItem(
                        movie: movies[i],
                      );
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
