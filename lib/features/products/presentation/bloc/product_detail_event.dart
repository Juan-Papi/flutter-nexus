sealed class ProductDetailEvent {
  const ProductDetailEvent();
}

/// Carga el detalle del producto con [id] y actualiza el historial local.
class LoadProductDetail extends ProductDetailEvent {
  const LoadProductDetail(this.id);

  final int id;
}
