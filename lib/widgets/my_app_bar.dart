import 'package:e_movies/consts/consts.dart';
import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget {
  final String title;
  final Widget body;

  MyAppBar({
    @required this.title,
    @required this.body,
  });
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (ctx, _) {
        return [
          SliverAppBar(
            leading: BackButton(color: Colors.white),
            centerTitle: true,
            // pinned: true,
            title: Text(title, style: kTitleStyle),
            floating: true,
            pinned: false,
            snap: true,
            backgroundColor: Colors.transparent,
            expandedHeight: kToolbarHeight,
            flexibleSpace: Container(
              height: kToolbarHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  tileMode: TileMode.repeated,
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.1)
                  ],
                  stops: [
                    5,
                    5,
                  ],
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
