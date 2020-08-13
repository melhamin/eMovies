import 'package:async/async.dart';

import 'package:e_movies/screens/search/searched_actor_item.dart';

import 'package:e_movies/providers/search.dart' show Search;
import 'package:e_movies/widgets/loading_indicator.dart';


import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

enum LoaderStatus {
  STABLE,
  LOADING,
}

class ActorsResult extends StatefulWidget {
  final bool isLoading;
  final TextEditingController searchController;
  ActorsResult({this.searchController, this.isLoading});

  @override
  _ActorsResultState createState() => _ActorsResultState();
}

class _ActorsResultState extends State<ActorsResult> {
  int curPage = 1;
  CancelableOperation _operation;
  LoaderStatus _loaderStatus = LoaderStatus.STABLE;
  bool _isFetchingNewData = false;



  @override
  void didChangeDependencies() {
    // clear searched movies list if use not searhing
    // if (widget.searchController.text.isEmpty)
    //   Provider.of<Search>(context, listen: false).clearPeople();
    super.didChangeDependencies();
  }


  Widget _buildLoadingIndicator(BuildContext context) {
    return Center(
      child: widget.searchController.text.isEmpty
          ? null
          : LoadingIndicator(),
    );
  }

  bool onNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
        if (_loaderStatus != null && _loaderStatus == LoaderStatus.STABLE) {
          _loaderStatus = LoaderStatus.LOADING;
          setState(() {
            _isFetchingNewData = true;
          });
          _operation = CancelableOperation.fromFuture(
                  Provider.of<Search>(context, listen: false)
                      .searchPerson(widget.searchController.text, curPage + 1))
              .then(
            (_) {
              _loaderStatus = LoaderStatus.STABLE;
              setState(() {
                curPage = curPage + 1;
                _isFetchingNewData = false;
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
    final actors = Provider.of<Search>(context).actors;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanDown: (_) {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      // show recent search history when not searching
      child:  widget.isLoading // Show loading indicator when fetching data
              ? _buildLoadingIndicator(context)
              : NotificationListener(
                  onNotification: onNotification,
                  child: ListView.builder(
                    key: PageStorageKey('ActorsResults'),
                    // controller: _scrollController,
                    padding: const EdgeInsets.only(
                        bottom: kToolbarHeight, left: 10, right: 10, top: 10),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: actors.length,
                    itemBuilder: (ctx, i) {
                      var item = actors[i];
                      return SearchedActorItem(item);
                    },
                  ),
                ),
    );
  }
}


