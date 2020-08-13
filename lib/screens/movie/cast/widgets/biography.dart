import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/models/person_model.dart';
import 'package:e_movies/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';


class Biography extends StatelessWidget {
  final PersonModel item;
  final bool isLoading;
  Biography({this.item, this.isLoading});

  Widget _buildLoadingIndicator(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 100),
      child: Center(
        child: LoadingIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(
            bottom:
                MediaQuery.of(context).size.height * 0.4 + 2 * kToolbarHeight),
        child: isLoading
            ? _buildLoadingIndicator(context)
            : Container(
                padding: EdgeInsets.symmetric(
                    horizontal: DEFAULT_PADDING, vertical: 10),
                child: Text(
                  item.biography,
                  style: TextStyle(
                    fontSize: 16,
                    height: 2,
                    color: Colors.white70,
                  ),
                  softWrap: true,
                ),
              ));
  }
}
