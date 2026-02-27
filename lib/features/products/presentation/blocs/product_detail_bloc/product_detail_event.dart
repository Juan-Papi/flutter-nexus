import 'package:equatable/equatable.dart';

sealed class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();
}

/// Carga el detalle del producto con [id] y actualiza el historial local.
class LoadProductDetail extends ProductDetailEvent {
  const LoadProductDetail(this.id);

  final int id;

  @override
  List<Object?> get props => [id];
}
