import 'package:e_movies/consts/consts.dart';
import 'package:flutter/material.dart';

class PlaceHolderImage extends StatelessWidget {
  @required
  final String title;
  PlaceHolderImage(this.title);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      // color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: FittedBox(
            child: Text(title,
                style: kTitleStyle),
          ),
        ),
      ),
    );
  }
}
