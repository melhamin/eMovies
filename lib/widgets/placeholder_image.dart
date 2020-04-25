import 'package:flutter/material.dart';

class PlaceHolderImage extends StatelessWidget {
  @required
  final String title;
  PlaceHolderImage(this.title);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).accentColor,
      // color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: FittedBox(
                      child: Text(title,
                style: TextStyle(
                  color: Colors.black,    
                  fontSize: 21,          
                )),
          ),
        ),
      ),
    );
  }
}
