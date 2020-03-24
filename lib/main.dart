import 'package:flutter/material.dart';

import 'package:e_movies/pages/main_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eMovies',
      theme: ThemeData(
        primaryColor: Color(0xFF1C306D),
        accentColor: Color(0xFFFFAD32),
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
