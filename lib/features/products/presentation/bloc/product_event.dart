sealed class ProductEvent {
  const ProductEvent();
}

/// Carga la lista inicial (o recarga paginada).
class LoadProducts extends ProductEvent {
  const LoadProducts({this.skip = 0, this.limit = 20});

  final int skip;
  final int limit;
}

/// Lanza una búsqueda por [query]. Si [query] está vacío, recarga la lista.
class SearchProducts extends ProductEvent {
  const SearchProducts(this.query);

  final String query;
}
