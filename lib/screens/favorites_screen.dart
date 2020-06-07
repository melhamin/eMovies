import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  FavoritesPage({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Icon(Icons.search, color: Colors.white,),),
    );
  }
}
