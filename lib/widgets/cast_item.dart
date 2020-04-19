import 'package:e_movies/consts/consts.dart';
import 'package:flutter/material.dart';

class CastItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final bool last;

  CastItem({
    this.title,
    this.subtitle,
    this.imageUrl,
    this.last = false,
  });
  @override
  Widget build(BuildContext context) {
    // Get the name abbreviation for circle avatar in case image is not available
    String _getName(String str) {
      String res = '';
      List<String> name = str.split(' ');
      res = res + name[0][0].toUpperCase() + name[1][0].toUpperCase();
      return res;
    }

    return Container(
      margin: const EdgeInsets.only(left: PADDING),
      decoration: BoxDecoration(        
        border: Border(              
          bottom: !last
              ? BorderSide(width: 0.5, color: LINE_COLOR)
              : BorderSide(color: Colors.transparent, width: 0),
        ),
      ),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.all(0),
        visualDensity: VisualDensity.comfortable,
        leading: CircleAvatar(
          backgroundColor:
              imageUrl == null ? Theme.of(context).accentColor : Colors.black,
          backgroundImage:
              imageUrl != null ? NetworkImage(IMAGE_URL + imageUrl) : null,
          child: imageUrl != null
              ? null
              : Text(
                  _getName(title),
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.headline3,
        ),
        subtitle: RichText(
          text: TextSpan(text: 'as ', 
          style: Theme.of(context).textTheme.subtitle2,
          children: [
            TextSpan(
              text: subtitle,
              style: TextStyle(color: Colors.amber)
            )
          ]),
        ),
        // subtitle: Text(
        //   'as ' + subtitle,
        //   style: Theme.of(context).textTheme.subtitle2,
        // ),
      ),
    );
  }
}
