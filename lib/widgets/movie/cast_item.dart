import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/screens/movie/cast_details_screen.dart';

class CastItem extends StatelessWidget {
  final dynamic item;
  CastItem(this.item);

  Route _buildRoute() {
    return MaterialPageRoute(
        builder: (context) => CastDetails(),
        settings: RouteSettings(arguments: item));
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
          child: item.imageUrl == null
              ? CircleAvatar(
                  radius: 35,
                  backgroundColor: Theme.of(context).accentColor,
                  child: Text(
                    _getName(item.name),
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                )
              : CachedNetworkImage(
                  color: BASELINE_COLOR,
                  imageUrl: IMAGE_URL + item.imageUrl,
                  imageBuilder: (ctx, imageProvider) => Card(
                    elevation: 4,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor: BASELINE_COLOR,
                      backgroundImage: imageProvider,
                    ),
                  ),
                ),
        ),
        SizedBox(height: 2),
        Text(item.name,
            style: TextStyle(
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
