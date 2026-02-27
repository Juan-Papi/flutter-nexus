import 'package:flutter_nexus/core/network/dio_client.dart';
import '../models/product_model.dart';

abstract interface class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts({int skip = 0, int limit = 20});
  Future<List<ProductModel>> searchProducts(String query);
  Future<ProductModel> getProductDetail(int id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  const ProductRemoteDataSourceImpl(this._client);

  final DioClient _client;

  @override
  Future<List<ProductModel>> getProducts({
    int skip = 0,
    int limit = 20,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/products',
      queryParameters: {'skip': skip, 'limit': limit},
    );
    final list = response.data!['products'] as List<dynamic>;
    return list
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/products/search',
      queryParameters: {'q': query},
    );
    final list = response.data!['products'] as List<dynamic>;
    return list
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ProductModel> getProductDetail(int id) async {
    final response =
        await _client.get<Map<String, dynamic>>('/products/$id');
    return ProductModel.fromJson(response.data!);
  }
}
