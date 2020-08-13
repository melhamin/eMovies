import 'package:e_movies/screens/movie/movie_details/widgets/bottom_icons/add_to_list_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/models/init_data.dart';
import 'package:e_movies/providers/lists.dart';
import 'package:e_movies/providers/search.dart';
import 'package:e_movies/screens/movie/movie_details/widgets/bottom_icons/toast_message_details.dart';

import '../../../../../my_toast_message.dart';


class BottomIcons extends StatelessWidget {
  final InitData initData;
  const BottomIcons({
    Key key,
    @required this.initData,
  }) : super(key: key);

  void _toggleFavorite(BuildContext context, bool isInfavorites) {
    if (isInfavorites) {
      Provider.of<Lists>(context, listen: false)
          .removeFavoriteMovie(initData.id);

      // ToastUtils.removeOverlay();
      ToastUtils.myToastMessage(
        context: context,
        alignment: Alignment.center,
        color: BASELINE_COLOR_TRANSPARENT,
        duration: Duration(seconds: TOAST_DURATION),
        child: ToastMessageDetails(
            icon: Icon(Icons.done,
                color: Colors.white.withOpacity(0.87), size: 70),
            message: 'Removed from Favorites'),
      );
    } else {
      Provider.of<Lists>(context, listen: false).addToFavoriteMovies(initData);
      // update top genre movies list
      Provider.of<Search>(context, listen: false).addToTopMovieGenres(initData);

      ToastUtils.myToastMessage(
        context: context,
        alignment: Alignment.center,
        color: Colors.transparent,
        duration: Duration(seconds: TOAST_DURATION),
        child: ToastMessageDetails(
          icon: Icon(Icons.favorite,
              color: Theme.of(context).accentColor, size: 80),
        ),
      );
    }
  }

  void _showAddToList(BuildContext context, InitData initData) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (context) => AddToListDialog(initData: initData),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isInFavorites = Provider.of<Lists>(context).isFavoriteMovie(initData);    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: DEFAULT_PADDING),
      decoration: BoxDecoration(
          color: ONE_LEVEL_ELEVATION,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            child: Icon(
              isInFavorites ? Icons.favorite : Icons.favorite_border,
              color: Theme.of(context).accentColor,
              size: 35,
            ),
            onTap: () => _toggleFavorite(context, isInFavorites),
          ),
          GestureDetector(
            child: Icon(
              Icons.add,
              color: Theme.of(context).accentColor,
              size: 35,
            ),
            onTap: () {
              _showAddToList(context, initData);
            },
          ),
          GestureDetector(
            child: Icon(
              Icons.share,
              color: Theme.of(context).accentColor,
              size: 35,
            ),
            onTap: () {},
          )
        ],
      ),
    );
  }
}
