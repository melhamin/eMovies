import 'package:e_movies/consts/consts.dart';
import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget {
  final Widget title;
  final Widget body;
  final Widget flexibleSpace;
  final double expandedHeight;
  final bool pinned;
  final bool floating;
  final bool snap;

  MyAppBar({
    @required this.body,
    this.title = const Text(''),
    this.flexibleSpace,
    this.expandedHeight = kToolbarHeight,
    this.pinned = false,
    this.floating = true,
    this.snap = true,
  });
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (ctx, _) {
        return [
          SliverAppBar(
            // leading: leading,
            automaticallyImplyLeading: false,
            centerTitle: true,
            // pinned: true,
            title: title, 
            floating: floating,
            pinned: pinned,
            snap: snap,
            backgroundColor: Colors.transparent,
            expandedHeight: expandedHeight,
            flexibleSpace: flexibleSpace ??
                Container(
                  height: kToolbarHeight,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      tileMode: TileMode.repeated,
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(0.1)
                      ],
                      stops: [5, 5],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                  ),
                ),
          ),
        ];
      },
      body: body,
    );
  }
}
