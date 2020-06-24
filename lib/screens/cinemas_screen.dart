import 'dart:async';

import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/providers/search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CinemasScreen extends StatefulWidget {
  @override
  _CinemasScreenState createState() => _CinemasScreenState();
}

class _CinemasScreenState extends State<CinemasScreen> {

  bool clicked = false;

  void onTap() {
    setState(() {
      clicked = !clicked;
    });
  }

  String movieGenres(List<int> movieGen) {
    String res = '';    
    movieGen.forEach((element) { 
      res = res + element.toString() + ' ';
    });
    res += '\n';
    movieGen.forEach((element) { 
      if(MOVIE_GENRES.containsKey(element)) res += MOVIE_GENRES[element];
    });

    return res;
  }

  String tvGenres(List<int> tvGen) {
    String res = '';    
    tvGen.forEach((element) { 
      res = res + element.toString() + ' ';
    });
    res += '\n';
    tvGen.forEach((element) { 
      if(TV_GENRES.containsKey(element)) res += TV_GENRES[element];
    });

    return res;
  }

  @override
  Widget build(BuildContext context) {        

    final topMovie = Provider.of<Search>(context).topMovieGenres;
    final topTV = Provider.of<Search>(context).topTVGenres;

    return Scaffold(
      body: Center(
        child: Column(  
          mainAxisAlignment: MainAxisAlignment.center,      
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text('Coming soon...', style: kTitleStyle),
            ),
            SizedBox(height: 10),
            IconButton(
              icon: Icon(Icons.search),
              color: Colors.pink,
              iconSize: 40,
              onPressed: onTap              ,
            ),
            SizedBox(height: 10),
            IconButton(
              icon: Icon(Icons.delete),
              color: Colors.red,
              iconSize: 40,
              onPressed: () {
                Provider.of<Search>(context, listen: false).clearPrefs();
              },
            ),
            SizedBox(height: 20),
            AnimatedContainer(
              padding: EdgeInsets.symmetric(horizontal: 15),
              duration: Duration(milliseconds: 300),
              height: clicked ? 200 : 0,
              color: ONE_LEVEL_ELEVATION,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: RichText(
                      text: TextSpan(
                        text: 'Top Movie Genres: \n\n',
                        children: [
                          TextSpan(text: movieGenres(topMovie)),
                        ],
                      ),
                    ),
                  ),                  
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: RichText(
                      text: TextSpan(
                        text: 'Top TV Genres: \n\n',
                        children: [
                          TextSpan(text: tvGenres(topTV)),
                        ],
                      ),
                    ),
                  ),                                 
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }  
}
