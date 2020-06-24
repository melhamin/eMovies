import 'dart:math';
import 'package:flutter/material.dart';


class PlaceHolderImage extends StatelessWidget {
  @required
  final String title;
  PlaceHolderImage(this.title);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Transform.rotate(
            angle: - pi / 4,
            child: FittedBox(
              child: Text(title, style: TextStyle(
                fontSize: 28,
                
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.87)
              )),
            ),
          ),
        ),
      ),
    );
  }
}
