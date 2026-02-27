import 'package:flutter_nexus/core/utils/typedefs.dart';
import '../entities/product.dart';

abstract interface class ProductRepository {
  ResultFuture<List<Product>> getProducts({int skip = 0, int limit = 20});
  ResultFuture<List<Product>> searchProducts(String query);
  ResultFuture<Product> getProductDetail(int id);
  ResultFuture<List<Product>> getRecentProducts();
}
