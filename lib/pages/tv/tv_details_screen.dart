import 'package:e_movies/providers/tv.dart' as prov;
import 'package:e_movies/widgets/tv/tv_item.dart';
import 'package:flutter/material.dart';

class TVDetailsScreen extends StatefulWidget {
  @override
  _TVDetailsScreenState createState() => _TVDetailsScreenState();
}

class _TVDetailsScreenState extends State<TVDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final item = ModalRoute.of(context).settings.arguments as prov.TVItem;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                print('tv details -----------> ${constraints.maxWidth}');
                return ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: constraints.maxHeight * 0.5,
                          width: constraints.maxWidth,
                          child: TVItem(
                            item: item,
                            withFooter: false,
                            tappable: false,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
