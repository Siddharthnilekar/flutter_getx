import 'dart:developer' as developer;

class ProductModel {
  final int? id; // Nullable to handle null from API
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final Rating rating;

  ProductModel({
    this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Log JSON for debugging
    developer.log('Parsing ProductModel: $json', name: 'ProductModel');

    return ProductModel(
      id: json['id'] as int?, // Handle null
      title: json['title']?.toString() ?? 'No Title',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      description: json['description']?.toString() ?? 'No Description',
      category: json['category']?.toString() ?? 'No Category',
      image: json['image']?.toString() ?? '',
      rating: Rating.fromJson(json['rating'] ?? {'rate': 0.0, 'count': 0}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      'rating': rating.toJson(),
    };
  }
}

class Rating {
  final double rate;
  final int? count; // Nullable to handle null

  Rating({
    required this.rate,
    this.count,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    // Log JSON for debugging
    developer.log('Parsing Rating: $json', name: 'Rating');

    return Rating(
      rate: (json['rate'] as num?)?.toDouble() ?? 0.0,
      count: json['count'] as int?, // Handle null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rate': rate,
      'count': count,
    };
  }
}