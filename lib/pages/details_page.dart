import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/providers/movies_provider.dart';

class DetailsPage extends StatefulWidget {
  static const routeName = '/details-page';
  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  // MovieItem film;
  bool _isInitLoaded = true;
  bool _isFetching = true;

  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration.zero).then((_) {
    //   final args =
    //       ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    //   final id = args['id'];
    //   final tag = args['tag'];
    //   Provider.of<MoviesProvider>(context, listen: false).getMovieDetails(id);
    // });
  }

  @override
  void didChangeDependencies() {
    if (_isInitLoaded) {
      final args =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;       
          final id = args['id'];
      Provider.of<MoviesProvider>(context, listen: false)
          .getMovieDetails(id)
          .then((value) {
        setState(() {
          _isFetching = false;
        });
      });
    }
    _isInitLoaded = false;
    // _isFetching = false;
    super.didChangeDependencies();
  }

  Widget _buildTopBar(String title) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        height: kToolbarHeight,
        decoration: BoxDecoration(
          color: Colors.black54,
          // backgroundBlendMode: BlendMode.dstIn,
        ),
        child: Row(
          children: [
            BackButton(color: Colors.white),
            Expanded(
              child: Align(
                alignment: Alignment.center - Alignment(0.2, 0),
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
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

  Widget _buildBottomIcons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.favorite_border,
            color: Colors.white,
            size: 30,
          ),
          Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
          Icon(
            Icons.share,
            color: Colors.white,
            size: 30,
          ),
        ],
      ),
    );
  }

  Widget _showLoadingIndicator() {
    return SpinKitThreeBounce (      
      size: 12,
      color: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final id = args['id'];
    final tag = args['tag'];
    // final film = _getFilm(id, tag);
    final film =
        Provider.of<MoviesProvider>(context, listen: false).movieDetails;
    

    print('isFetching =-----------> $_isFetching');

    return SafeArea(
      child: Scaffold(
        body: _isFetching
            ? Center(child: _showLoadingIndicator())
            : LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    ListView(
                      children: [
                        Container(
                          height: constraints.maxHeight * 0.9,
                          child: InitialView(film: film),
                        ),
                        Container(
                          color: Colors.black,
                          height: constraints.maxHeight * 0.1,
                          child: _buildBottomIcons(),
                        ),
                      ],
                    ),
                    _buildTopBar(film.title),
                  ],
                );
              },                          
            ),
      ),
    );
  }
}

class InitialView extends StatelessWidget {
  final MovieItem film;

  InitialView({this.film});
  @override
  Widget build(BuildContext context) {
    String _getDateAndDuration() {
      String res = '';
      if (film.releaseDate != null) {
        res = res + film.releaseDate.year.toString() + ' | ';
      } else {
        res = res + 'Unk' + ' | ';
      }

      if (film.duration != null) {
        res += film.duration.toString() + ' min';
      } else {
        res += 'Unk';
      }

      return res;
    }

    Widget _buildFooter() {
      return LayoutBuilder(
        builder: (context, constraints) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: constraints.maxHeight * 0.15,
                    color: Colors.black54,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: (constraints.maxWidth * 0.3 + 20),
                          top: 5,
                        ),
                        child: Container(
                          width: constraints.maxWidth * 0.6,
                          child: Text(
                            film.title,
                            softWrap: true,
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // ),
                Positioned(
                  bottom: constraints.maxHeight * 0.02,
                  left: 10,
                  child: Column(
                    children: [
                      Card(
                        elevation: 5,
                        child: Container(
                          width: constraints.maxWidth * 0.3,
                          height: constraints.maxHeight * 0.2,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: constraints.maxWidth * 0.3,
                        child: Center(
                          child: Text(_getDateAndDuration(),
                              style: Theme.of(context).textTheme.headline4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    Widget _buildBackgroundImage(MovieItem film) {
      return Stack(
        children: [
          film.imageUrl == null
              ? Image.asset('assets/images/poster_placeholder.png',
                  fit: BoxFit.cover)
              : Hero(
                  transitionOnUserGestures: true,
                  tag: film.imageUrl,
                  // child: FadeInImage.memoryNetwork(
                  //   image: film.imageUrl,
                  //   placeholder: kTransparentImage,
                  //   fit: BoxFit.cover,
                  //   width: double.infinity,
                  //   fadeInCurve: Curves.elasticOut,
                  // ),
                  child: CachedNetworkImage(
                    imageUrl: film.imageUrl,
                    fadeInCurve: Curves.elasticOut,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        color: const Color(0xff000000),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.7), BlendMode.dstATop),
                          image: imageProvider,
                        ),
                      ),
                    ),
                  ),
                ),
          _buildFooter(),
        ],
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Container(
              height: constraints.maxHeight,
              child: _buildBackgroundImage(film),
            ),
          ],
        );
      },
    );
  }
}
