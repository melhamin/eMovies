import 'package:e_movies/pages/cast_details.dart';
import 'package:e_movies/pages/details_page.dart';
import 'package:e_movies/pages/in_theaters_page.dart';
import 'package:e_movies/pages/top_rated_page.dart';
import 'package:e_movies/pages/video_page.dart';
import 'package:e_movies/providers/cast_provider.dart';
import 'package:e_movies/widgets/image_view.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import 'package:e_movies/pages/main_page.dart';
import 'package:e_movies/pages/details_page.dart';

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
        ChangeNotifierProvider.value(value: CastProvider()),
      ],
      child: MaterialApp(
        title: 'eMovies',
        theme: ThemeData(
          // primaryColor: Color(0xff1C306D),
          primaryColor: Colors.black,
          // accentColor: Colors.amber,
          // splashColor: Colors.transparent,
          // highlightColor: Colors.transparent,
          accentColor: Colors.pink,
          // accentColor: Color(0xFFFFAD32),
          scaffoldBackgroundColor: Colors.transparent,
          textTheme: TextTheme(
            subtitle1: TextStyle(
              fontSize: 14,
              fontFamily: 'Helvatica',
              // fontWeight: FontWeight.w500,
              color: Colors.white54,
            ),
            subtitle2: TextStyle(
              fontSize: 12,
              fontFamily: 'Roboto',
              color: Colors.white60,
            ),
            
            headline3: TextStyle(
              fontSize: 14,
              fontFamily: 'Helvatica',                       
              height: 1.5,
              fontWeight: FontWeight.w600,

              color: Hexcolor('#DEDEDE'),
            ),
            headline4: TextStyle(
              fontSize: 28,
              fontFamily: 'Helvatica',              
              fontWeight: FontWeight.bold,
              color: Hexcolor('#DEDEDE'),
            ),
            headline6: TextStyle(
              fontSize: 21,
              // height: 1.5,
              fontFamily: 'Helvatica',              
              fontWeight: FontWeight.bold,
              color: Hexcolor('#DEDEDE')
            ),            
            headline5: TextStyle(
              fontSize: 16,
              fontFamily: 'Helvatica',              
              fontWeight: FontWeight.bold,
              color: Hexcolor('#DEDEDE'),
            ),            
          ),          
        ),
        home: MainPage(),
        debugShowCheckedModeBanner: false,
        routes: {
          MainPage.routeName: (ctx) => MainPage(),
          DetailsPage.routeName: (ctx) => DetailsPage(),
          InTheaters.routeName: (ctx) => InTheaters(),
          TopRated.routeName: (ctx) => TopRated(),
          VideoPage.routeName: (ctx) => VideoPage(),
          ImageView.routeName: (ctx) => ImageView(),
          CastDetails.routeName: (ctx) => CastDetails(),
        },
      ),
    );
  }
}
