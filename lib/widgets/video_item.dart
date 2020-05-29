import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_movies/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:e_movies/providers/movies.dart' as prov;

class VideoItem extends StatelessWidget {
  final prov.VideoItem videoDetails;
  final Function onTap;
  VideoItem({this.videoDetails, this.onTap});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ONE_LEVEL_ELEVATION,
      child: ListTile(        
        leading: CachedNetworkImage(
          // youtube thumbnails url
          imageUrl: 'https://img.youtube.com/vi/${videoDetails.key}/0.jpg',
          fit: BoxFit.cover,
        ),
        title: Text(
          videoDetails.name,
          style: kBodyStyle2,
        ),
        subtitle: Text(
          videoDetails.type,
          style: kSubtitle1,
        ),        
        onTap: () => onTap(videoDetails.key),
      ),
    );
  }
}
