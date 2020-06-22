import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/screens/movie/cast_details_screen.dart';
import 'package:e_movies/providers/cast.dart' as prov;

class CastItem extends StatelessWidget {
  final dynamic item;
  CastItem(this.item);

      Route _buildRoute() {
        return MaterialPageRoute(
      builder: (context) => CastDetails(),
      settings: RouteSettings(arguments: item)
    );        
    }

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

      void _onTap(BuildContext context) {
      Navigator.of(context).push(_buildRoute());
    }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => _onTap(context),
                  child: Card(
            elevation: 4,
            shadowColor: Colors.transparent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            child: CircleAvatar(
              radius: 35,
              backgroundColor: item.imageUrl == null
                  ? Theme.of(context).accentColor
                  : BASELINE_COLOR,
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








