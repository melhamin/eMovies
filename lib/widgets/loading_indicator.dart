import 'package:flutter/material.dart';

class ImageLoadingIndicator extends StatefulWidget {
  final bool circular;
  final double height;
  final double width;
  final Color color;

  ImageLoadingIndicator({
    this.circular = false,
    this.color = Colors.grey,
    @required this.height,
    @required this.width,
  });

  @override
  _LoadingIndicatorState createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<ImageLoadingIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutSine,
      ),
    );

    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _animationController.repeat();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });
    _animationController.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }

  Decoration boxDecoration(Animation<double> animation) {
    return BoxDecoration(
      shape: BoxShape.rectangle,
      gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.grey[700],
            Colors.grey[600],
            Colors.grey[700],
          ],
          stops: [
            _animation.value * 0.1,
            _animation.value,
            _animation.value + 2,
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          height: widget.height,
          width: widget.width,
          decoration: boxDecoration(_animation),
        );
      },
    );
  }
}

class LineLoadingIndicator extends StatefulWidget {
  final double width;
  final Color color;
  final bool singleLine;

  LineLoadingIndicator({
    this.color = Colors.grey,
    @required this.width,
    this.singleLine = false,
  });

  @override
  _LineLoadingIndicatorState createState() => _LineLoadingIndicatorState();
}

class _LineLoadingIndicatorState extends State<LineLoadingIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutSine,
      ),
    );

    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _animationController.repeat();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });
    _animationController.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }

  Decoration boxDecoration(Animation animation) {
    return BoxDecoration(
      shape: BoxShape.rectangle,
      gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.grey[700],
          Colors.grey[600],
          Colors.grey[700],
        ],
        stops: [
          _animation.value * 0.1,
          _animation.value,
          _animation.value + 2,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return 
              widget.singleLine ? Container(
                  width: widget.width,
                  height: 10,
                  decoration: boxDecoration(_animation),
                )
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[                    
                    Container(
                      width: widget.width * 0.9,
                      height: 10,
                      decoration: boxDecoration(_animation),
                    ),
                    SizedBox(height: 5,),
                    Container(
                      width: widget.width * 0.7,
                      height: 10,
                      decoration: boxDecoration(_animation),
                    ),
                    SizedBox(height: 5,),
                    Container(
                      width: widget.width * 0.2,
                      height: 10,
                      decoration: boxDecoration(_animation),
                    ),
                    SizedBox(height: 5,),
                  ],
                );
        },
      ),
    );
  }
}

// class LineLoadingIndicator extends StatefulWidget {
//   final double height;
//   final double width;
//   final Color color;

//   LineLoadingIndicator({
//     this.color = Colors.grey,
//     @required this.height,
//     @required this.width,
//   });

//   @override
//   _LoadingIndicatorState createState() => _LoadingIndicatorState();
// }

// class _LineLoadingIndicator extends State<_LineLoadingIndicator>
//     with SingleTickerProviderStateMixin {
//   AnimationController _animationController;
//   Animation<double> _animation;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 3),
//     );

//     _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: Curves.easeInOutSine,
//       ),
//     );

//     _animation.addStatusListener((status) {
//       if (status == AnimationStatus.completed ||
//           status == AnimationStatus.dismissed) {
//         _animationController.repeat();
//       } else if (status == AnimationStatus.dismissed) {
//         _animationController.forward();
//       }
//     });
//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     _animationController.dispose();
//   }

//   Decoration boxDecoration(Animation<double> animation) {
//     return BoxDecoration(
//       shape: BoxShape.rectangle,
//       gradient: LinearGradient(
//           begin: Alignment.centerLeft,
//           end: Alignment.centerRight,
//           colors: [
//             Colors.grey[700],
//             Colors.grey[600],
//             Colors.grey[700],
//           ],
//           stops: [
//             _animation.value *0.1,
//             _animation.value,
//             _animation.value + 2,
//           ]),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _animation,
//       builder: (context, child) {
//         return Container(
//           height: widget.height,
//           width: widget.width,
//           decoration: boxDecoration(_animation),
//         );
//       },
//     );
//   }
// }
