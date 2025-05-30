class ProductModel {
  final String id;
  final String name;
  final String description;
  final String image;
  final double price;
  final double rating;
  final bool isFavorite;
  final String category;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.rating,
    this.isFavorite = false,
    required this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      rating: (json['rating'] ?? 0).toDouble(),
      isFavorite: json['isFavorite'] ?? false,
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'price': price,
      'rating': rating,
      'isFavorite': isFavorite,
      'category': category,
    };
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    String? image,
    double? price,
    double? rating,
    bool? isFavorite,
    String? category,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      isFavorite: isFavorite ?? this.isFavorite,
      category: category ?? this.category,
    );
  }
}
