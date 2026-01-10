class Level {
  final int id;
  final String name;
  final String imageUrl;

  Level({required this.id, required this.name, required this.imageUrl});

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'no_name',
      imageUrl: json['image_url'] ?? 'no_image_url',
    );
  }
}
