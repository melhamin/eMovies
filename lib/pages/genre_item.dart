import 'package:async/async.dart';
import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'package:e_movies/providers/movies_provider.dart';
import 'package:e_movies/widgets/movie_item.dart' as wid;

class GenreItem extends StatefulWidget {
  @override
  _GenreItemState createState() => _GenreItemState();
}

enum MovieLoaderStatus {
  STABLE,
  LOADING,
}

class _GenreItemState extends State<GenreItem> {
  bool _initLoaded = false;
  bool _isLoading = false;
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
    setState(() {
      // genreId = ModalRoute.of(context).settings.arguments as int;
      // print('gernreID------------> $genreId');
      _initLoaded = true;
    });
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
      genreId = ModalRoute.of(context).settings.arguments as int;
      _initLoaded = true;
      switch (genreId) {
        case 28:
          Provider.of<MoviesProvider>(context, listen: false).fetchActions(1);
          break;
        case 12:
          Provider.of<MoviesProvider>(context, listen: false).fetchAdventure(1);
          break;
        case 35:
          Provider.of<MoviesProvider>(context, listen: false).fetchComedy(1);
          break;
        case 16:
          Provider.of<MoviesProvider>(context, listen: false).fetchAnimation(1);
          break;
        case 80:
          Provider.of<MoviesProvider>(context, listen: false).fetchCrime(1);
          break;
        case 99:
          Provider.of<MoviesProvider>(context, listen: false)
              .fetchDocumentary(1);
          break;
        case 18:
          Provider.of<MoviesProvider>(context, listen: false).fetchDrama(1);
          break;
        case 10751:
          Provider.of<MoviesProvider>(context, listen: false).fetchFamily(1);
          break;
        case 14:
          Provider.of<MoviesProvider>(context, listen: false).fetchFantasy(1);
          break;
        case 36:
          Provider.of<MoviesProvider>(context, listen: false).fetchHistory(1);
          break;
        case 27:
          Provider.of<MoviesProvider>(context, listen: false).fetchHorror(1);
          break;
        case 10402:
          Provider.of<MoviesProvider>(context, listen: false).fetchMusic(1);
          break;
        case 9648:
          Provider.of<MoviesProvider>(context, listen: false).fetchMystery(1);
          break;
        case 10749:
          Provider.of<MoviesProvider>(context, listen: false).fetchRomance(1);
          break;
        case 878:
          Provider.of<MoviesProvider>(context, listen: false).fetchSciFi(1);
          break;
        case 53:
          Provider.of<MoviesProvider>(context, listen: false).fetchThriller(1);
          break;
        case 10752:
          Provider.of<MoviesProvider>(context, listen: false).fetchWar(1);
          break;
        case 37:
          Provider.of<MoviesProvider>(context, listen: false).fetchWestern(1);
          break;
      }
      // Provider.of<MoviesProvider>(context, listen: false).fetchActions(1);
    }
    _initLoaded = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  Future<void> getFuture() {
    switch (genreId) {
      case 28:
        return Provider.of<MoviesProvider>(context, listen: false)
            .fetchActions(curPage + 1);

      case 12:
        return Provider.of<MoviesProvider>(context, listen: false)
            .fetchAdventure(curPage + 1);

      case 35:
        return Provider.of<MoviesProvider>(context, listen: false)
            .fetchComedy(curPage + 1);

      case 16:
        return Provider.of<MoviesProvider>(context, listen: false)
            .fetchAnimation(curPage + 1);

      case 80:
        return Provider.of<MoviesProvider>(context, listen: false)
            .fetchCrime(curPage + 1);

      case 99:
        return Provider.of<MoviesProvider>(context, listen: false)
            .fetchDocumentary(curPage + 1);

      case 18:
        return Provider.of<MoviesProvider>(context, listen: false)
            .fetchDrama(curPage + 1);

      case 10751:
        return Provider.of<MoviesProvider>(context, listen: false)
            .fetchFamily(curPage + 1);

      case 14:
        return Provider.of<MoviesProvider>(context, listen: false)
            .fetchFantasy(curPage + 1);

      case 36:
        return Provider.of<MoviesProvider>(context, listen: false)
            .fetchHistory(curPage + 1);

      case 27:
        return Provider.of<MoviesProvider>(context, listen: false)
            .fetchHorror(curPage + 1);

      case 10402:
        return Provider.of<MoviesProvider>(context, listen: false)
            .fetchMusic(curPage + 1);

      case 9648:
        return Provider.of<MoviesProvider>(context, listen: false)
            .fetchMystery(curPage + 1);

      case 10749:
        return Provider.of<MoviesProvider>(context, listen: false)
            .fetchRomance(curPage + 1);

      case 878:
        return Provider.of<MoviesProvider>(context, listen: false)
            .fetchSciFi(curPage + 1);

      case 53:
        return Provider.of<MoviesProvider>(context, listen: false)
            .fetchThriller(curPage + 1);

      case 10752:
        return Provider.of<MoviesProvider>(context, listen: false)
            .fetchWar(curPage + 1);

      case 37:
        return Provider.of<MoviesProvider>(context, listen: false)
            .fetchWestern(curPage + 1);
    }
  }

  bool onNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
        if (loaderStatus != null && loaderStatus == MovieLoaderStatus.STABLE) {
          loaderStatus = MovieLoaderStatus.LOADING;
          setState(() {
            _isLoading = true;
          });
          movieOperation = CancelableOperation.fromFuture(getFuture()).then(
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
    switch (genreId) {
      case 28:
        movies = Provider.of<MoviesProvider>(context).action;
        break;
      case 12:
        movies = Provider.of<MoviesProvider>(context).adventrue;
        break;
      case 35:
        movies = Provider.of<MoviesProvider>(context).comedy;
        break;
      case 16:
        movies = Provider.of<MoviesProvider>(context).animation;
        break;
      case 80:
        movies = Provider.of<MoviesProvider>(context).crime;
        break;
      case 99:
        movies = Provider.of<MoviesProvider>(context).documentary;
        break;
      case 18:
        movies = Provider.of<MoviesProvider>(context).drama;
        break;
      case 10751:
        movies = Provider.of<MoviesProvider>(context).family;
        break;
      case 14:
        movies = Provider.of<MoviesProvider>(context).fantasy;
        break;
      case 36:
        movies = Provider.of<MoviesProvider>(context).history;
        break;
      case 27:
        movies = Provider.of<MoviesProvider>(context).horror;
        break;
      case 10402:
        movies = Provider.of<MoviesProvider>(context).music;
        break;
      case 9648:
        movies = Provider.of<MoviesProvider>(context).mystery;
        break;
      case 10749:
        movies = Provider.of<MoviesProvider>(context).romance;
        break;
      case 878:
        movies = Provider.of<MoviesProvider>(context).scifi;
        break;
      case 53:
        movies = Provider.of<MoviesProvider>(context).thriller;
        break;
      case 10752:
        movies = Provider.of<MoviesProvider>(context).war;
        break;
      case 37:
        movies = Provider.of<MoviesProvider>(context).western;
        break;
    }

    // print('------------> length: ${movies.length}');
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
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
                        padding: const EdgeInsets.only(top: APP_BAR_HEIGHT),
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
                          childAspectRatio: 2/3,
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
            TopBar(GENRES[genreId]),
          ],
        ),
      ),
    );
  }
}
