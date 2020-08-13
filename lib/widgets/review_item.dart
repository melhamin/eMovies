import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/models/review_model.dart';
import 'package:e_movies/widgets/expandable_text.dart';
import 'package:flutter/material.dart';


class ReviewItem extends StatefulWidget {
  final ReviewModel item;
  ReviewItem({@required this.item});
  @override
  _ReviewItemState createState() => _ReviewItemState();
}

class _ReviewItemState extends State<ReviewItem> with AutomaticKeepAliveClientMixin{
  bool _expanded = false;
  void onTap() => setState(() => _expanded = true);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(widget.item.author, style: kBodyStyle2),
        SizedBox(height: 10),
        AnimatedContainer(
          duration: Duration(milliseconds: 400),
          constraints: _expanded
              ? BoxConstraints(maxHeight: 2000)
              : BoxConstraints(maxHeight: 100),
          child: ExpandableText(
            widget.item.content,
            style: kSubtitle1,
            onTap: onTap,
            trimExpandedText: '',
            trimCollapsedText: '...More',
            trimLines: 3,
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  @override  
  bool get wantKeepAlive => true;
}
