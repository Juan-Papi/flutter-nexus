import 'package:equatable/equatable.dart';
import 'package:flutter_nexus/features/products/domain/entities/product.dart';

sealed class ProductDetailState extends Equatable {
  const ProductDetailState();
}

class ProductDetailInitial extends ProductDetailState {
  const ProductDetailInitial();

  @override
  List<Object?> get props => [];
}

class ProductDetailLoading extends ProductDetailState {
  const ProductDetailLoading();

  @override
  List<Object?> get props => [];
}

/// Estado cargado: producto principal + últimos 5 del historial.
class ProductDetailLoaded extends ProductDetailState {
  const ProductDetailLoaded({
    required this.product,
    this.recentProducts = const [],
  });

  final Product product;
  final List<Product> recentProducts;

  @override
  List<Object?> get props => [product, recentProducts];
}

/// Fallo al cargar el detalle (ej. sin red), pero con los recientes
/// disponibles desde el caché local para seguir mostrándolos en la UI.
class ProductDetailError extends ProductDetailState {
  const ProductDetailError(this.message, {this.recentProducts = const []});

  final String message;
  final List<Product> recentProducts;

  @override
  List<Object?> get props => [message, recentProducts];
}
