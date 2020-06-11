import 'package:e_movies/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class DynamicAppBar extends StatefulWidget {
  final ScrollController controller;  

  DynamicAppBar(this.controller);
  @override
  _DynamicAppBarState createState() => _DynamicAppBarState();
}

class _DynamicAppBarState extends State<DynamicAppBar> {

  double position;  

  @override
  void initState() {    
    super.initState();
    widget.controller.addListener(() { 
      setState(() {
        position = widget.controller.position.pixels;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(        
        height: kToolbarHeight,
        decoration: BoxDecoration(
          color: ONE_LEVEL_ELEVATION
        ),
        child: Row(
          children: [
            // BackButton(color: Hexcolor('#DEDEDE')),
            Expanded(
              child: Align(
                alignment: Alignment.center - Alignment(0.2, 0),
                child: Padding(
                  padding: const EdgeInsets.only(right: 3.0),
                  child: Text(
                    position < kToolbarHeight ? 'Discover' : 'Movies',
                    style: kTitleStyle,
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