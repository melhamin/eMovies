import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/providers/movies_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TVScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              color: Colors.pink,
              child: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  Provider.of<MoviesProvider>(context, listen: false).fetchVideos(181812);
                },
              ),
              // child: CustomPaint(painter: Painter()),
            );
          },
        ),
      ),
    );
  }
}

class Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 4.0
      ..color = BASELINE_COLOR;

    final arc = Path();
    arc.moveTo(0, size.height * 0.7);

    arc.arcToPoint(
      Offset(size.width, size.height * 0.9),
      radius: Radius.circular(size.width / 2),
      clockwise: false,
    );

    // arc.cubicTo(0, size.height, size.width, size.height, size.width * 0.5, size.height *0.5);

    // arc.addOval(Rect.fromCenter(
    //   center: Offset(size.width * 0.5, size.height * 0.5),
    //   height: 50,
    //   width: 20

    // ));

    // arc.lineTo(size.width * 0.25 , size.height * 0.5);
    // arc.moveTo(size.width * 0.25 , size.height * 0.5);
    // arc.arcToPoint(Offset(size.width * 0.5 , size.height * 0.5), radius: Radius.circular(20));
    // arc.lineTo(size.width * 0.5 , size.height * 0.7);
    // arc.moveTo(size.width * 0.5 , size.height * 0.7);
    // arc.lineTo(size.width * 0.75 , size.height * 0.5);
    // arc.moveTo(size.width * 0.75 , size.height * 0.5);
    // // arc.lineTo(size.width , size.height * 0.5);
    // arc.moveTo(size.width * 0.25 , size.height * 0.5);
    // arc.lineTo(size.width * 0.75, size.height * 0.5);
    // arc.lineTo(size.width, size.height * 0.5);

    // arc.arcToPoint(Offset(0, size.height * 0.9),
    //     radius: Radius.circular(100));

    // arc.arcToPoint(
    //   Offset(size.width, size.height * 0.9),
    //   radius: Radius.circular(200),
    //   // clockwise: false,
    // );

    canvas.drawPath(arc, paint);
  }

  @override
  bool shouldRepaint(Painter oldDelegate) => false;
}
