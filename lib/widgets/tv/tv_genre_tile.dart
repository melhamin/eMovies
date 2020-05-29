import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/pages/tv/tv_genre_item_screen.dart';
import 'package:flutter/material.dart';

class TVGenreTile extends StatelessWidget {
  final String title;
  final String imageUrl;
  final int genreId;

  TVGenreTile({this.title, this.imageUrl, this.genreId});

  Route _buildRoute() {
    return PageRouteBuilder(
      // settings: RouteSettings(arguments: genreId),
      pageBuilder: (context, animation, secondaryAnimation) => TVGenreItemScreen(genreId),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(
            1, 0); // if x > 0 and y = 0 transition is from right to left
        var end =
            Offset.zero; // if y > 0 and x = 0 transition is from bottom to top
        var tween = Tween(begin: begin, end: end);
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  void _onTap(BuildContext context) {
    Navigator.of(context).push(_buildRoute());
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          child: Stack(
            children: [
              Card(
                color: Colors.black,
                shadowColor: Colors.white30,
                elevation: 5,
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: FadeInImage(
                    image: AssetImage(imageUrl),
                    placeholder: AssetImage('assets/images/placeholder.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: constraints.maxHeight * 0.4,
                  width: constraints.maxWidth,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Color.fromRGBO(0, 0, 0, 0.9),
                          Color.fromRGBO(0, 0, 0, 0.05),
                        ]),
                  ),
                ),
              ),
              Positioned(
                bottom: 15,
                left: 15,
                child: Text(
                  title,
                  style: kTitleStyle,
                ),
              ),
            ],
          ),
          onTap: () => _onTap(context),
        );
      },
    );
  }

  // @override
  // // TODO: implement wantKeepAlive
  // bool get wantKeepAlive => true;
}
