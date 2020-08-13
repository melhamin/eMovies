import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/widgets/back_button.dart';
import 'package:e_movies/widgets/loading_indicator.dart';
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

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: PhotoViewGallery.builder(
                  loadingBuilder: (context, event) {
                    return LoadingIndicator();
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
            ),
            Positioned(
              left: 0,
              top: 10,
              child: CustomBackButton(
                text: 'Gallery',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
