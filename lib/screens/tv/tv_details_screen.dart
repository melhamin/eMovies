import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/providers/cast.dart';
import 'package:e_movies/providers/lists.dart';
import 'package:e_movies/widgets/movie/cast_item.dart' as castWid;
import 'package:e_movies/providers/tv.dart' as prov;
import 'package:e_movies/widgets/image_clipper.dart';
import 'package:e_movies/widgets/image_view.dart';
import 'package:e_movies/widgets/movie/details_item.dart';
import 'package:e_movies/widgets/my_lists_item.dart';
import 'package:e_movies/widgets/placeholder_image.dart';
import 'package:e_movies/widgets/route_builder.dart';
import 'package:e_movies/widgets/top_bar.dart';
import 'package:e_movies/widgets/tv/tv_item.dart' as wid;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TVDetailsScreen extends StatefulWidget {
  @override
  _TVDetailsScreenState createState() => _TVDetailsScreenState();
}

class _TVDetailsScreenState extends State<TVDetailsScreen> {
  bool _initLoaded = true;
  bool _isLoading = true;
  prov.TVItem details;

  prov.TVItem initData;
  List<CastItem> cast = [];
  List<CastItem> crew = [];

  TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    if (_initLoaded) {
      final tv = ModalRoute.of(context).settings.arguments as prov.TVItem;
      Provider.of<prov.TV>(context, listen: false)
          .getDetails(tv.id)
          .then((value) {
        setState(() {
          // Get film item
          details = Provider.of<prov.TV>(context, listen: false).details;
          _isLoading = false;
          _initLoaded = false;
        });
      });
    }
    _initLoaded = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  Widget _buildDialogButtons(String title, Function onTap,
      [bool leftButton = false]) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: ONE_LEVEL_ELEVATION,
            // border: Border(right: BorderSide(color: kTextBorderColor, width: 0.5)),
            borderRadius: BorderRadius.only(
              bottomLeft: leftButton
                  ? Radius.circular(20)
                  : Radius.circular(0), // add border radius to left
              bottomRight: leftButton
                  ? Radius.circular(0)
                  : Radius.circular(20), // and right accordingly
            )),
        height: 40,
        child: leftButton // only add right border to the left button
            ? Container(
                decoration: BoxDecoration(
                  border: Border(
                      right: BorderSide(color: kTextBorderColor, width: 0.5)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: FlatButton(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Helvatica',
                        color: Theme.of(context).accentColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: onTap,
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: FlatButton(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Helvatica',
                      color: Theme.of(context).accentColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: onTap,
                ),
              ),
      ),
    );
  }

  void _showAddNewListDialog(BuildContext context) {
    // _textEditingController.text = '${initData.title}';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ONE_LEVEL_ELEVATION,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 50,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Create New List', style: kTitleStyle),
              Text('Give a name for this new list', style: kBodyStyle),
            ],
          ),
        ),
        contentPadding: EdgeInsets.all(0),
        content: Container(
          height: 120,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: kTextBorderColor, width: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Form(
                  child: TextFormField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(left: 10),
                      hintText: 'Name',
                      hintStyle: kSubtitle1,
                      border: InputBorder.none,
                    ),
                    cursorColor: Theme.of(context).accentColor,
                    style: TextStyle(
                      color: Hexcolor('#DEDEDE'),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Helvatica',
                    ),
                    autofocus: true,
                    textInputAction: TextInputAction.go,
                    onFieldSubmitted: (val) {
                      Provider.of<Lists>(context, listen: false)
                          .addNewList(_textEditingController.text);
                      _textEditingController.clear();
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 40,
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(color: kTextBorderColor, width: 0.5))),
                // padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _buildDialogButtons('Cancel', () {
                      _textEditingController.clear();
                      Navigator.of(context).pop();
                    }, true),
                    _buildDialogButtons('Create', () {
                      Provider.of<Lists>(context, listen: false)
                          .addNewList(_textEditingController.text);
                      _textEditingController.clear();
                      Navigator.of(context).pop();
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddToList(BuildContext context, dynamic initData) {
    final lists = Provider.of<Lists>(context, listen: false).lists;
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.only(),
        decoration: BoxDecoration(
          // color: Colors.black,
          color: BASELINE_COLOR,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        height: MediaQuery.of(context).size.height * 0.85,
        child: ListView(
          children: <Widget>[
            Container(
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: ONE_LEVEL_ELEVATION,
              ),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.cen,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 82,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, top: 5),
                        child: Text(
                          'Cancel',
                          style: kBTStyle,
                        ),
                      ),
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Text('Add to List', style: kTitleStyle),
                  Spacer(
                    flex: 2,
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.75,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                padding: const EdgeInsets.only(top: 20, right: LEFT_PADDING),
                itemCount:
                    lists.length + 1, // since first element is New List button
                itemBuilder: (context, i) {
                  return i == 0
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width / 2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Theme.of(context).accentColor,
                              ),
                              child: FlatButton(
                                child: Text('New List', style: kTitleStyle),
                                onPressed: () => _showAddNewListDialog(context),
                              ),
                            ),
                          ),
                        )
                      : MyListsItem(
                          list: lists[i - 1],
                          onTap: () {
                            // print('i ----------> $i');
                            Provider.of<Lists>(context, listen: false)
                                .addNewItemToList(i - 1,
                                    initData); // (i - 1) because the first element is not lists element
                            Navigator.of(context).pop();
                          },
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomIcons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: ONE_LEVEL_ELEVATION,
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

  Widget _buildImages(prov.TVItem item) {
    List<String> images = [];
    if (item.images != null) {
      item.images.forEach((element) {
        images.add(IMAGE_URL + element['file_path']);
      });
    }

    return item.images.length > 0
        ? GridView.builder(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: LEFT_PADDING),
            // controller: _scrollController,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(BuildRoute.buildRoute(toPage: ImageView(images)));
                },
                child: CachedNetworkImage(
                  imageUrl: images[index],
                  fadeInCurve: Curves.fastOutSlowIn,
                  fit: BoxFit.cover,
                  placeholder: (context, url) {
                    return Center(
                      child: SpinKitCircle(
                        size: LOADING_INDICATOR_SIZE,
                        color: Theme.of(context).accentColor,
                      ),
                    );
                  },
                ),
              );
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 2 / 3,
              mainAxisSpacing: 3,
            ),
            scrollDirection: Axis.horizontal,
          )
        : null;
  }

  String _getGenres(List<dynamic> ids) {
    if (ids == null || ids.length == 0) return 'N/A';
    int length = ids.length <= 2 ? ids.length : 2;
    String res = '';
    for (int i = 0; i < length; i++) {
      res = res + TV_GENRES[ids[i]['id']] + ', ';
    }
    res = res.substring(0, res.lastIndexOf(','));
    return res;
  }

  Widget _buildDetails(prov.TVItem item) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 0.5, color: LINE_COLOR),
          top: BorderSide(color: LINE_COLOR, width: 0.5),
        ),
        color: ONE_LEVEL_ELEVATION,
      ),
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(0),
        physics: NeverScrollableScrollPhysics(),
        children: [
          DetailsItem(
            left: 'First Air Date',
            right: item.date != null
                ? DateFormat.yMMMd().format(item.date)
                : 'N/A',
          ),
          DetailsItem(
            left: 'In Production',
            right: item.inProduction ? 'Yes' : 'No',
          ),
          DetailsItem(
            left: 'Runtime',
            right: item.episodRuntime[0].toString() + ' min',
          ),
          DetailsItem(
            left: 'Rating',
            right: item.voteAverage.toString(),
          ),
          DetailsItem(
            left: 'Genres',
            right: _getGenres(item.genreIDs),
            last: true,
          ),
        ],
      ),
    );
  }

  // Widget _buildSimilar(BoxConstraints constraints) {
  //   bool hasItem = (Provider.of<prov.TV>(context).similar != null &&
  //       Provider.of<prov.TV>(context).similar.length > 0);
  //   if (!hasItem) {
  //     return Container();
  //   } else {
  //     return Container(
  //       height: constraints.maxHeight * 0.3,
  //       child: SimilarMovies(),
  //     );
  //   }
  // }

  List<Widget> _buildOtherDetails(BoxConstraints constraints, int id) {
    // print('all ---------------------> ${details.genreIDs}');
    return [
      if (details.images != null && details.images.length > 0)
        Container(
            height: constraints.maxHeight * 0.2, child: _buildImages(details)),
      SizedBox(height: 15),
      _buildDetails(details),
      SizedBox(height: 30),
      Padding(
        padding: const EdgeInsets.only(left: LEFT_PADDING, bottom: 5),
        child: Text('Cast', style: kSubtitle1),
      ),
      Container(
        color: ONE_LEVEL_ELEVATION,
        height: 110,
        child: Cast(details: details),
      ),
      SizedBox(height: 20),
      // _buildSimilar(constraints),
      Container(
        height: constraints.maxHeight * 0.3,
        child: SimilarTV(id),
      ),
      SizedBox(height: 5),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final item = ModalRoute.of(context).settings.arguments as prov.TVItem;
    // print('id ---------> ${item.id}');
    // print('id ---------> ${item.id}');

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
                    BackgroundImage(
                        imageUrl: item.posterUrl, constraints: constraints),
                    TitleAndDetails(item: item, constraints: constraints),
                    // SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: LEFT_PADDING),
                      child: Text('Storyline', style: kTitleStyle),
                    ),
                    Overview(constraints: constraints, overview: item.overview),
                    Container(
                      height: constraints.maxHeight * 0.1,
                      child: _buildBottomIcons(),
                    ),
                    SizedBox(height: 15),
                    if (!_isLoading)
                      ..._buildOtherDetails(constraints, item.id),
                  ],
                );
              },
            ),
            TopBar(title: item.title),
          ],
        ),
      ),
    );
  }
}

class TitleAndDetails extends StatelessWidget {
  const TitleAndDetails({
    Key key,
    @required this.item,
    @required this.constraints,
  }) : super(key: key);

  final prov.TVItem item;
  final BoxConstraints constraints;

  List<Widget> _buildGenres(List<dynamic> genres) {
    if (genres == null || genres.length == 0) return [];

    // some genres are not included in tvgenres list
    // but exist in movies genres list
    List<String> genreNames = [];
    genres.forEach((element) {
      genreNames.add(TV_GENRES[element] == null
          ? MOVIE_GENRES[element]
          : TV_GENRES[element]);
    });
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
          genreNames[i],
          style: kSubtitle1,
        ),
      ));
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      height: constraints.maxHeight * 0.15,
      padding: const EdgeInsets.only(left: LEFT_PADDING),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: item.title,
              style: kTitleStyle,
              children: [
                TextSpan(
                    text: item.date == null
                        ? 'N/A'
                        : ' (${item.date.year})',
                    style: kSubtitle1),
              ],
            ),
          ),
          // Text('${item.name} (${item.firstAirDate.year})',
          //     style: kTitleStyle),
          SizedBox(height: 10),
          // Text(' 45 min', style: kSubtitle1),
          Container(
            height: 22,
            padding: const EdgeInsets.only(right: LEFT_PADDING),
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: [
                ..._buildGenres(item.genreIDs),
              ],
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.favorite_border, color: Theme.of(context).accentColor),
              SizedBox(width: 5),
              Text(
                '${item.voteAverage.toString()} (${item.voteCount.toString()} votes)',
                style: kSubtitle1,
              ),
            ],
          ),
        ],
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
    return Container(
      height: constraints.maxHeight * 0.4,
      width: constraints.maxWidth,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipPath(
            clipper: ImageClipper(),
            child: Container(
              height: constraints.maxHeight * 0.4,
              width: constraints.maxWidth,
              child: imageUrl == null
                  ? PlaceHolderImage('Image Not Available')
                  : CachedNetworkImage(
                      imageUrl: imageUrl,
                      fadeInCurve: Curves.easeIn,
                      fit: BoxFit.fill,
                    ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 30,
            child: SvgPicture.asset(
              'assets/icons/play.svg',
              color: Theme.of(context).accentColor,
              height: 80,
            ),
          ),
        ],
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
    RegExp pattern = new RegExp(r'\n', caseSensitive: false);
    final overview = widget.overview.replaceAll(pattern, '');
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
                maxHeight: widget.constraints.maxHeight * 0.32 - APP_BAR_HEIGHT)
            : BoxConstraints(
                minHeight: widget.constraints.maxHeight * 0.32 -
                    APP_BAR_HEIGHT, // otherwise bottom icons will move up if text length is small
              ),
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
                        text: overview.length > 230
                            ? overview.substring(0, 230) + '...'
                            : overview,
                        children: [
                          if (!_expanded && overview.length > 230)
                            TextSpan(
                              text: 'More',
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
                            ),
                        ],
                      ),
                    ),
                  )
                : Text(overview, style: kBodyStyle)),
      ),
    );
  }
}

class Cast extends StatefulWidget {
  final prov.TVItem details;
  Cast({this.details});
  @override
  _CastState createState() => _CastState();
}

class _CastState extends State<Cast> with AutomaticKeepAliveClientMixin {
  bool _expanded = false;
  List<CastItem> crew = [];
  List<CastItem> cast = [];

  @override
  void initState() {
    super.initState();
    // get Crew data
    print('details crew/ ---------> ${widget.details.crew} ');
    if (widget.details.crew != null) {
      widget.details.crew.forEach((element) {
        print('crew/ ---------> ${element['character']} ');
        crew.add(CastItem(
          id: element['id'],
          name: element['name'],
          imageUrl: element['profile_path'],
          job: element['job'],
        ));
      });
    }
    // Get cast data
    if (widget.details.cast != null) {
      widget.details.cast.forEach((element) {
        print('cast/ ---------> ${element['character']} ');
        cast.add(CastItem(
          id: element['id'],
          name: element['name'],
          imageUrl: element['profile_path'],
          character: element['character'],
        ));
      });
    }
  }

  // Get the name abbreviation for circle avatar in case image is not available
  String _getName(String str) {
    String res = '';
    List<String> name = str.split(' ');
    res = res + name[0][0].toUpperCase() + name[1][0].toUpperCase();
    return res;
  }

  void _onTap() {
    setState(() {
      _expanded = true;
    });
  }

  // finds whether at index (index) is the last item
  // and draw bottom border accroding to it
  bool _isLasItem(int index) {
    return (!_expanded
        ? (index == 4 ? true : false)
        : (index == _calcualteItemCount() - 1 ? true : false));
  }

  // Calculate number of items in different situations
  int _calcualteItemCount() {
    return cast.length > 5
        ? (_expanded ? (cast.length > 10 ? 10 : cast.length) : 5)
        : cast.length;

    // if (widget.cast.length > 5) {
    //   if (_expanded) {
    //     if (widget.cast.length > 10) {
    //       return 10;
    //     } else {
    //       return widget.cast.length;
    //     }
    //   } else
    //     return 5;
    // }
    // return widget.cast.length;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // print('Cast ----------------------> ${cast}');
    // print('crew ----------------------> ${crew}');

    CastItem director;
    if (crew.length != 0)
      director = crew.firstWhere((element) {
        return element.job == 'Executive Producer';
      }, orElse: () {});
    return Column(
      children: [       
        if (cast != null && cast.length > 0)
          
        Flexible(
                  child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: _calcualteItemCount(),
            itemBuilder: (context, index) {
              CastItem item = cast[index];
              return castWid.CastItem(
                id: item.id,
                name: item.name,
                imageUrl: item.imageUrl,
              );
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              // mainAxisSpacing: 5,
            ),
            scrollDirection: Axis.horizontal,
          ),
        ),
      ],
    );

    // SingleChildScrollView(
    //   child: Column(
    //     mainAxisSize: MainAxisSize.min,
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       // if (director != null)
    //       //   Padding(
    //       //     padding: const EdgeInsets.only(left: LEFT_PADDING, bottom: 5),
    //       //     child: Text('Directed By', style: kSubtitle1),
    //       //   ),
    //       // if (director != null)
    //       //   Container(
    //       //     decoration: BoxDecoration(
    //       //       border: Border(
    //       //         bottom: BorderSide(width: 0.5, color: LINE_COLOR),
    //       //         top: BorderSide(width: 0.5, color: LINE_COLOR),
    //       //       ),
    //       //       color: ONE_LEVEL_ELEVATION,
    //       //     ),
    //       //     child: castWid.CastItem(
    //       //       item: director
    //       //       // item: director,
    //       //       // last: false,
    //       //       // subtitle: false,
    //       //     ),
    //       //   ),
    //       if (cast != null && cast.length > 0) SizedBox(height: 20),
    //       if (cast != null && cast.length > 0)
    //         Padding(
    //           padding: const EdgeInsets.only(left: LEFT_PADDING, bottom: 5),
    //           child: Text('Cast', style: kSubtitle1),
    //         ),
    //       if (cast != null && cast.length > 0)
    //         AnimatedContainer(
    //           duration: Duration(milliseconds: 300),
    //           height: _calcualteItemCount() * 60.0 +
    //               _calcualteItemCount() * 5, // ListTile height
    //           decoration: BoxDecoration(
    //             border: Border(
    //               bottom: BorderSide(width: 0.5, color: LINE_COLOR),
    //               top: BorderSide(width: 0.5, color: LINE_COLOR),
    //             ),
    //             color: ONE_LEVEL_ELEVATION,
    //           ),
    //           child: ListView.builder(
    //             physics: const BouncingScrollPhysics(),
    //             itemCount: _calcualteItemCount(),
    //             itemBuilder: (context, index) {
    //               CastItem item = cast[index];
    //               return castWid.CastItem(
    //                 item: item,
    //               );
    //             },
    //             scrollDirection: Axis.horizontal,
    //           ),
    //         ),
    //       if ((cast.length > 5))
    //         ListTile(
    //           leading: Text(
    //             (!_expanded) ? 'More...' : '',
    //             style: TextStyle(color: Theme.of(context).accentColor),
    //           ),
    //           onTap: !_expanded ? _onTap : null,
    //         ),
    //     ],
    //   ),
    // );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class SimilarTV extends StatefulWidget {
  final id;
  SimilarTV(this.id);
  @override
  _SimilarTVState createState() => _SimilarTVState();
}

class _SimilarTVState extends State<SimilarTV> {
  bool _initLoaded = true;
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_initLoaded) {
      Provider.of<prov.TV>(context, listen: false)
          .getSimilar(widget.id)
          .then((value) {
        setState(() {
          _isLoading = false;
          _initLoaded = false;
        });
      });
    }
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    return Center(
      child: SpinKitCircle(
        size: 21,
        color: Theme.of(context).accentColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = Provider.of<prov.TV>(context, listen: false).similar;
    print('TV simialr size ----------------------> ${items.length}');
    return _isLoading
        ? _buildLoadingIndicator(context)
        : (items.length == 0)
            ? Container()
            : LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    height: constraints.maxHeight * 0.5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: LEFT_PADDING),
                          child: Text('Similar', style: kSubtitle1),
                        ),
                        SizedBox(height: 5),
                        Flexible(
                          child: GridView.builder(
                            physics: BouncingScrollPhysics(),
                            padding:
                                EdgeInsets.symmetric(horizontal: LEFT_PADDING),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              return wid.TVItem(
                                item: items[index],
                                withoutDetails: true,
                              );
                            },
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              childAspectRatio: 3 / 2,
                              mainAxisSpacing: 10,
                            ),
                            scrollDirection: Axis.horizontal,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
  }
}
