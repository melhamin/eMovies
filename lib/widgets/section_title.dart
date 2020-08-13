import 'package:e_movies/consts/consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SectionTitle extends StatelessWidget {
  final String title;
  final bool withSeeAll;
  final Function onTap;
  final double topPadding;
  final double bottomPadding;
  const SectionTitle({
    @required this.title,
    this.withSeeAll = true,
    this.onTap,
    this.topPadding = 30,
    this.bottomPadding = 0,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: DEFAULT_PADDING,
        right: DEFAULT_PADDING,
        top: topPadding,
        bottom: bottomPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                
                fontSize: 16,
                // fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.87),
              )),
          if (withSeeAll)
            CupertinoButton(
              onPressed: onTap,
              padding: const EdgeInsets.all(0),
              child: Row(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text('See All', style: kSeeAll)),
                  SizedBox(width: 3),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white.withOpacity(0.6),
                    size: 16,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}