import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/models/actor_model.dart';
import 'package:e_movies/screens/movie/cast/cast_details_screen.dart';
import 'package:e_movies/widgets/placeholder_image.dart';
import 'package:flutter/material.dart';

class SearchedActorItem extends StatelessWidget {
  final ActorModel item;
  SearchedActorItem(this.item);

  Route _buildRoute(ActorModel item) {

    return MaterialPageRoute(
      builder: (context) => CastDetails(),
      settings: RouteSettings(arguments: item)
    );  
   
  }
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.black,
      splashColor: Colors.transparent,
      onTap: () {
        Navigator.of(context).push(_buildRoute(item));
      },
      child: ListTile(
        // contentPadding: EdgeInsets.all(0),
        isThreeLine: false,
        leading: Container(
          height: 65,
          width: 50,
          child: item.imageUrl == null
              ? PlaceHolderImage(item.name)
              : CachedNetworkImage(
                  imageUrl: IMAGE_URL + item.imageUrl,
                  fit: BoxFit.cover,
                ),
        ),
        title: Text(
          item.name?? 'N/A',
          style: TextStyle(
            fontFamily: 'Helvatica',
            fontSize: 18,
            color: Colors.white.withOpacity(0.87),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
                item.department,
                style: kSubtitle1),
       
      ),
    );
  }
}