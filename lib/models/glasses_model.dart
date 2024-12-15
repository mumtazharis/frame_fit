class Glasses {
  final int kacamata_id; 
  final String name;
  final String category;
  final String imagePath;
  bool isFavorite;

  Glasses({
    required this.kacamata_id, 
    required this.name,
    required this.category,
    required this.imagePath,
    this.isFavorite = false,
  });

  factory Glasses.fromJson(Map<String, dynamic> json) {
    return Glasses(
      kacamata_id: json['kacamata_id'],
      name: json['model'],
      category: json['bentuk'],
      imagePath: json['foto'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Glasses copyWith({bool? isFavorite}) {
    return Glasses(
      kacamata_id: this.kacamata_id, 
      name: this.name,
      category: this.category,
      imagePath: this.imagePath,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
