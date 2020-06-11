import 'package:async/async.dart';

import 'package:e_movies/screens/search/searched_actor_item.dart';

import 'package:e_movies/providers/search.dart' show Search;


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

  // Route _buildRoute(ActorItem item) {
  //   // Map<String, dynamic> initData = searchHistoryItem
  //   //     ? item
  //   //     : {
  //   //         'id': item.id,
  //   //         'title': item.title,
  //   //         'genre': (item.genreIDs.length == 0 || item.genreIDs[0] == null)
  //   //             ? 'N/A'
  //   //             : item.genreIDs[0],
  //   //         'posterUrl': item.posterUrl,
  //   //         'backdropUrl': item.backdropUrl,
  //   //         'mediaType': 'movie',
  //   //         'releaseDate': item.date.year.toString() ?? 'N/A',
  //   //         'voteAverage': item.voteAverage,
  //   //       };
  //   return PageRouteBuilder(
  //     settings: RouteSettings(arguments: item),
  //     pageBuilder: (context, animation, secondaryAnimation) => CastDetails(),
  //     // {
  //     //   // if()  MovieDetailsScreen(),

  //     // },
  //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //       var begin = const Offset(
  //           1, 0); // if x > 0 and y = 0 transition is from right to left
  //       var end =
  //           Offset.zero; // if y > 0 and x = 0 transition is from bottom to top
  //       // var curve = Curves.bounceIn;
  //       var tween =
  //           Tween(begin: begin, end: end); // .chain(CurveTween(curve: curve))
  //       var offsetAnimation = animation.drive(tween);

  //       return SlideTransition(
  //         position: offsetAnimation,
  //         child: child,
  //       );
  //     },
  //   );
  // }

  // Widget _buildItem(
  //     BuildContext context, ActorItem item) {
  //   return InkWell(
  //     highlightColor: Colors.black,
  //     splashColor: Colors.transparent,
  //     onTap: () {
  //       Navigator.of(context).push(_buildRoute(item));
  //     },
  //     child: ListTile(
  //       // contentPadding: EdgeInsets.all(0),
  //       isThreeLine: false,
  //       leading: Container(
  //         height: 65,
  //         width: 50,
  //         child: item.imageUrl == null
  //             ? PlaceHolderImage(item.name)
  //             : CachedNetworkImage(
  //                 imageUrl: IMAGE_URL + item.imageUrl,
  //                 fit: BoxFit.cover,
  //               ),
  //       ),
  //       title: Text(
  //         item.name?? 'N/A',
  //         style: TextStyle(
  //           fontFamily: 'Helvatica',
  //           fontSize: 18,
  //           color: Colors.white.withOpacity(0.87),
  //         ),
  //         maxLines: 1,
  //         overflow: TextOverflow.ellipsis,
  //       ),
  //       subtitle: Text(
  //               item.department,
  //               style: kSubtitle1),
  //       // trailing: IconButton(
  //       //   splashColor: Colors.transparent,
  //       //   icon: Icon(
  //       //     Icons.close,
  //       //     color: Colors.white.withOpacity(0.45),
  //       //   ),
  //       //   onPressed: () {
  //       //     Provider.of<Search>(context, listen: false)
  //       //         .removeSearchHistoryItem(index);
  //       //   },
  //       // ),
  //     ),
  //   );
  // }

  Widget _buildLoadingIndicator(BuildContext context) {
    return Center(
      child: widget.searchController.text.isEmpty
          ? null
          : SpinKitCircle(
              size: 21,
              color: Theme.of(context).accentColor,
            ),
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
                    key: PageStorageKey('MoviesResult'),
                    // controller: _scrollController,
                    padding: const EdgeInsets.only(
                        bottom: kToolbarHeight, left: 10, right: 10, top: 10),
                    physics: const BouncingScrollPhysics(
                        parent: const AlwaysScrollableScrollPhysics()),
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


