class VideoModel {
  final String id;
  final String key;
  final String name;
  final String site;
  final int size;
  final String type;

  VideoModel({
    this.id,
    this.key,
    this.name,
    this.site,
    this.size,
    this.type,
  });

  static VideoModel fromJson(dynamic json) {
    return VideoModel(
      id: json['id'],
      name: json['name'],
      key: json['key'],
      site: json['site'],
      size: json['size'],
      type: json['type'],
    );
  }
}