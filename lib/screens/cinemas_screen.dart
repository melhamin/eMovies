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

class _CinemasScreenState extends State<CinemasScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Coming soon...', style: kTitleStyle),
            // IconButton(
            //   icon: Icon(Icons.search),
            //   color: Colors.red,
            //   iconSize: 60,
            //   onPressed: () {
            //     Provider.of<Search>(context, listen: false).clearPrefs();
            //   },
            // )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
