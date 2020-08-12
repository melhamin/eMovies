import 'package:e_movies/consts/consts.dart';
import 'package:flutter/material.dart';

class DetailsItem extends StatelessWidget {
  final String left;
  final String right;
  bool last;

  DetailsItem({
    this.left,
    this.right,
    this.last = false,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: DEFAULT_PADDING),
      decoration: BoxDecoration(
        border: Border(
          bottom: !last ? BorderSide(width: 0.5, color: LINE_COLOR):
            BorderSide(color: Colors.transparent, width: 0),
        ),
      ),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.all(0),        
        title: Text(left, style: kSubtitle1),
        trailing: Text(right, style: kBodyStyle),
      ),
    );
  }
}
