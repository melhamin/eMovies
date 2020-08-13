import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/screens/main_screen.dart';
import 'package:e_movies/providers/search.dart';
import 'package:e_movies/screens/movie/movie_details/movie_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:e_movies/screens/movie/cast/cast_details_screen.dart'
    show CastDetails;

import 'package:e_movies/screens/movie/top_rated_screen.dart';
import 'package:e_movies/screens/video_page.dart';
import 'package:e_movies/providers/cast.dart';
import 'package:e_movies/providers/tv.dart';
import 'package:e_movies/providers/movies.dart';
import 'package:e_movies/providers/lists.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

import 'screens/movie/trending_movies_screen.dart';

void main() async {
  await DotEnv().load('.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {    
    FlutterStatusbarcolor.setStatusBarColor(Hexcolor('#121212'));
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Movies()),
        ChangeNotifierProvider.value(value: Cast()),
        ChangeNotifierProvider.value(value: TV()),
        ChangeNotifierProvider.value(value: Lists()),
        ChangeNotifierProvider.value(value: Search()),
      ],
      child: MaterialApp(
        title: 'eMovies',
        theme: ThemeData(
          // primaryColor: Color(0xff1C306D),
          // primaryColor: Hexcolor('#2c3e50'),
          primaryColor: Colors.black,
          applyElevationOverlayColor: true,          
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          
          // primarySwatch:,
          // accentColor: Colors.amber,
          // splashColor: Colors.transparent,
          // highlightColor: Colors.transparent,
          accentColor: Colors.pink,
          // accentColor: Color(0xFFFFAD32),
          // accentColor: Hexcolor('#1DB954'),
          scaffoldBackgroundColor: BASELINE_COLOR,
          appBarTheme: AppBarTheme(
            elevation: 0,
            color: ONE_LEVEL_ELEVATION,
          ),
          errorColor: Hexcolor('#B00020'),
          // Hexcolor('#101010'),
        ),
        home: MainScreen(),
        debugShowCheckedModeBanner: false,
        routes: {
          MainScreen.routeName: (ctx) => MainScreen(),
          MovieDetailsScreen.routeName: (ctx) => MovieDetailsScreen(),
          TrendingMoviesScreen.routeName: (ctx) => TrendingMoviesScreen(),
          TopRated.routeName: (ctx) => TopRated(),
          VideoPage.routeName: (ctx) => VideoPage(),
          // WebViewExample.routeName: (ctx) => WebViewExample(),
          // ImageView.routeName: (ctx) => ImageView(),
          CastDetails.routeName: (ctx) => CastDetails(),
        },
      ),
    );
  }
}
