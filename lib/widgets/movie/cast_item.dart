import 'package:flutter/material.dart';

import 'package:e_movies/pages/movie/cast_details_screen.dart';
import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/providers/cast.dart' as prov;

class CastItem extends StatelessWidget {
  final prov.CastItem item;
  final bool subtitle;

  CastItem({
    this.item,
    this.subtitle = true,
  });

  @override
  Widget build(BuildContext context) {
    Route _buildRoute() {
      return PageRouteBuilder(
        settings: RouteSettings(
          arguments: item,
        ),
        pageBuilder: (context, animation, secondaryAnimation) => CastDetails(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = const Offset(
              1, 0); // if x > 0 and y = 0 transition is from right to left
          var end = Offset
              .zero; // if y > 0 and x = 0 transition is from bottom to top
          var tween = Tween(begin: begin, end: end);
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      );
    }

    void _onTap() {
      Navigator.of(context).push(_buildRoute());
    }

    // Get the name abbreviation for circle avatar in case image is not available
    String _getName(String str) {
      if (str == null || str.length == 0) return 'N/A';

      String res = '';
      List<String> name = str.split(' ');
      if (name.length >= 2)
        res = res + name[0][0].toUpperCase() + name[1][0].toUpperCase();
      else if (name.length == 1)
        res = res + name[0][0].toUpperCase();
      else
        res = 'N/A';

      return res;
    }

    // print('Cast item ---------> URL ------- $')

    return Container(
      margin: const EdgeInsets.only(left: LEFT_PADDING),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 0.5, color: LINE_COLOR),
        ),
      ),
      child: ListTile(
        onTap: _onTap,
        dense: true,
        contentPadding: const EdgeInsets.all(0),
        leading: CircleAvatar(
          backgroundColor: item.imageUrl == null
              ? Theme.of(context).accentColor
              : Colors.black,
          backgroundImage: item.imageUrl != null
              ? NetworkImage(IMAGE_URL + item.imageUrl)
              : null,
          child: item.imageUrl != null
              ? null
              : Text(
                  _getName(item.name),
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
        ),
        title: Text(
          item.name,
          style: kBodyStyle,
        ),
        subtitle: !subtitle
            ? Text('')
            : RichText(
                text: TextSpan(text: 'as ', style: kSubtitle2, children: [
                  TextSpan(
                      text: item.character,
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                      ))
                ]),
              ),
      ),
    );
  }
}
