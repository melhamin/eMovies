import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_movies/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:e_movies/providers/movies_provider.dart' as prov;

class VideoItem extends StatelessWidget {
  final prov.VideoItem videoDetails;
  final Function onTap;
  VideoItem({this.videoDetails, this.onTap});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: BASELINE_COLOR,
      child: ListTile(        
        leading: CachedNetworkImage(
          imageUrl: 'https://img.youtube.com/vi/${videoDetails.key}/0.jpg',
          fit: BoxFit.cover,
        ),
        title: Text(
          videoDetails.name,
          style: Theme.of(context).textTheme.headline3,
        ),
        subtitle: Text(
          videoDetails.type,
          style: Theme.of(context).textTheme.subtitle2,
        ),        
        onTap: () => onTap(videoDetails.key),
      ),
    );
    // return GridTile(
    //         footer: Text(
    //       'Title goes here',
    //       style: Theme.of(context).textTheme.headline4,
    //   ),
    //         child: Stack(
    //       children: [
    //         CachedNetworkImage(
    //           imageUrl: 'https://img.youtube.com/vi/${videoDetails.key}/0.jpg',
    //           fit: BoxFit.fill,
    //         ),
    //         Align(
    //           alignment: Alignment.center,
    //           child: GestureDetector(
    //             child: Icon(
    //               Icons.play_circle_outline,
    //               size: 50,
    //               color: Theme.of(context).accentColor,
    //             ),
    //             onTap: () => onTap(videoDetails.key),
    //           ),
    //         ),
    //       ],
    //     ),
    //       );
  }
}
