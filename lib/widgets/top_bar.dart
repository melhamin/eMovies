import 'package:flutter/material.dart';
class TopBar extends StatelessWidget {
  @required final String title;

  TopBar(this.title);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        height: kToolbarHeight,
        decoration: BoxDecoration(
          color: Colors.black54,
          // color: BASELINE_COLOR_TRANSPARENT,
          // backgroundBlendMode: BlendMode.dstIn,
        ),
        child: Row(
          children: [
            BackButton(color: Colors.white),
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