import 'package:flutter/material.dart';
 class BuildRoute extends Route {
  @required final Widget toPage;
  Object arguments;
  BuildRoute({this.toPage, this.arguments = 0});
  
  // @override
  static Route buildRoute ({Widget toPage, Object arguments}) { 
    return PageRouteBuilder(
      settings: RouteSettings(
        arguments: arguments
      ),
      pageBuilder: (context, animation, secondaryAnimation) => toPage,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(
            1, 0); // if x > 0 and y = 0 transition is from right to left
        var end =
            Offset.zero; // if y > 0 and x = 0 transition is from bottom to top
        var tween = Tween(begin: begin, end: end);
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}