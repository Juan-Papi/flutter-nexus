import 'package:flutter_nexus/features/products/domain/entities/product.dart';

sealed class ProductDetailState {
  const ProductDetailState();
}

class ProductDetailInitial extends ProductDetailState {
  const ProductDetailInitial();
}

class ProductDetailLoading extends ProductDetailState {
  const ProductDetailLoading();
}

/// Estado cargado: producto principal + últimos 5 del historial.
class ProductDetailLoaded extends ProductDetailState {
  const ProductDetailLoaded({
    required this.product,
    this.recentProducts = const [],
  });

  final Product product;
  final List<Product> recentProducts;
}

class ProductDetailError extends ProductDetailState {
  const ProductDetailError(this.message);

  final String message;
}
