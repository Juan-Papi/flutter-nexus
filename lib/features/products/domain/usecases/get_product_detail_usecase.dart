import 'package:flutter_nexus/core/usecases/usecase.dart';
import 'package:flutter_nexus/core/utils/typedefs.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductDetailUseCase implements UseCase<Product, int> {
  const GetProductDetailUseCase(this._repository);

  final ProductRepository _repository;

  @override
  ResultFuture<Product> call(int id) => _repository.getProductDetail(id);
}
