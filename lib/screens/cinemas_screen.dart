import 'package:e_movies/providers/lists.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CinemasScreen extends StatefulWidget {
  @override
  _CinemasScreenState createState() => _CinemasScreenState();
}

class _CinemasScreenState extends State<CinemasScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: IconButton(
        icon: Icon(Icons.search),
        iconSize: 40,
        color: Colors.red,
        onPressed: () {
          Provider.of<Lists>(context, listen: false).deleteAllPrefs();
        },

      ),),
    );
  }
}