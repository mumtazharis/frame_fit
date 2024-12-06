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
      name: json['model'], // Ganti ke 'model' sesuai respons API
      category: json['bentuk'], // Ganti ke 'bentuk' sesuai respons API
      imagePath: json['foto'], // Properti untuk URL gambar
      isFavorite: json['isFavorite'] ?? false,
    );
  }
}