class Section {
  final int id;
  final String name;
  final String imageUrl;

  Section({required this.id, required this.name, required this.imageUrl});

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'no_name',
      imageUrl: json['image_url'] ?? 'no_image_url',
    );
  }
}
