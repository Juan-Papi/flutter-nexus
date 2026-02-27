import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.title,
    required super.description,
    required super.price,
    required super.discountPercentage,
    required super.rating,
    required super.stock,
    required super.category,
    required super.thumbnail,
    required super.images,
    super.brand,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['id'] as int,
        title: json['title'] as String,
        description: json['description'] as String,
        price: (json['price'] as num).toDouble(),
        discountPercentage: (json['discountPercentage'] as num).toDouble(),
        rating: (json['rating'] as num).toDouble(),
        stock: json['stock'] as int,
        brand: json['brand'] as String?,
        category: json['category'] as String,
        thumbnail: json['thumbnail'] as String,
        images: List<String>.from(json['images'] as List),
      );

  factory ProductModel.fromEntity(Product product) => ProductModel(
        id: product.id,
        title: product.title,
        description: product.description,
        price: product.price,
        discountPercentage: product.discountPercentage,
        rating: product.rating,
        stock: product.stock,
        brand: product.brand,
        category: product.category,
        thumbnail: product.thumbnail,
        images: product.images,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'price': price,
        'discountPercentage': discountPercentage,
        'rating': rating,
        'stock': stock,
        'brand': brand,
        'category': category,
        'thumbnail': thumbnail,
        'images': images,
      };
}
