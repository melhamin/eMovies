import 'package:e_movies/models/init_data.dart';
import 'package:e_movies/models/movie_model.dart';
import 'package:e_movies/models/person_model.dart';
import 'package:e_movies/screens/movie/cast/widgets/actor_movies.dart';
import 'package:e_movies/screens/movie/cast/widgets/biography.dart';
import 'package:e_movies/widgets/back_button.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/widgets/nav_bar.dart';
import 'package:e_movies/providers/cast.dart';

class CastDetails extends StatefulWidget {
  static const routeName = '/cast-details';

  @override
  _CastDetailsState createState() => _CastDetailsState();
}

class _CastDetailsState extends State<CastDetails>
    with SingleTickerProviderStateMixin {
  bool _isInitLoaded = true;
  bool _isLoading = true;
  TabController _tabController;
  int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: _selectedIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInitLoaded) {
      final item = ModalRoute.of(context).settings.arguments as dynamic;
      final id = item.id;
      Provider.of<Cast>(context, listen: false)
          .getPersonDetails(id)
          .then((value) {
        setState(() {
          _isLoading = false;
          _isInitLoaded = false;
        });
      });
    }
    super.didChangeDependencies();
  }

  Widget _buildTabBar() {
    return NavBar(
      tabController: _tabController,
      tabs: [
        Tab(
          child: Align(
            alignment: Alignment.center,
            child: Text('Biography', style: kTitleStyle2)
          ),
        ),
        Tab(
          child: Align(
            alignment: Alignment.center,
            child: Text('Movies', style: kTitleStyle2),
          ),
        ),
        // Tab(icon: Icon(Icons.edit)),
      ],
    );
  }

  Widget _buildTabs(PersonModel item) {
    return TabBarView(
      controller: _tabController,
      children: [
        Biography(item: item, isLoading: _isLoading),
        ActorMovies(item: item, isLoading: _isLoading),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    final item = ModalRoute.of(context).settings.arguments as dynamic;
    final screenHeight = MediaQuery.of(context).size.height;
    PersonModel person;
    if (!_isLoading) person = Provider.of<Cast>(context).person;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return ListView(
                  padding: EdgeInsets.only(top: screenHeight * 0.4),
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    // _buildTabBar(),
                    Container(
                      color: ONE_LEVEL_ELEVATION,
                      width: constraints.maxWidth,
                      child: _buildTabBar(),
                    ),
                    Container(
                      height: constraints.maxHeight,
                      child: _buildTabs(person),
                    ),
                  ],
                );
              },
            ),
            Container(
              width: double.infinity,
              height: screenHeight * 0.4,
              child: CachedNetworkImage(
                  imageUrl: IMAGE_URL + item.imageUrl, fit: BoxFit.cover),
            ),
            Positioned(
              top: 10,
              left: 0,
              child: CustomBackButton(text: item.name),
            ),
          ],
        ),
      ),
    );
  }
}
