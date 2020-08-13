import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/models/cast_model.dart';
import 'package:e_movies/screens/movie/cast/cast_details_screen.dart';
import 'package:e_movies/widgets/back_button.dart';
import 'package:e_movies/widgets/placeholder_image.dart';
import 'package:flutter/material.dart';

class CastDetailsScreen extends StatelessWidget {
  final List<CastModel> cast;
  CastDetailsScreen(this.cast);

  void _navToDetails(BuildContext context, dynamic item) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => CastDetails(),
      settings: RouteSettings(arguments: item),
    ));    
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            ListView.builder(
              key: PageStorageKey('AllActorsScreen'),
              padding: const EdgeInsets.only(top: 60),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: cast.length,
              itemBuilder: (_, i) {
                return InkWell(
                  onTap: () => _navToDetails(context, cast[i]),
            
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
                              
                              color: Theme.of(context).accentColor,
                              fontSize: 16,
                            )),
                      ]),
                    ),
                  ),
                );
              },
            ),
            Positioned(
              left: 0,
              top: 10,
              child: CustomBackButton(
                text: 'Cast',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
