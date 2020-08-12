import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/models/init_data.dart';
import 'package:e_movies/models/tv_model.dart';
import 'package:e_movies/screens/tv/tv_details_screen.dart';
import 'package:e_movies/providers/search.dart';
import 'package:e_movies/widgets/placeholder_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchedTVItem extends StatelessWidget {
  final TVModel item;
  SearchedTVItem(this.item);

  Route _buildRoute([bool searchHistoryItem = false]) { 
    final initData = InitData.formObject(item)  ;
    return MaterialPageRoute(
      builder: (context) => TVDetailsScreen(),
      settings: RouteSettings(arguments: initData)
    );      
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.black,
      splashColor: Colors.transparent,
      onTap: () {
        Provider.of<Search>(context, listen: false).addToSearchHistory(item);
        Navigator.of(context).push(_buildRoute());
      },
      child: ListTile(
        isThreeLine: false,
        leading: Container(
          height: 65,
          width: 50,
          child: item.posterUrl == null
              ? PlaceHolderImage(item.title)
              : CachedNetworkImage(
                  imageUrl: item.posterUrl,
                  fit: BoxFit.cover,
                ),
        ),
        title: Text(
          item.title ?? 'N/A',
          style: TextStyle(
            fontFamily: 'Helvatica',
            fontSize: 18,
            color: Colors.white.withOpacity(0.87),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Row(
          children: <Widget>[
            Text(item.voteAverage == null ? 'N/A' : item.voteAverage.toString(),
                style: kSubtitle1),
            SizedBox(width: 5),
            Icon(Icons.favorite_border, color: Theme.of(context).accentColor)
          ],
        ),
        trailing: Text(
            item.date == null ? 'N/A' : item.date.year.toString(),
            style: kSubtitle1),
      ),
    );
  }
}
