import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_movies/my_stateful_builder.dart';
import 'package:e_movies/providers/movies.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InTheatersGrid extends StatefulWidget {
  @override
  _InTheatersGridState createState() => _InTheatersGridState();
}

class _InTheatersGridState extends State<InTheatersGrid>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  PageController _pageController;

  int curr = 0;
  double imageScale = 1;

  @override
  void initState() {
    super.initState();
    // _animationController = AnimationController(
    //   vsync: this,
    //   duration: Duration(seconds: 3),
    //   lowerBound: 1,
    //   upperBound: 1.1,
    // )..addListener(() {
    //     setState(() {
    //       imageScale = _animationController.value;
    //     });


    //   })..forward()
    //   ..addStatusListener((status) { 
    //     if(status == AnimationStatus.completed) {   
    //       _changeImage();
    //       _animationController.reset();
    //       _animationController.forward();       
    //     }
    //   })
    //   ;


    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // void _changeImage() {
  //   setState(() {
  //     curr = curr + 1;
  //   });      
  // }

  void _onPageViewChanged(int index) {
    setState(() {
      curr = index;
    });
    if (index == 10) {
      _pageController.jumpTo(0);
      // _pageController.
    }
  }

  Widget _buildItem(String imageUrl, int currentIndex) {}

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final inTheaters = Provider.of<Movies>(context).trending;
    return Container(
      height: height * 0.3,
      child: Stack(
        children: [
          // if(inTheaters.isEmpty)

          if (inTheaters.isNotEmpty)
            Container(
              height: height * 0.3,
              width: double.infinity,
              child: PageView.builder(
                onPageChanged: _onPageViewChanged,
                physics: const BouncingScrollPhysics(),
                // itemCount: 10,
                controller: _pageController,
                itemBuilder: (ctx, i) {
                  int currIndex = i;
                  if (currIndex > 9) {
                    if (currIndex % 10 == 0)
                      currIndex = 0;
                    else if ((currIndex + 1) % 10 == 0)
                      currIndex = 9;
                    else if ((currIndex - 1) % 10 == 0) currIndex = 1;
                  }
                  return Stack(
                    children: [
                      Positioned.fill(
                        child: CachedNetworkImage(
                            imageUrl: inTheaters[currIndex].posterUrl,
                            fit: BoxFit.fill,
                          ),
                      ),
                      Container(
                        width: double.infinity,
                        color: Colors.black45,
                      ),
                    ],
                  );
                },
              ),
            ),
          Positioned.fill(
            // bottom: 10,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.all(20),
                height: 10,
                width: 190,
                // color: Colors.blue,
                child: Align(
                  alignment: Alignment.center,
                  child: ListView.separated(
                    separatorBuilder: (ctx, i) {
                      return SizedBox(width: 10);
                    },
                    itemCount: 10,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (ctx, i) {
                      return Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: i == curr
                              ? Colors.white.withOpacity(0.87)
                              : Colors.white.withOpacity(0.45),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
