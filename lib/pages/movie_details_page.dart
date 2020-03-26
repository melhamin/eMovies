import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/movies.dart';

class MovieDetailPage extends StatelessWidget {
  static const routeName = '/movie-detail-page';
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments as int;
    final movie = Provider.of<Movies>(context).findById(id);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image.asset('assets/images/background_image.jpg'),
          NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                pinned: true,
                expandedHeight: 200,
                leading: BackButton(),
                centerTitle: true,
                stretch: true,                
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  collapseMode: CollapseMode.parallax,     
                  titlePadding: EdgeInsets.only(bottom: 0),    
                  stretchModes: [
                    StretchMode.zoomBackground
                  ],                           
                  title: Container(
                    height: 40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromRGBO(0, 0, 0, 0),
                            Color.fromRGBO(0, 0, 0, 0.9),
                          ]),
                    ),
                    child: Center(
                      child: Text(                                          
                        movie.title,
                        style: TextStyle(fontSize: 14),
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  background: Image.network(
                    movie.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                automaticallyImplyLeading: false,
              ),
            ],
            body: Column(
              children: [
                               
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.favorite_border,),        
        backgroundColor: Theme.of(context).accentColor,
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
