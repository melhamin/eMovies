import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_movies/models/init_data.dart';
import 'package:flutter/material.dart';

class MyStatefulBuilder extends StatefulWidget {
  final StatefulWidgetBuilder builder;
  // final ValueChanged<String> changeImage;
  final List<InitData> items;
  String imageUrl;
  MyStatefulBuilder({this.builder, this.imageUrl, this.items});

  @override
  _MyStatefulBuilderState createState() => _MyStatefulBuilderState();
}

class _MyStatefulBuilderState extends State<MyStatefulBuilder>
    with SingleTickerProviderStateMixin {
  String imageUrl;
  AnimationController _animationController;
  double imageScale = 1;
  int imageIndex = 0;

  @override
  void initState() {
    super.initState();    
    imageUrl = widget.items[imageIndex].posterUrl;
    // wait for page navigation the start animation
    Future.delayed(Duration(milliseconds: 200)).then((value) {
      _animationController = AnimationController(
        vsync: this,
        lowerBound: 1,
        upperBound: 1.1,
        duration: Duration(seconds: 4),
      )
        ..addListener(() {
          setState(() {
            imageScale = _animationController.value;
          });
        })
        ..forward()
        ..addStatusListener((status) {
          // print('status -------------> $status');
          if (status == AnimationStatus.completed) {
            _changeImage();
            _animationController.reset();
            _animationController.forward();
          }
        });
    });
  }

  @override
  void dispose() {
    _animationController.removeListener(() { });
    _animationController.dispose();
    super.dispose();
  }

  /// Changes imageUrl to the url of lists' next item
  void _changeImage() {
    if (imageIndex < widget.items.length - 1) {
      setState(() {
        imageIndex += 1;
        imageUrl = widget.items[imageIndex].posterUrl;
      });
    } else {
      setState(() {
        imageIndex = 0;
        imageUrl = widget.items[imageIndex].posterUrl;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // print('build ------------------> $imageUrl');
    return Transform.scale(
      scale: imageScale,
      child: Container(
        width: double.infinity,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
