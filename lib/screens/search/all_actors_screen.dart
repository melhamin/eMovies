import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/providers/cast.dart';
import 'package:e_movies/providers/movies.dart' as prov;
import 'package:e_movies/providers/search.dart';
import 'package:e_movies/screens/movie/cast_details_screen.dart';
import 'package:e_movies/widgets/placeholder_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllActorsScreen extends StatelessWidget {
  Route _buildRoute(dynamic item) {
    return PageRouteBuilder(
      settings: RouteSettings(
        arguments: item,
      ),
      pageBuilder: (context, animation, secondaryAnimation) => CastDetails(),
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

  @override
  Widget build(BuildContext context) {
    final cast = Provider.of<prov.Movies>(context).cast;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Cast Details', style: kTitleStyle),
          centerTitle: true,
          leading: BackButton(color: Colors.white.withOpacity(0.87)),
        ),
        body: ListView.builder(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),          
          itemCount: cast.length,
          itemBuilder: (_, i) {
            return InkWell(
              onTap: () {
                Navigator.of(context).push(_buildRoute(cast[i]));
              },
              highlightColor: Colors.black,
              splashColor: Colors.transparent,
              child: ListTile(
                leading: Container(
                  height: 80,
                  width: 50,
                  child: cast[i].imageUrl == null
                      ? PlaceHolderImage(cast[i].name)
                      : CachedNetworkImage(
                          imageUrl: IMAGE_URL + cast[i].imageUrl,
                          fit: BoxFit.cover,
                        ),
                ),
                title: Text(cast[i].name, style: kListsItemTitleStyle),
                subtitle: RichText(
                  text: TextSpan(text: 'as ', style: kSubtitle1, children: [
                    TextSpan(
                        text: cast[i].character,
                        style: TextStyle(
                          fontFamily: 'Helvatica',
                          color: Theme.of(context).accentColor,
                          fontSize: 16,
                        )),
                  ]),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
