import 'package:flutter/material.dart';

class ImageView extends StatefulWidget {
  static const routeName = '/image-view';
  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView>
    with SingleTickerProviderStateMixin {
  String text =
      """asjdfkjsjfksdjfkjkjkjfkjjjjjjjjjjjjjjjjjjjjjafkdlfjaskdfjsklf 
  fsdjkffffffffffffffffffffffffffffffffffffffffffajfkjsdfjjjjjjjjjjjjjjjjjjjjjj
  sakdjfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff""";

  AnimationController _controller;

  /// Animation for controlling the height of the widget.
  Animation<double> _animation;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();

    /// Initializing the animation controller with the [duration] parameter.
    _controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..forward();

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      curve: Curves.bounceInOut,
      parent: _controller,
    ));
  }

  Widget _buildChildren(BuildContext context, Widget child) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textPainter = TextPainter(
          textDirection: TextDirection.ltr,
          text: TextSpan(
            text: text,
          ),
        )..layout(maxWidth: double.infinity);

        return AnimatedContainer(
            duration: Duration(seconds: 3),
            alignment: Alignment.topCenter,
            curve: Curves.easeInOutCubic,
            child: textPainter.didExceedMaxLines
                ? Column(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(),
                        child: child,
                      ),
                      Container(
                        height: 20,
                      )
                    ],
                  )
                : child);
      },
    );
  }

  void _onTap() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
          text: text,
        ))..layout();
    return Scaffold(
      body: Center(
        child: Container(
          height: 200,
          width: double.infinity,
          color: Colors.amber,
          child: AnimatedContainer(
              duration: Duration(seconds: 3),
              curve: Curves.easeInOut,
              child: textPainter.didExceedMaxLines
                  ? Column(
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(),
                          child: GestureDetector(
                            onTap: _onTap,
                            child: Text(
                              text,
                              maxLines: _isExpanded ? null : 1,
                            ),
                          ),
                        ),
                        Container(
                          height: 20,
                        )
                      ],
                    )
                  : GestureDetector(
                            onTap: _onTap,
                            child: Text(
                              text,
                              maxLines: _isExpanded ? null : 1,
                            ),
                          ),
        ),
      ),
    ));
  }
}
