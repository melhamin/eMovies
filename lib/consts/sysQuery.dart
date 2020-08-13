import 'package:flutter/material.dart';

class SysQuery {
  MediaQueryData _mediaQueryData;
  static double screenWidht;   
  static double screenHeight;        
  static Orientation orientation;
  static bool isIOS;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidht = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
    isIOS = Theme.of(context).platform == TargetPlatform.iOS;
  }
}