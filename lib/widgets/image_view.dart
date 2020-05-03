import 'package:e_movies/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageView extends StatefulWidget {
  static const routeName = '/image-view';
  final List<dynamic> images;
  ImageView(this.images);
  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.images);

    return Scaffold(
        appBar: AppBar(
          leading: BackButton(),
          centerTitle: true,
          title: Text('Gallery', style: kTitleStyle),
        ),
        body: Center(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: PhotoViewGallery.builder(
              loadingBuilder: (context, event) {
                return SpinKitCircle(
                  color: Theme.of(context).accentColor,
                  size: 21,
                );
              },
              itemCount: widget.images.length,
              builder: (context, index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(widget.images[index]),
                  // initialScale: PhotoViewComputedScale.contained * 0.8,
                  heroAttributes:
                      PhotoViewHeroAttributes(tag: widget.images[index]),
                );
              },
            ),
          ),
        ));
  }
}
