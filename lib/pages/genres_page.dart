import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/widgets/genre_tile.dart';
import 'package:flutter/material.dart';

class GenresPage extends StatefulWidget {
  GenresPage({
    Key key,
  }) : super(key: PageStorageKey('GenresPage'));

  @override
  _GenresPageState createState() => _GenresPageState();
}

class _GenresPageState extends State<GenresPage>
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
    super.build(context);    
    return Scaffold(
      body: GridView.builder(  
        controller: _scrollController,      
        padding: const EdgeInsets.only(top: 56),
        key: PageStorageKey('GenresPageGrid'),
        physics: BouncingScrollPhysics(),
        addAutomaticKeepAlives: true,
        itemCount: GENRE_DETAILS.length,
        itemBuilder: (context, i) {
          return GenreTile(
            imageUrl: GENRE_DETAILS[i]['imageUrl'],
            genreId: GENRE_DETAILS[i]['genreId'],
            title: GENRE_DETAILS[i]['title'],
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
