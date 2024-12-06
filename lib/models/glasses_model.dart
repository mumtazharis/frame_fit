class Glasses {
  final String name;
  final String category;
  final String imagePath;
  bool isFavorite;

  Glasses({
    required this.name,
    required this.category,
    required this.imagePath,
    this.isFavorite = false,
  });

  factory Glasses.fromJson(Map<String, dynamic> json) {
    return Glasses(
      name: json['model'],
      category: json['bentuk'],
      imagePath: json['foto'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }
}
