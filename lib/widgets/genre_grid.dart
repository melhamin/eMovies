import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/widgets/genre_tile.dart';
import 'package:flutter/material.dart';

class GenreGrid extends StatelessWidget {
  // final dynamic child;
  @required final dynamic itemsList;
  @required final int mediaType;
  GenreGrid({this.itemsList, this.mediaType});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(  
        // controller: _scrollController,              
        padding: const EdgeInsets.symmetric(horizontal: LEFT_PADDING),
        key: PageStorageKey('GenresPageGrid'),
        physics: BouncingScrollPhysics(),
        addAutomaticKeepAlives: true,
        itemCount: itemsList.length,
        itemBuilder: (context, i) {
          return GenreTile(
            imageUrl: itemsList[i]['imageUrl'],
            genreId: itemsList[i]['genreId'],
            title: itemsList[i]['title'],
            mediaType: mediaType,
          );
        },        
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 1/1.5,
          // mainAxisSpacing: 10,
        ),
        scrollDirection: Axis.horizontal,
      );
  }
}
