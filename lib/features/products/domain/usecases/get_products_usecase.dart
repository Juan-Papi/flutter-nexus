import 'package:flutter_nexus/core/usecases/usecase.dart';
import 'package:flutter_nexus/core/utils/typedefs.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductsParams {
  const GetProductsParams({this.skip = 0, this.limit = 20});

  final int skip;
  final int limit;
}

class GetProductsUseCase implements UseCase<List<Product>, GetProductsParams> {
  const GetProductsUseCase(this._repository);

  final ProductRepository _repository;

  @override
  ResultFuture<List<Product>> call(GetProductsParams params) =>
      _repository.getProducts(skip: params.skip, limit: params.limit);
}
