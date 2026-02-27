import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/product_model.dart';

abstract interface class ProductLocalDataSource {
  /// Guarda [product] al inicio del historial.
  /// Si ya existía, lo mueve al inicio.
  /// El historial nunca supera los 5 elementos.
  Future<void> cacheProduct(ProductModel product);

  /// Retorna los últimos productos visitados (máx. 5), del más reciente al más antiguo.
  Future<List<ProductModel>> getRecentProducts();
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  const ProductLocalDataSourceImpl(this._prefs);

  final SharedPreferences _prefs;

  static const _kKey = 'recent_products';
  static const _kMaxItems = 5;

  @override
  Future<void> cacheProduct(ProductModel product) async {
    final raw = _prefs.getStringList(_kKey) ?? [];

    // Decodifica lista actual
    final products = raw
        .map((e) => ProductModel.fromJson(jsonDecode(e) as Map<String, dynamic>))
        .toList();

    // Si ya existe, lo elimina para moverlo al frente
    products.removeWhere((p) => p.id == product.id);

    // Inserta el más reciente al inicio
    products.insert(0, product);

    // Descarta el más antiguo si supera el límite
    if (products.length > _kMaxItems) products.removeLast();

    await _prefs.setStringList(
      _kKey,
      products.map((p) => jsonEncode(p.toJson())).toList(),
    );
  }

  @override
  Future<List<ProductModel>> getRecentProducts() async {
    final raw = _prefs.getStringList(_kKey) ?? [];
    return raw
        .map((e) => ProductModel.fromJson(jsonDecode(e) as Map<String, dynamic>))
        .toList();
  }
}
