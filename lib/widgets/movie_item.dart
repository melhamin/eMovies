import 'package:flutter/material.dart';

import 'package:e_movies/genres.dart';

class MovieItem extends StatelessWidget {
  final String title;
  final dynamic genreIds;
  final String imageUrl;
  // final DateTime releaseDate;

  MovieItem({
    this.title,
    this.genreIds,
    this.imageUrl,
    // this.releaseDate,
  });

  Widget _buildMovieItem() {
    return Container(
        child: Positioned.fill(
      child: Text(title),
      top: 10,
      left: 10,
    ));
  }

  String getGenreName() { 
    return GENRES[genreIds[0]];   
    // String res = '';   
    // genreIds.forEach((id) {
    //   res += '${GENRES[id]}, ';
    // });
    // res = res.substring(0, res.length - 2);
    // print(res);
    // return res;
  }

  @override
  Widget build(BuildContext context) {
    print('MovieItem ---> build called...');
    final screenWidth = MediaQuery.of(context).size.width;
    return ClipRRect(
      child: GridTile(
        child: GestureDetector(
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xff000000),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.7), BlendMode.dstATop),
                    image: NetworkImage(imageUrl),
                  ),
                ),
              ),
              Positioned.directional(
                textDirection: TextDirection.ltr,
                bottom: 20,
                start: 20,
                child: Container(
                  constraints: BoxConstraints(maxWidth: screenWidth / 2 - 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: Theme.of(context).textTheme.headline6,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis),
                      Text(                        
                        getGenreName(),
                        style: TextStyle(fontSize: 16, color: Colors.white70), 
                        softWrap: false,  
                        overflow: TextOverflow.ellipsis,                     
                      )
                    ],
                  ),
                ),
              ),
              // Positioned.directional(
              //   textDirection: TextDirection.ltr,
              //   bottom: 40,
              //   start: 10,
              // Column(
              //   children: <Widget>[
              //     Align(
              //       alignment: Alignment.bottomLeft,
              //       child: Text(
              //         title,
              //         style: Theme.of(context).textTheme.headline6,
              //         overflow: TextOverflow.fade,
              //       ),
              //     ),
              //     Text('Action'),
              //   ],
              // ),
              // Container(
              //   padding: EdgeInsets.only(right: 20),
              // ),
              // ),
            ],
          ),
          onTap: () {},
        ),
      ),
    );
  }
}
