class ActorModel {
  final int id;
  final String name;
  final String department;
  final String imageUrl;

  ActorModel({
    this.id,
    this.name,
    this.imageUrl,
    this.department,
  });

  static ActorModel fromJson(json) {
    return ActorModel(
      id: json['id'],
      name: json['name'],
      imageUrl: json['profile_path'],
      department: json['known_for_department'],
    );
  }
}