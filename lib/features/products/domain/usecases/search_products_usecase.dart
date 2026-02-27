import 'package:flutter_nexus/core/usecases/usecase.dart';
import 'package:flutter_nexus/core/utils/typedefs.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class SearchProductsUseCase implements UseCase<List<Product>, String> {
  const SearchProductsUseCase(this._repository);

  final ProductRepository _repository;

  @override
  ResultFuture<List<Product>> call(String query) =>
      _repository.searchProducts(query);
}
