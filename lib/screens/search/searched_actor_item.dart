import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/screens/movie/cast_details_screen.dart';
import 'package:e_movies/providers/search.dart';
import 'package:e_movies/widgets/placeholder_image.dart';
import 'package:flutter/material.dart';

class SearchedActorItem extends StatelessWidget {
  final ActorItem item;
  SearchedActorItem(this.item);

  Route _buildRoute(ActorItem item) {
   
    return PageRouteBuilder(
      settings: RouteSettings(arguments: item),
      pageBuilder: (context, animation, secondaryAnimation) => CastDetails(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(
            1, 0); // if x > 0 and y = 0 transition is from right to left
        var end =
            Offset.zero; // if y > 0 and x = 0 transition is from bottom to top
        // var curve = Curves.bounceIn;
        var tween =
            Tween(begin: begin, end: end); // .chain(CurveTween(curve: curve))
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
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