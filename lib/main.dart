import 'package:e_movies/pages/main_Page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:e_movies/pages/movie/cast_details_screen.dart' show CastDetails;
import 'package:e_movies/pages/movie/movie_details_screen.dart' show DetailsScreen;
import 'package:e_movies/pages/movie/in_theaters_screen.dart';
import 'package:e_movies/pages/movie/top_rated_screen.dart';
import 'package:e_movies/pages/video_page.dart';
import 'package:e_movies/providers/cast.dart';
import 'package:e_movies/providers/tv.dart';
import 'package:e_movies/providers/movies.dart';


void main() async {
  await DotEnv().load('.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [        
        ChangeNotifierProvider.value(value: Movies()),        
        ChangeNotifierProvider.value(value: Cast()),        
        ChangeNotifierProvider.value(value: TV()),
      ],
      child: MaterialApp(
        title: 'eMovies',
        theme: ThemeData(          
          // primaryColor: Color(0xff1C306D),
          // primaryColor: Hexcolor('#2c3e50'),
          primaryColor: Colors.black,
          // accentColor: Colors.amber,
          // splashColor: Colors.transparent,
          // highlightColor: Colors.transparent,
          // accentColor: Colors.pink,
          accentColor: Color(0xFFFFAD32),
          scaffoldBackgroundColor: Colors.black,                        
        ),
        home: MainScreen(),
        debugShowCheckedModeBanner: false,
        routes: {
          MainScreen.routeName: (ctx) => MainScreen(),
          DetailsScreen.routeName: (ctx) => DetailsScreen(),
          InTheaters.routeName: (ctx) => InTheaters(),
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
