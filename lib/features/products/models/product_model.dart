class Product {
  final String name;
  final String? imageUrl;
  // Add other fields as necessary, e.g., description, price

  Product({
    required this.name,
    this.imageUrl,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    String? imageUrl;
    // Check if 'images' field exists, is a List, and is not empty.
    if (map['images'] is List && (map['images'] as List).isNotEmpty) {
      // Ensure the first element is a string before assigning.
      final firstImage = (map['images'] as List).first;
      if (firstImage is String) {
        imageUrl = firstImage;
      }
    }

    return Product(
      name: map['name'] ?? 'Nombre no disponible',
      imageUrl: imageUrl,
    );
  }
}
