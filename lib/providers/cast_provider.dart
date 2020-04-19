import 'package:flutter/cupertino.dart';

class CastItem {
  final int id;
  final String name;
  final String imageUrl;

  String character;
  String job;

  CastItem({
    @required this.id,
    @required this.name,
    @required this.imageUrl,
    this.character,
    this.job,
  });
}
// class CastProvider with ChangeNotifier {

//   final int id;
//   final String name;
//   final String imageUrl;

//   String character;
//   String job;

// }
