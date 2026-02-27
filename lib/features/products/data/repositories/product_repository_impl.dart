import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import 'package:flutter_nexus/core/errors/failures.dart';
import 'package:flutter_nexus/core/utils/typedefs.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_data_source.dart';
import '../datasources/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  const ProductRepositoryImpl({
    required ProductRemoteDataSource remoteDataSource,
    required ProductLocalDataSource localDataSource,
  })  : _remote = remoteDataSource,
        _local = localDataSource;

  final ProductRemoteDataSource _remote;
  final ProductLocalDataSource _local;

  // ─── Public API ──────────────────────────────────────────────────────────────

  @override
  ResultFuture<List<Product>> getProducts({
    int skip = 0,
    int limit = 20,
  }) async {
    try {
      final products = await _remote.getProducts(skip: skip, limit: limit);
      return Right(products);
    } on DioException catch (e) {
      return Left(_dioToFailure(e));
    }
  }

  @override
  ResultFuture<List<Product>> searchProducts(String query) async {
    try {
      final products = await _remote.searchProducts(query);
      return Right(products);
    } on DioException catch (e) {
      return Left(_dioToFailure(e));
    }
  }

  @override
  ResultFuture<Product> getProductDetail(int id) async {
    try {
      final product = await _remote.getProductDetail(id);
      await _local.cacheProduct(product);
      return Right(product);
    } on DioException catch (e) {
      // Sin red → intentar desde caché antes de retornar failure
      final cached = await _local.getCachedProduct(id);
      if (cached != null) return Right(cached);
      return Left(_dioToFailure(e));
    } on Exception catch (e) {
      // Cualquier fallo al persistir en caché se reporta como CacheFailure
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<List<Product>> getRecentProducts() async {
    try {
      final products = await _local.getRecentProducts();
      return Right(products);
    } on Exception catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────────

  /// Convierte un [DioException] en [NetworkFailure] o [ServerFailure]
  /// según el tipo de error.
  Failure _dioToFailure(DioException e) {
    final isNetworkError = switch (e.type) {
      DioExceptionType.connectionError ||
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout =>
        true,
      _ => false,
    };

    if (isNetworkError) {
      return NetworkFailure(message: e.message ?? 'Network error');
    }

    return ServerFailure(
      message: e.message ?? 'Server error',
      statusCode: e.response?.statusCode,
    );
  }
}
