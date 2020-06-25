import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/models/cast_model.dart';
import 'package:e_movies/models/init_data.dart';
import 'package:e_movies/models/review_model.dart';
import 'package:e_movies/models/tv_model.dart';
import 'package:e_movies/my_toast_message.dart';
import 'package:e_movies/providers/lists.dart';
import 'package:e_movies/screens/movies_lists.dart';
import 'package:e_movies/screens/my_lists_screen.dart';
import 'package:e_movies/screens/video_page.dart';
import 'package:e_movies/widgets/back_button.dart';
import 'package:e_movies/widgets/expandable_text.dart';
import 'package:e_movies/widgets/movie/cast_item.dart';
import 'package:e_movies/providers/tv.dart';
import 'package:e_movies/widgets/image_clipper.dart';
import 'package:e_movies/widgets/image_view.dart';
import 'package:e_movies/widgets/movie/details_item.dart';
import 'package:e_movies/widgets/movie/movie_item.dart';
import 'package:e_movies/widgets/placeholder_image.dart';
import 'package:e_movies/widgets/review_item.dart';
import 'package:e_movies/screens/search/all_actors_screen.dart';
import 'package:flutter/cupertino.dart';
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

class _TVDetailsScreenState extends State<TVDetailsScreen> with AutomaticKeepAliveClientMixin {
  bool _initLoaded = true;
  bool _isLoading = true;
  InitData initData;
  TVModel details;

  // prov.TVItem initData;

  TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    if (_initLoaded) {
      initData = ModalRoute.of(context).settings.arguments as InitData;
      Provider.of<TV>(context, listen: false)
          .getDetails(initData.id)
          .then((value) {
        setState(() {
          // Get film item
          details = Provider.of<TV>(context, listen: false).details;
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
                      
                    ),
                    autofocus: true,
                    textInputAction: TextInputAction.go,
                    onFieldSubmitted: (val) {
                      Provider.of<Lists>(context, listen: false)
                          .addNewTVList(_textEditingController.text);
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
                          .addNewTVList(_textEditingController.text, true);
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

  void _addNewItemtoList(BuildContext context, int index, InitData item) {
    final result =
        Provider.of<Lists>(context, listen: false).addNewTVToList(index, item);
    if (result) {
      Navigator.of(context).pop();
      ToastUtils.myToastMessage(
          context: context,
          alignment: Alignment.center,
          color: BASELINE_COLOR_TRANSPARENT,
          duration: Duration(seconds: TOAST_DURATION),
          child: _buildToastMessageIcons(
              Icon(Icons.done, color: Colors.white.withOpacity(0.87), size: 50),
              'Item added.'));
    } else {
      ToastUtils.myToastMessage(
          context: context,
          alignment: Alignment.center,
          color: BASELINE_COLOR_TRANSPARENT,
          duration: Duration(seconds: TOAST_DURATION),
          child: _buildToastMessageIcons(
              Icon(Icons.warning,
                  color: Colors.white.withOpacity(0.87), size: 50),
              'Item is already in the list.'));
    }
  }

  void _showAddToList(BuildContext context, InitData initData) {    
    showModalBottomSheet(
      backgroundColor: BASELINE_COLOR,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
      ),
      isScrollControlled: true,
      // enableDrag: true,
      context: context,
      builder: (context) => Container(
           decoration: BoxDecoration(          
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),          
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [       
            FittedBox(child: CloseButton(color: Colors.white.withOpacity(0.87), )),                
            Flexible(
              child: Container(
                // padding: const EdgeInsets.only(top: 20),
                child: MyLists(mediaType: MediaType.TV ,initData: initData, isOut: true),
              ),
            ),
          ],
        ),
        height: MediaQuery.of(context).size.height * 0.85,
      ),    
    );
  }

  Widget _buildBottomIcons() {
    final isInFavorites = Provider.of<Lists>(context).isFavoriteTV(initData);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: LEFT_PADDING),
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
              isInFavorites ? Icons.favorite: Icons.favorite_border,
              color: Theme.of(context).accentColor,
              size: 35,
            ),
            onPressed: () => _toggleFavorite(isInFavorites),
          ),
          GestureDetector(
            child: Icon(
              Icons.add,
              color: Theme.of(context).accentColor,
              size: 35,
            ),
            onTap: () => _showAddToList(context, initData),
          ),
          IconButton(
            icon: Icon(
              Icons.share,
              color: Theme.of(context).accentColor,
              size: 35,
            ),
            onPressed: () {},
          )
        ],
      ),
    );
  }

  Widget _buildImages(TVModel item) {
    List<String> images = [];
    if (item.images != null) {
      item.images.forEach((element) {
        images.add(IMAGE_URL + element['file_path']);
      });
    }

    return item.images.length > 0
        ? GridView.builder(            
            padding: EdgeInsets.symmetric(horizontal: LEFT_PADDING),
            // controller: _scrollController,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(_buildRoute(ImageView(images)));
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
    print('ids ---------> $ids');
    if (ids == null || ids.length == 0) return 'N/A';
    int length = ids.length <= 2 ? ids.length : 2;
    String res = '';
    for (int i = 0; i < length; i++) {
      res = res + ids[i]['name'] + ', ';
      print('i ----> $i id[i] ------> ${ids[i]}');
    }
    res = res.substring(0, res.lastIndexOf(','));
    return res;
  }

  Widget _buildDetails(TVModel item) {
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

  Route _buildRoute(Widget toPage, [dynamic args]) {
    return MaterialPageRoute(
      builder: (context) => toPage,
      settings: RouteSettings(arguments: args),
    );      
  }

  List<Widget> _buildCast() {    
    List<CastModel> cast = [];
    if (details.cast != null) {
      details.cast.forEach((element) {
        cast.add(CastModel(
          id: element['id'],
          name: element['name'],
          character: element['character'],
          imageUrl: element['profile_path'],
          job: element['job'],
        ));
      });
    }

    return cast.isEmpty
        ? [Container()]
        : [
            Padding(
              padding: const EdgeInsets.only(
                  left: LEFT_PADDING, bottom: 5, right: LEFT_PADDING),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Cast', style: kSubtitle1),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .push(_buildRoute(CastDetailsScreen(cast)));
                    },
                    child: Row(
                      children: [
                        Text('Details', style: kSeeAll),
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
            ),
            Container(
              color: ONE_LEVEL_ELEVATION,
              height: 110,
              child: Cast(cast: cast),
            ),
          ];
  }

  Widget _buildSimilar(BoxConstraints constraints) {
    // get similar movies
    List<TVModel> similar = [];
    if (details.similar != null) {
      details.similar.forEach((element) {
        similar.add(TVModel.fromJson(element));
      });
    }
    return similar.isEmpty
        ? Container()
        : Container(
            height: constraints.maxHeight * 0.3,
            child: SimilarTV(similar),
          );
  }

  List<Widget> _buildReviews() {
    List<ReviewModel> reviews = [];
    if (details.reviews != null) {
      details.reviews.forEach((element) {
        reviews.add(ReviewModel.fromJson(element));
      });
    }
    return [
      if (reviews.isNotEmpty)
        Padding(
          padding: EdgeInsets.only(left: LEFT_PADDING, bottom: 5, top: 30),
          child: Text('Reviews', style: kSubtitle1),
        ),
      Reviews(reviews),
    ];
  }

  List<Widget> _buildOtherDetails(BoxConstraints constraints, int id) {
    // print('all ---------------------> ${details.genreIDs}');
    return [
      if (details.images != null && details.images.length > 0)
        Container(
            height: constraints.maxHeight * 0.2, child: _buildImages(details)),
      SizedBox(height: 15),
      _buildDetails(details),
      SizedBox(height: 30),
      ..._buildCast(),
      SizedBox(height: 20),
      _buildSimilar(constraints),
      ..._buildReviews(),
      SizedBox(height: 5),
    ];
  }

  Widget _buildToastMessageIcons(Icon icon, String message,
      [double iconSize = 50]) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        icon,
        SizedBox(height: 15),
        Text(
          message,
          style: TextStyle(
            
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white.withOpacity(0.87),
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }

  void _toggleFavorite(bool isInfavorites) {
    if (isInfavorites) {
      Provider.of<Lists>(context, listen: false)
          .removeFavoriteMovie(initData.id);

      // ToastUtils.removeOverlay();
      ToastUtils.myToastMessage(
        context: context,
        alignment: Alignment.center,
        color: BASELINE_COLOR_TRANSPARENT,
        duration: Duration(seconds: TOAST_DURATION),
        child: _buildToastMessageIcons(
            Icon(Icons.done, color: Colors.white.withOpacity(0.87), size: 70),
            'Removed from Favorites'),
      );
    } else {
      Provider.of<Lists>(context, listen: false).addToFavoriteTVs(initData);
      // ToastUtils.removeOverlay();
      ToastUtils.myToastMessage(
        context: context,
        alignment: Alignment.center,
        color: Colors.transparent,
        duration: Duration(seconds: TOAST_DURATION),
        child: _buildToastMessageIcons(
            Icon(Icons.favorite,
                color: Theme.of(context).accentColor, size: 80),
            ''),
      );
    }
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
    super.build(context);
    final initData = ModalRoute.of(context).settings.arguments as InitData;
    print('id --------> ${initData.id}');
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        body: Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                // print('tv details -----------> ${constraints.maxWidth}');
                return ListView(
                  // padding: const EdgeInsets.only(top: APP_BAR_HEIGHT),
                  addAutomaticKeepAlives: true,
                  
                  children: [
                    BackgroundImage(
                        id: initData.id,
                        imageUrl: initData.posterUrl,
                        constraints: constraints),
                    TitleAndDetails(
                        initData: initData, constraints: constraints),
                    // SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: LEFT_PADDING),
                      child: Text('Storyline', style: kTitleStyle2),
                    ),
                    _isLoading
                        ? Container(
                            height: constraints.maxHeight * 0.22,
                            child: _buildLoadingIndicator(context),
                          )
                        : Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: LEFT_PADDING),
                            child: Overview(
                                constraints: constraints,
                                overview: details.overview),
                          ),
                    Container(
                      height: constraints.maxHeight * 0.1,
                      child: _buildBottomIcons(),
                    ),
                    SizedBox(height: 15),
                    if (!_isLoading)
                      ..._buildOtherDetails(constraints, initData.id),
                  ],
                );
              },
            ),
            Positioned(
              top: 10,
              left: 10,
              child: CustomBackButton(),
            ),
          ],
        ),
      ),
    );
  }

  @override  
  bool get wantKeepAlive => true;
}

class TitleAndDetails extends StatelessWidget {
  const TitleAndDetails({
    Key key,
    @required this.initData,
    @required this.constraints,
  }) : super(key: key);

  final InitData initData;
  final BoxConstraints constraints;

  List<Widget> _buildGenres(List<dynamic> genres) {
    // print('build genres --------------');
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
        padding:const EdgeInsets.symmetric(horizontal: 2),
        margin: const EdgeInsets.only(right: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: kTextBorderColor, width: 2)),
        child: Text(
          genreNames[i],
          style: kSubtitle1,
        ),
      ));
    }
    // print('genres end ----------------');
    return res;
  }

  @override
  Widget build(BuildContext context) {
    // print('initData ------> ${InitData.toJson(initData)}');
    return Container(
      // color: Colors.red,
      height: constraints.maxHeight * 0.15,
      padding: const EdgeInsets.only(left: LEFT_PADDING),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: initData.title,
              style: kTitleStyle,
              children: [
                TextSpan(
                    text: ' ${initData.releaseDate.year}', style: kSubtitle1),
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
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: [..._buildGenres(initData.genreIDs)],
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.favorite_border, color: Theme.of(context).accentColor),
              SizedBox(width: 5),
              Text(
                '${initData.voteAverage} (${initData.voteCount} votes)',
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
    this.id,
  }) : super(key: key);

  final int id;
  final String imageUrl;
  final BoxConstraints constraints;

  Route _buildRoute(Widget toPage) {
    return MaterialPageRoute(
      builder: (context) => toPage,
      settings: RouteSettings(arguments: [id, MediaType.TV])
    );      
  }

  @override
  Widget build(BuildContext context) {
    // print('background ------> ');
    return Container(
      height: constraints.maxHeight * 0.5,
      width: constraints.maxWidth,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipPath(
            clipper: ImageClipper(),
            child: Container(
              height: constraints.maxHeight * 0.5,
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
            bottom: 0,
            right: 30,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(_buildRoute(VideoPage()));
              },
              // child: Image.asset('assets/icons/play.gif'),
              child: SvgPicture.asset(
                'assets/icons/play.svg',
                color: Theme.of(context).accentColor,
                height: 80,
              ),
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
    with AutomaticKeepAliveClientMixin {
  bool _expanded = false;

  void onTap() => setState(() => _expanded = true);

  int getLength() {
    double maxHeight = widget.constraints.maxHeight * 0.22 - 18;
    double maxWidth = widget.constraints.maxWidth - 2 * LEFT_PADDING;// padding of two sides
    // divide available width by 6(width of a character)
    int charInOneLine = (maxWidth ~/ 6);
    // divide number of lines by 32(font with size 16 and lineHeight 1.5, which is 32)
    int noOfLines = maxHeight ~/ 32;

    return charInOneLine * noOfLines;
  }

  @override
  Widget build(BuildContext context) {
    // print('legth ------> ${getLength()}');
    super.build(context);
    RegExp pattern = new RegExp(r'\n', caseSensitive: false);
    final overview = widget.overview.replaceAll(pattern, '');
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      constraints: _expanded
          ? BoxConstraints(
              maxHeight: 400,
              minHeight: widget.constraints.maxHeight * 0.22,
            )
          : BoxConstraints(
              minHeight: widget.constraints.maxHeight * 0.22,
              maxHeight: widget.constraints.maxHeight * 0.22,
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
            trimMode: TrimMode.Length,
            trimLength: getLength(),
          ),
        ),
      ),
    );   
  }

  @override
  bool get wantKeepAlive => true;
}

class Cast extends StatelessWidget {
  final List<CastModel> cast;
  Cast({this.cast});
  @override
  Widget build(BuildContext context) {
    // print('cast ------> ');
    return Column(
      children: [
        if (cast != null && cast.length > 0)
          Flexible(
            child: GridView.builder(
              
              itemCount: cast.length,
              itemBuilder: (context, index) {
                CastModel item = cast[index];
                return CastItem(
                  item,
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
  }
}

class SimilarTV extends StatelessWidget {
  final List<TVModel> similar;
  SimilarTV(this.similar);

  @override
  Widget build(BuildContext context) {
    // print('similar ------> ');
    return LayoutBuilder(
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
                  padding: EdgeInsets.symmetric(horizontal: LEFT_PADDING),
                  itemCount: similar.length,
                  itemBuilder: (context, index) {
                    return MovieItem(
                      item: similar[index],
                      withoutDetails: true,
                    );
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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

class Reviews extends StatelessWidget {
  final List<ReviewModel> reviews;
  Reviews(this.reviews);
  @override
  Widget build(BuildContext context) {
    // print('reviews ------> ');
    return ListView.separated(
      separatorBuilder: (_, i) => SizedBox(height: 10),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: reviews.length,
      itemBuilder: (_, i) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: LEFT_PADDING),
          color: ONE_LEVEL_ELEVATION,
          child: ReviewItem(
            item: reviews[i],
          ),
        );
      },
    );
  }
}
