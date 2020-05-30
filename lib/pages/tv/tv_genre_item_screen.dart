import 'package:async/async.dart';
import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/providers/tv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'package:e_movies/widgets/tv/tv_item.dart' as wid;

class TVGenreItemScreen extends StatefulWidget {
  final int id;
  TVGenreItemScreen(this.id);
  @override
  _TVGenreItemScreenState createState() => _TVGenreItemScreenState();
}

enum MovieLoaderStatus {
  STABLE,
  LOADING,
}

class _TVGenreItemScreenState extends State<TVGenreItemScreen> {
  bool _initLoaded = true;
  bool _isLoading = false;
  bool _isFetching = true;
  ScrollController scrollController;
  MovieLoaderStatus loaderStatus = MovieLoaderStatus.STABLE;
  CancelableOperation movieOperation;
  int curPage = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController = ScrollController();
    _initLoaded = true;
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
        appBar: AppBar(
          title: Text(TV_GENRES[widget.id], style: kTitleStyle),          
          centerTitle: true,          
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
                            );
                          },
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 2 / 3.5,
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
