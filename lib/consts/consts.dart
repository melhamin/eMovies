import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

// Theme and text styles

TextStyle kTitleStyle = TextStyle(
  fontFamily: 'Helvatica',
  fontWeight: FontWeight.bold,
  fontSize: 20,
  color: Hexcolor('#FFFFFF').withOpacity(0.87),
);
TextStyle kTitleStyle2 = TextStyle(
  fontFamily: 'Helvatica',
  fontWeight: FontWeight.bold,
  fontSize: 18,
  color: Hexcolor('#FFFFFF').withOpacity(0.87),
);
TextStyle kTitleStyle3 = TextStyle(
  fontFamily: 'Helvatica',
  fontWeight: FontWeight.bold,
  fontSize: 16,
  color: Hexcolor('#FFFFFF').withOpacity(0.87),
);
TextStyle kBodyStyle = TextStyle(
  fontFamily: 'Helvatica',
  fontWeight: FontWeight.w500,
  fontSize: 16,
  color: Hexcolor('#FFFFFF').withOpacity(0.87),
  height: 1.5,
);
TextStyle kBodyStyle2 = TextStyle(
  fontFamily: 'Helvatica',
  fontWeight: FontWeight.w500,
  fontSize: 16,
  color: Hexcolor('#FFFFFF').withOpacity(0.87),
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
    // fontWeight: FontWeight.bold,
    fontSize: 16,
    // color: Hexcolor('#DEDEDE'),
    color: Colors.white.withOpacity(0.6));
TextStyle kAppBarTextStyle = TextStyle(
  fontFamily: 'Helvatica',
  // fontWeight: FontWeight.bold,
  fontSize: 16,
  color: Colors.pink,
);

TextStyle kBottomBarTextStyle = TextStyle(
  fontFamily: 'Helvatica',
  fontWeight: FontWeight.bold,
  fontSize: 14,
);
TextStyle kSelectedTabStyle = TextStyle(
    fontFamily: 'Helvatica',
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: Colors.white.withOpacity(0.87));

TextStyle kUnselectedTabStyle = TextStyle(
  fontFamily: 'Helvatica',
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: Colors.white.withOpacity(0.6),
);

TextStyle kTBStyle = TextStyle(
  fontFamily: 'Helvatica',
  fontWeight: FontWeight.bold,
  fontSize: 16,
  color: Hexcolor('#55AB55'),
);

TextStyle kBTStyle = TextStyle(
  fontFamily: 'Helvatica',
  fontSize: 18,
  fontWeight: FontWeight.bold,
  color: Colors.pink,
);

TextStyle kListsItemTitleStyle = TextStyle(
  fontFamily: 'Helvatica',
  fontSize: 18,
  // fontWeight: FontWeight.bold,
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
Color BASELINE_COLOR_TRANSPARENT = Hexcolor('#BF121212').withOpacity(0.45);
// Color BASELINE_COLOR = Color.fromRGBO(28, 28, 30, 1);
// Color BASELINE_COLOR = Hexcolor('#191414');
Color BASELINE_COLOR = Hexcolor('#121212');
Color ONE_LEVEL_ELEVATION = Hexcolor('#212121');
// Color ONE_LEVEL_ELEVATION = Hexcolor('#121212');
Color ONE_LEVEL_ELEVATION_WITHOPACITY = Hexcolor('#BF212121');
// Color TWO_LEVEL_ELEVATION = Hexcolor('#202020');
Color TWO_LEVEL_ELEVATION = Hexcolor('#303030');
Color THREE_LEVEL_ELEVATION = Hexcolor('#424242');
const double APP_BAR_HEIGHT = 56;
const double DEFAULT_PADDING = 15;
const AVATAR_RADIUS = 20;
const LOADING_INDICATOR_SIZE = 21.0;
const TOAST_DURATION = 2;

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

// currently, for simplicity, genre images are loaded from assets
const MOVIE_GENRE_DETAILS = [
  {
    'imageUrl': 'assets/images/movies/action.jpg',
    'title': 'Action',
    'genreId': 28,
  },
  {
    'imageUrl': 'assets/images/movies/adventure.jpg',
    'title': 'Adventure',
    'genreId': 12,
  },
  {
    'imageUrl': 'assets/images/movies/animation.jpg',
    'title': 'Animation',
    'genreId': 16,
  },
  {
    'imageUrl': 'assets/images/movies/comedy.jpg',
    'title': 'Comedy',
    'genreId': 35,
  },
  {
    'imageUrl': 'assets/images/movies/fantasy.jpg',
    'title': 'Fantasy',
    'genreId': 14,
  },
  {
    'imageUrl': 'assets/images/movies/crime.jpeg',
    'title': 'Crime',
    'genreId': 80,
  },
  {
    'imageUrl': "assets/images/movies/documentary.jpg",
    'title': 'Documentary',
    'genreId': 99,
  },
  {
    'imageUrl': 'assets/images/movies/drama.jpg',
    'title': 'Drama',
    'genreId': 18,
  },
  {
    'imageUrl': 'assets/images/movies/family.jpg',
    'title': 'Family',
    'genreId': 10751,
  },
  {
    'imageUrl': 'assets/images/movies/history.jpg',
    'title': 'History',
    'genreId': 36,
  },
  {
    'imageUrl': 'assets/images/movies/horror.jpg',
    'title': 'Horror',
    'genreId': 27,
  },
  {
    'imageUrl': 'assets/images/movies/music.jpg',
    'title': 'Music',
    'genreId': 10402,
  },
  {
    'imageUrl': 'assets/images/movies/mystery.jpg',
    'title': 'Mystery',
    'genreId': 9648,
  },
  {
    'imageUrl': 'assets/images/movies/romance.jpg',
    'title': 'Romance',
    'genreId': 10749,
  },
  {
    'imageUrl': 'assets/images/movies/sci-fi.jpg',
    'title': 'Sci-Fi',
    'genreId': 878,
  },
  {
    'imageUrl': 'assets/images/movies/thriller.jpg',
    'title': 'Thriller',
    'genreId': 53,
  },
  {
    'imageUrl': 'assets/images/movies/war.jpg',
    'title': 'War',
    'genreId': 10752,
  },
  {
    'imageUrl': 'assets/images/movies/western.jpg',
    'title': 'Western',
    'genreId': 37,
  }
];

const Map<int, String> TV_GENRES = {
  10759: "Action & Adventure",
  16: "Animation",
  35: "Comedy",
  80: "Crime",
  99: "Documentary",
  18: "Drama",
  10751: "Family",
  10762: "Kids",
  878: "Sci-Fi",
  9648: "Mystery",
  10763: "News",
  10764: "Reality",
  10765: "Sci-Fi & Fantasy",
  10767: "Talk",
  10766: "Soap",
  10768: "War & Politics",
  37: "Western",
};

const TV_GENRE_DETAILS = [
  {
    'imageUrl': 'assets/images/tv/action_adventure.jpg',
    'title': 'Action & Adventure',
    'genreId': 10759,
  },
  {
    'imageUrl': 'assets/images/tv/animation.jpg',
    'title': 'Animation',
    'genreId': 16,
  },
  {
    'imageUrl': 'assets/images/tv/comedy.jpg',
    'title': 'Comedy',
    'genreId': 35,
  },
  {
    'imageUrl': 'assets/images/tv/crime.jpg',
    'title': 'Crime',
    'genreId': 80,
  },
  {
    'imageUrl': "assets/images/tv/documentary.jpg",
    'title': 'Documentary',
    'genreId': 99,
  },
  {
    'imageUrl': 'assets/images/tv/drama.jpg',
    'title': 'Drama',
    'genreId': 18,
  },
  {
    'imageUrl': 'assets/images/tv/family.jpg',
    'title': 'Family',
    'genreId': 10751,
  },
  {
    'imageUrl': 'assets/images/tv/kids.jpg',
    'title': 'Kids',
    'genreId': 10762,
  },
  {
    'imageUrl': 'assets/images/tv/sci-fi.jpg',
    'title': 'Sci-Fi',
    'genreId': 878,
  },
  {
    'imageUrl': 'assets/images/tv/reality.jpg',
    'title': 'Reality',
    'genreId': 10764,
  },
  {
    'imageUrl': 'assets/images/tv/mystery.jpg',
    'title': 'Mystery',
    'genreId': 9648,
  },
  {
    'imageUrl': 'assets/images/tv/sci-fi_fantasy.jpg',
    'title': 'Sci-Fi & Fantasy',
    'genreId': 10765,
  },
  {
    'imageUrl': 'assets/images/tv/news.jpg',
    'title': 'News',
    'genreId': 10763,
  },
  {
    'imageUrl': 'assets/images/tv/soap.jpg',
    'title': 'Soap',
    'genreId': 10766,
  },
  {
    'imageUrl': 'assets/images/tv/war_politics.jpg',
    'title': 'War & Politics',
    'genreId': 10767,
  },
  {
    'imageUrl': 'assets/images/tv/talk.jpg',
    'title': 'Talk',
    'genreId': 10767,
  },
  {
    'imageUrl': 'assets/images/tv/western.jpg',
    'title': 'Western',
    'genreId': 37,
  },
];
