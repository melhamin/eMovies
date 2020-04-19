import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

// MoviesProvider
const IMAGE_WEIGHT = 'w500';
const IMAGE_URL = 'https://image.tmdb.org/t/p/$IMAGE_WEIGHT';
const PLACEHOLDER_IMAGE_URL =
    'blob:https://www.pngfuel.com/5e3dae69-7ade-4e65-b1ab-8a2cd4eedc6c';

const Color TRRANSPARENT_BACKGROUND_COLOR = Color(0x991C306D);
const Color LINE_COLOR = Colors.white10;
Color BASELINE_COLOR_TRANSPARENT = Hexcolor('#BF121212');
Color BASELINE_COLOR = Hexcolor('#121212');
const double APP_BAR_HEIGHT = 56;
const double PADDING = 15;
const AVATAR_RADIUS = 20;

// Pages Tags
const String TRENDING_TAG = 'trending';
const String UPCOMING_TAG = 'upcoming';

// Genres
const Map<int, String> GENRES = {
  28: "Action",
  12: "Adventure",
  16: "Animation",
  35: "Comedy",
  80: "Crime",
  99: "Documentary",
  18: "Drama",
  10751: "Family",
  14: "Fantasy",
  36: "History",
  27: "Horror",
  10402: "Music",
  9648: "Mystery",
  10749: "Romance",
  878: "Sci-Fi",
  10770: "TV Movie",
  53: "Thriller",
  10752: "War",
  37: "Western",
  -1: "Unk",
};
