import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/consts/sysQuery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingIndicator extends StatelessWidget {
  final double size;
  LoadingIndicator({
    this.size = LOADING_INDICATOR_SIZE,
  });
  @override
  Widget build(BuildContext context) {
    // SysQuery().init(context);
    return SpinKitCircle(
      color: Theme.of(context).accentColor,
      size: size,
    );
    // SysQuery.isIOS
    //     ? CupertinoActivityIndicator()
    //     : SpinKitCircle(
    //         color: Theme.of(context).accentColor,
    //         size: 21,
    //       );
  }
}
