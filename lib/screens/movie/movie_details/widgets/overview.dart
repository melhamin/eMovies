import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/models/movie_model.dart';
import 'package:e_movies/widgets/expandable_text.dart';
import 'package:flutter/material.dart';

class Overview extends StatefulWidget {
  const Overview({
    Key key,
    @required this.initData,
    @required this.constraints,
  }) : super(key: key);

  final MovieModel initData;
  final BoxConstraints constraints;

  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview>
    with AutomaticKeepAliveClientMixin {
  bool _expanded = false;

  void onTap() => setState(() => _expanded = true);

  int getLength() {
    double maxHeight = widget.constraints.maxHeight * 0.3;
    double maxWidth = widget.constraints.maxWidth -
        2 * DEFAULT_PADDING; // padding of two sides
    // divide available width by 6(width of a character)
    int charInOneLine = (maxWidth ~/ 6);
    // divide number of lines by 32(font with size 16 and lineHeight 1.5, which is 32)
    int noOfLines = maxHeight ~/ 32;

    return charInOneLine * noOfLines;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    RegExp pattern = new RegExp(r'\n', caseSensitive: false);
    final overview = widget.initData.overview.replaceAll(pattern, '');
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      constraints: _expanded
          ? BoxConstraints(
              maxHeight: 400,
              minHeight: widget.constraints.maxHeight * 0.3,
            )
          : BoxConstraints(
              minHeight: widget.constraints.maxHeight * 0.3,
              maxHeight: widget.constraints.maxHeight * 0.3,
            ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: SizedBox(
          child: ExpandableText(
            overview,
            style: kBodyStyle,
            onTap: onTap,
            trimExpandedText: '',
            trimCollapsedText: '...More',
            // trimLines: 7,
            trimLength: getLength(),
            trimMode: TrimMode.Length,
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}