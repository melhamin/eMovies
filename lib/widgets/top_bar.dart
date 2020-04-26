import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class TopBar extends StatelessWidget {
  @required
  final String title;

  TopBar(this.title);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        height: kToolbarHeight,
        decoration: BoxDecoration(
          color: Colors.black54,
        ),
        child: Row(
          children: [                      
            BackButton(color: Hexcolor('#DEDEDE')),
            Expanded(
              child: Align(
                alignment: Alignment.center - Alignment(0.2, 0),
                child: Padding(
                  padding: const EdgeInsets.only(right: 3.0),
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.headline6,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}
