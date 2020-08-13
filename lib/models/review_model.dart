class ReviewModel {
  final String author;
  final String content;

  ReviewModel({this.author, this.content});

  static ReviewModel fromJson(json) {
    // print('json -------------> $json');
    return ReviewModel(
      author: json['author'],
      content: json['content'],
    );
  }
}