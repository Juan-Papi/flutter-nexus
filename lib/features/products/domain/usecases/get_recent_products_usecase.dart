import 'package:flutter_nexus/core/usecases/usecase.dart';
import 'package:flutter_nexus/core/utils/typedefs.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetRecentProductsUseCase implements UseCase<List<Product>, NoParams> {
  const GetRecentProductsUseCase(this._repository);

  final ProductRepository _repository;

  @override
  ResultFuture<List<Product>> call(NoParams params) =>
      _repository.getRecentProducts();
}
