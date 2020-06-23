import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/widgets/tv/tv_genre_tile.dart';
import 'package:flutter/material.dart';

class GenresScreen extends StatefulWidget {
  GenresScreen({
    Key key,
  }) : super(key: PageStorageKey('GenresPage'));

  @override
  _GenresScreenState createState() => _GenresScreenState();
}

class _GenresScreenState extends State<GenresScreen>
    with AutomaticKeepAliveClientMixin {

      ScrollController _scrollController;

      @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
   _scrollController.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);    
    return Scaffold(
      body: GridView.builder(  
        controller: _scrollController,      
        padding: const EdgeInsets.only(bottom: APP_BAR_HEIGHT - 2),
        key: PageStorageKey('GenresPageGrid'),        
        addAutomaticKeepAlives: true,
        itemCount: MOVIE_GENRE_DETAILS.length,
        itemBuilder: (context, i) {
          return TVGenreTile(
            imageUrl: TV_GENRE_DETAILS[i]['imageUrl'],
            genreId: TV_GENRE_DETAILS[i]['genreId'],
            title: TV_GENRE_DETAILS[i]['title'],
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
