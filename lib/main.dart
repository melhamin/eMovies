import 'package:e_movies/pages/movie_details_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:e_movies/pages/main_page.dart';

import 'providers/movies.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Movies()),
      ],
      child: MaterialApp(
        title: 'eMovies',
        theme: ThemeData(
          primaryColor: Color(0xff1C306D),
          accentColor: Color(0xFFFFAD32),
          scaffoldBackgroundColor: Colors.transparent,
          textTheme: TextTheme(
            subtitle1: TextStyle(
              fontSize: 12,
              fontFamily: 'Roboto',
              color: Colors.white70,
            ),
            headline6: TextStyle(
              fontSize: 16,
              fontFamily: 'Roboto',
              // fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        home: MainPage(),
        debugShowCheckedModeBanner: false,
        routes: {
          MovieDetailPage.routeName: (ctx) => MovieDetailPage(),
        },
      ),
    );
  }
}
