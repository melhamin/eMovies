import 'package:e_movies/pages/movie_details_page.dart';
import 'package:e_movies/pages/trending_movies_page.dart';
import 'package:e_movies/pages/upcoming_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:e_movies/pages/main_page.dart';

import 'providers/movies_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: MoviesProvider()),
      ],
      child: MaterialApp(
        title: 'eMovies',
        theme: ThemeData(
          // primaryColor: Color(0xff1C306D),
          primaryColor: Colors.black,
          accentColor: Colors.redAccent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          // accentColor: Color(0xff1C306D),
          // accentColor: Color(0xFFFFAD32),
          scaffoldBackgroundColor: Colors.transparent,
          textTheme: TextTheme(
            subtitle1: TextStyle(
              fontSize: 14,
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            subtitle2: TextStyle(
              fontSize: 12,
              fontFamily: 'OpenSans',
              color: Colors.white70,
            ),
            headline6: TextStyle(
              fontSize: 16,
              fontFamily: 'OpenSans',              
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),          
        ),
        home: MainPage(),
        debugShowCheckedModeBanner: false,
        routes: {
          MainPage.routeName: (ctx) => MainPage(),
          MovieDetailPage.routeName: (ctx) => MovieDetailPage(),
          TrendingMoviesPage.routeName: (ctx) => TrendingMoviesPage(),
          UpcomingMoviesPage.routeName: (ctx) => UpcomingMoviesPage(),
        },
      ),
    );
  }
}
