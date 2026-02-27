import 'package:equatable/equatable.dart';
import 'package:flutter_nexus/features/products/domain/entities/product.dart';

sealed class ProductState extends Equatable {
  const ProductState();
}

class ProductInitial extends ProductState {
  const ProductInitial();

  @override
  List<Object?> get props => [];
}

class ProductLoading extends ProductState {
  const ProductLoading();

  @override
  List<Object?> get props => [];
}

class ProductLoaded extends ProductState {
  const ProductLoaded(this.products);

  final List<Product> products;

  @override
  List<Object?> get props => [products];
}

class ProductError extends ProductState {
  const ProductError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Red no disponible pero hay productos en caché para mostrar.
class ProductOffline extends ProductState {
  const ProductOffline(this.recentProducts);

  final List<Product> recentProducts;

  @override
  List<Object?> get props => [recentProducts];
}
