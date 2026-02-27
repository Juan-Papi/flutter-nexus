import 'package:flutter_nexus/features/products/domain/entities/product.dart';

sealed class ProductState {
  const ProductState();
}

class ProductInitial extends ProductState {
  const ProductInitial();
}

class ProductLoading extends ProductState {
  const ProductLoading();
}

class ProductLoaded extends ProductState {
  const ProductLoaded(this.products);

  final List<Product> products;
}

class ProductError extends ProductState {
  const ProductError(this.message);

  final String message;
}

/// Red no disponible pero hay productos en caché para mostrar.
class ProductOffline extends ProductState {
  const ProductOffline(this.recentProducts);

  final List<Product> recentProducts;
}
