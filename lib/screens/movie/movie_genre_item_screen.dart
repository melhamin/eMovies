import 'package:async/async.dart';
import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/widgets/back_button.dart';
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
  bool _isLoading = true;  
  ScrollController scrollController;
  MovieLoaderStatus loaderStatus = MovieLoaderStatus.STABLE;
  CancelableOperation movieOperation;
  int curPage = 1;

  var movies = [];
  int genreId;

  @override
  void initState() {    
    super.initState();
    scrollController = ScrollController();
  }

  @override
  void dispose() {    
    scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_initLoaded) {
      
      // clear previous data (if any other genre is opened before)
      Provider.of<Movies>(context, listen: false)
          .clearGenre();          
      Provider.of<Movies>(context, listen: false)
          .getGenre(widget.id, 1)
          .then((value) {                  
          _isLoading = false;
      });
    }    
          _initLoaded = false;
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
        size: 30,
        color: Theme.of(context).accentColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('isLoading ---------> $_initLoaded');
    final movies = Provider.of<Movies>(context).genre;
    return SafeArea(
      child: Scaffold(
        body: NotificationListener(
          onNotification: onNotification,
          child: Stack(
            children: [              
              GridView.builder(
                // padding: const EdgeInsets.only(bottom: APP_BAR_HEIGHT),
                physics: const BouncingScrollPhysics(),
                controller: scrollController,
                key: const PageStorageKey('TrendingMoviesScreen'),
                cacheExtent: 12,
                itemCount: movies.length,
                itemBuilder: (ctx, i) {
                  return wid.MovieItem(
                    item: movies[i],
                  );
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2 / 3.5,                  
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: CustomBackButton(text: MOVIE_GENRES[widget.id] ),
              ),
              if (_isLoading)
                Positioned.fill(
                  bottom: 10,                  
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: _buildLoadingIndicator(context),
                  ),
                )
            ],
          ),
        ),       
      ),
    );
  }
}
