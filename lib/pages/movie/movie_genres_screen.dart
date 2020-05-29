import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/widgets/movie/movie_genre_tile.dart';
import 'package:flutter/material.dart';

class MovieGenresScreen extends StatefulWidget {
  MovieGenresScreen({
    Key key,
  }) : super(key: PageStorageKey('GenresPage'));

  @override
  _MovieGenresScreenState createState() => _MovieGenresScreenState();
}

class _MovieGenresScreenState extends State<MovieGenresScreen>
    with AutomaticKeepAliveClientMixin {

      ScrollController _scrollController;

      @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    // dynamic child;
    super.build(context);    
    return Scaffold(
      body: GridView.builder(  
        controller: _scrollController,      
        padding: const EdgeInsets.only(bottom: APP_BAR_HEIGHT - 2),
        key: PageStorageKey('GenresPageGrid'),
        physics: BouncingScrollPhysics(),
        addAutomaticKeepAlives: true,
        itemCount: MOVIE_GENRE_DETAILS.length,
        itemBuilder: (context, i) {        
          return MovieGenreTile(
            imageUrl: MOVIE_GENRE_DETAILS[i]['imageUrl'],
            genreId: MOVIE_GENRE_DETAILS[i]['genreId'],
            title: MOVIE_GENRE_DETAILS[i]['title'],
          );
        },        
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 3,
          mainAxisSpacing: 10,
        ),
        scrollDirection: Axis.vertical,
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
