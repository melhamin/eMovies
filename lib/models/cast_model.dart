import 'package:flutter/material.dart';
class CastModel {
  final int id;
  final String name;
  final String imageUrl;

  String character;
  String job;

  CastModel({
    @required this.id,
    @required this.name,
    @required this.imageUrl,
    this.character,
    this.job,
  });

  static CastModel fromJson(json) {
    return CastModel(
      id: json['id'],
      name: json['name'],
      imageUrl: json['profile_path'],
      character: json['character'] ?? 'N/A',
      job: json['job'] ?? 'N/A',
    );
  }
}