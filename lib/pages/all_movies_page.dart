import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/movies.dart' show Movies;
import '../widgets/movie_item.dart';

class AllMoviesPage extends StatefulWidget {
  AllMoviesPage({
    Key key,
  }) : super(key: key);

  @override
  _AllMoviesState createState() => _AllMoviesState();
}

class _AllMoviesState extends State<AllMoviesPage> {
  bool _initLoaded = false;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initLoaded = true;
  }
  
  @override
  void didChangeDependencies() {
    if (_initLoaded) {
      Provider.of<Movies>(context).fetch();
    }
    _initLoaded = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);   
    print('AllMoviesPage ---> build called...'); 
    final movies = Provider.of<Movies>(context).movies;
    return GridView.builder(
      key: PageStorageKey('AllMoviesPage'),
      // cacheExtent: 50,
      itemCount: movies.length,
      itemBuilder: (ctx, i) {
        final item = movies[i];
        return MovieItem(   
          id: item.id,                 
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 3,
      ),
    );
  }
}
