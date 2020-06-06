import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/providers/cast.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class TempCast extends StatelessWidget {
  final CastItem item;
  TempCast(this.item);

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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Card(
          elevation: 4,
          shadowColor: Colors.white24,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          child: CircleAvatar(
            radius: 40,
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
        ),
        SizedBox(height: 2),
        Text(item.name,
            style: TextStyle(
              fontFamily: 'Helvatica',
              // fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Hexcolor('#FFFFFF').withOpacity(0.87),
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1),
      ],
    );
  }
}
