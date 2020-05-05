import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/providers/tv.dart' as prov;
import 'package:e_movies/widgets/image_clipper.dart';
import 'package:e_movies/widgets/top_bar.dart';
import 'package:e_movies/widgets/tv/tv_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

class TVDetailsScreen extends StatefulWidget {
  @override
  _TVDetailsScreenState createState() => _TVDetailsScreenState();
}

class _TVDetailsScreenState extends State<TVDetailsScreen> {
  List<Widget> _buildGenres(List<dynamic> genres) {
    if(genres == null || genres.length == 0) return [];
    List<Widget> res = [];
    int length = genres.length > 3 ? 3 : genres.length;
    for (int i = 0; i < length; i++) {
      res.add(Container(
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
        margin: EdgeInsets.only(right: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: kTextBorderColor, width: 2)),
        child: Text(
          TV_GENRES[genres[i]],
          style: kSubtitle1,
        ),
      ));
    }
    return res;
  }

  Widget _buildBottomIcons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: BASELINE_COLOR,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              Icons.favorite_border,
              color: Theme.of(context).accentColor,
              size: 30,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.add,
              color: Theme.of(context).accentColor,
              size: 30,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.share,
              color: Theme.of(context).accentColor,
              size: 30,
            ),
            onPressed: () {},
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = ModalRoute.of(context).settings.arguments as prov.TVItem;
    print('---------> ${item.id}');

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                // print('tv details -----------> ${constraints.maxWidth}');
                return ListView(
                  padding: const EdgeInsets.only(top: APP_BAR_HEIGHT),
                  physics: BouncingScrollPhysics(),
                  children: [
                    BackgroundImage(imageUrl: item.posterUrl, constraints: constraints),                    
                    Container(
                      // color: Colors.red,
                      height: constraints.maxHeight * 0.16,
                      padding: const EdgeInsets.only(left: LEFT_PADDING),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: item.name,
                              style: kTitleStyle,
                              children: [
                                TextSpan(
                                    text: ' (${item.firstAirDate.year})',
                                    style: kSubtitle1),
                              ],
                            ),
                          ),
                          // Text('${item.name} (${item.firstAirDate.year})',
                          //     style: kTitleStyle),
                          SizedBox(height: 5),
                          Text(' 45 min', style: kSubtitle1),
                          SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.only(right: LEFT_PADDING),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ..._buildGenres(item.genreIDs),
                              ],
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(Icons.favorite_border,
                                  color: Theme.of(context).accentColor),
                              SizedBox(width: 5),
                              Text(
                                '${item.voteAverage.toString()} (${item.voteCount.toString()} votes)',
                                style: kSubtitle1,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: LEFT_PADDING),
                      child: Text('Storyline', style: kTitleStyle),
                    ),
                    Overview(constraints: constraints, overview: item.overview),
                    Container(
                      height: constraints.maxHeight * 0.1,
                      child: _buildBottomIcons(),
                    ),
                  ],
                );
              },
            ),
            TopBar(title: item.name),
          ],
        ),
      ),
    );
  }
}

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({
    Key key,
    @required this.imageUrl,
    @required this.constraints,
  }) : super(key: key);

  final String imageUrl;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ImageClipper(),
      child: Container(
        height: constraints.maxHeight * 0.4,
        width: constraints.maxWidth,        
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        )),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fadeInCurve: Curves.easeIn,
          fit: BoxFit.cover,
        ),
        // ),
      ),
    );
  }
}

class Overview extends StatefulWidget {
  const Overview({
    Key key,
    @required this.overview,
    @required this.constraints,
  }) : super(key: key);

  final BoxConstraints constraints;
  final String overview;

  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: Duration(milliseconds: 300),
      vsync: this,
      curve: Curves.easeIn,
      child: Container(
        // color: Colors.blue,
        padding: const EdgeInsets.only(
            left: LEFT_PADDING, right: LEFT_PADDING, top: 10),
        constraints: !_expanded
            ? BoxConstraints(
                maxHeight: widget.constraints.maxHeight * 0.30 - APP_BAR_HEIGHT)
            : BoxConstraints(),
        child: GestureDetector(
            onTap: !_expanded
                ? () {
                    setState(() {
                      _expanded = true;
                    });
                  }
                : null, // only expandable when not expanded yet
            child: !_expanded
                ? SizedBox.expand(
                    child: RichText(
                      text: TextSpan(
                        style: kBodyStyle,
                        text: widget.overview.length > 220
                            ? widget.overview.substring(0, 220) + '...'
                            : widget.overview,
                        children: [
                          if (!_expanded && widget.overview.length > 220)
                            TextSpan(
                              text: 'More',
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
                            ),
                        ],
                      ),
                    ),
                  )
                : Text(widget.overview, style: kBodyStyle)),
      ),
    );
  }
}
