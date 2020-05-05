import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

// Theme and text styles

TextStyle kTitleStyle = TextStyle(
  fontFamily: 'Helvatica',
  fontWeight: FontWeight.bold,
  fontSize: 21,
  color: Hexcolor('#FFFFFF').withOpacity(0.87),
);
TextStyle kTitleStyle2 = TextStyle(
  fontFamily: 'Helvatica',
  fontWeight: FontWeight.bold,
  fontSize: 18,
  color: Hexcolor('#FFFFFF').withOpacity(0.87),
);
TextStyle kBodyStyle = TextStyle(
  fontFamily: 'Helvatica',
  fontWeight: FontWeight.w500,
  fontSize: 16,
  color: Hexcolor('#FFFFFF').withOpacity(0.87),
  height: 1.5,
);
TextStyle kSubtitle1 = TextStyle(
  fontFamily: 'Helvatica',
  // fontWeight: FontWeight.bold,
  fontSize: 16,
  color: Hexcolor('#FFFFFF').withOpacity(0.6),
);
TextStyle kSubtitle2 = TextStyle(
  fontFamily: 'Helvatica',
  // fontWeight: FontWeight.bold,
  fontSize: 14,
  color: Hexcolor('#FFFFFF').withOpacity(0.6),
);

TextStyle kItemTitle = TextStyle(
    fontFamily: 'Helvatica',
    fontWeight: FontWeight.w600,
    fontSize: 18,
    color: Hexcolor('#DEDEDE'));
TextStyle kInGridTitle = TextStyle(
  fontFamily: 'Helvatica',
  fontWeight: FontWeight.w500,
  fontSize: 16,
  color: Hexcolor('#DEDEDE'),
);

TextStyle kSeeAll = TextStyle(
  fontFamily: 'Helvatica',
  // fontWeight: FontWeight.,
  fontSize: 16,
  color: Hexcolor('#DEDEDE'),
);

Color kTextBorderColor = Colors.white24;

// Movies
// const
const BASE_URL = 'https://api.themoviedb.org/3';
const IMAGE_WEIGHT = 'w500';
const IMAGE_URL = 'https://image.tmdb.org/t/p/$IMAGE_WEIGHT';

const THUMBNAIL_URL = '';

const Color TRRANSPARENT_BACKGROUND_COLOR = Color(0x991C306D);
const Color LINE_COLOR = Colors.white10;
Color BASELINE_COLOR_TRANSPARENT = Hexcolor('#BF121212');
Color BASELINE_COLOR = Hexcolor('#121212');
const double APP_BAR_HEIGHT = 56;
const double LEFT_PADDING = 15;
const AVATAR_RADIUS = 20;
const LOADING_INDICATOR_SIZE = 21.0;

// Genres
const Map<int, String> MOVIE_GENRES = {
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
  // -1: "Unk",
};

const Map<int, String> TV_GENRES = {
  10759: "Action & Adventure",
  16: "Animation",
  35: "Comedy",
  80: "Crime",
  99: "Documentary",
  18: "Drama",
  10751: "Family",
  10762: "Kids",
  9648: "Mystery",
  10763: "News",
  10764: "Reality",
  10765: "Sci-Fi & Fantasy",
  10766: "Soap",
  10767: "Talk",
  10768: "War & Politics",
  37: "Western",
  878: "Sci-Fi",
};

// currently, for simplicity, genre images are loaded from assets
const MOVIE_GENRE_DETAILS = [
  {
    'imageUrl': 'assets/images/action.jpg',
    'title': 'Action',
    'genreId': 28,
  },
  {
    'imageUrl': 'assets/images/adventure.jpg',
    'title': 'Adventure',
    'genreId': 12,
  },
  {
    'imageUrl': 'assets/images/animation.jpg',
    'title': 'Animation',
    'genreId': 16,
  },
  {
    'imageUrl': 'assets/images/comedy.jpg',
    'title': 'Comedy',
    'genreId': 35,
  },
  {
    'imageUrl': 'assets/images/crime.jpeg',
    'title': 'Crime',
    'genreId': 80,
  },
  {
    'imageUrl': "assets/images/documentary.jpg",
    'title': 'Documentary',
    'genreId': 99,
  },
  {
    'imageUrl': 'assets/images/drama.jpg',
    'title': 'Drama',
    'genreId': 18,
  },
  {
    'imageUrl': 'assets/images/family.jpg',
    'title': 'Family',
    'genreId': 10751,
  },
  {
    'imageUrl': 'assets/images/history.jpg',
    'title': 'History',
    'genreId': 36,
  },
  {
    'imageUrl': 'assets/images/horror.jpg',
    'title': 'Horror',
    'genreId': 14,
  },
  {
    'imageUrl': 'assets/images/music.jpg',
    'title': 'Music',
    'genreId': 10402,
  },
  {
    'imageUrl': 'assets/images/mystery.jpg',
    'title': 'Mystery',
    'genreId': 9648,
  },
  {
    'imageUrl': 'assets/images/romance.jpg',
    'title': 'Romance',
    'genreId': 10749,
  },
  {
    'imageUrl': 'assets/images/sci-fi.jpg',
    'title': 'Sci-Fi',
    'genreId': 878,
  },
  {
    'imageUrl': 'assets/images/thriller.jpg',
    'title': 'Thriller',
    'genreId': 53,
  },
  {
    'imageUrl': 'assets/images/war.jpg',
    'title': 'War',
    'genreId': 10752,
  },
  {
    'imageUrl': 'assets/images/western.jpg',
    'title': 'Western',
    'genreId': 37,
  }
];
