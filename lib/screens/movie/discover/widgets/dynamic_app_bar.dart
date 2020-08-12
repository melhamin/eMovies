import 'package:e_movies/consts/consts.dart';
import 'package:flutter/material.dart';

class DynamicAppBar extends StatelessWidget {
  const DynamicAppBar({
    Key key,
    @required ScrollController scrollController,
    @required BoxConstraints constraints,
  })  : _scrollController = scrollController,
        constraints = constraints,
        super(key: key);

  final ScrollController _scrollController;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    double sectionHeight = constraints.maxHeight * 0.35;
    return Positioned(
      child: StatefulBuilder(
        builder: (ctx, thisState) {
          _scrollController.addListener(() {
            thisState(() {});
          });
          String getTitle() {
            if (_scrollController.position.pixels <
                (3 * (sectionHeight + 40) +
                        constraints.maxHeight * 0.3 + // in Thaters grid height
                        constraints.maxHeight *
                            0.15 + // Popular Actors section height
                        constraints.maxHeight * 0.2) + // forKids height
                    160) // Height of 'Discover', each section, padding, and SizedBoxs used
              return 'Movies';
            else
              return 'TV Shows';
          }

          return _scrollController.position.pixels <= 40
              ? Container()
              : Container(
                  height: 50,
                  color: BASELINE_COLOR,
                  child: Center(
                    child: Text(
                      getTitle(),
                      style: kTitleStyle,
                    ),
                  ),
                );
          //  TopBar(title: getTitle());
        },
      ),
    );
  }
}