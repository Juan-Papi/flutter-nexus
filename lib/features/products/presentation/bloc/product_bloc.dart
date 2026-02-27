import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nexus/core/usecases/usecase.dart';
import 'package:flutter_nexus/features/products/domain/usecases/get_products_usecase.dart';
import 'package:flutter_nexus/features/products/domain/usecases/get_recent_products_usecase.dart';
import 'package:flutter_nexus/features/products/domain/usecases/search_products_usecase.dart';

import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc({
    required GetProductsUseCase getProductsUseCase,
    required SearchProductsUseCase searchProductsUseCase,
    required GetRecentProductsUseCase getRecentProductsUseCase,
  })  : _getProducts = getProductsUseCase,
        _searchProducts = searchProductsUseCase,
        _getRecentProducts = getRecentProductsUseCase,
        super(const ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<SearchProducts>(_onSearchProducts);
  }

  final GetProductsUseCase _getProducts;
  final SearchProductsUseCase _searchProducts;
  final GetRecentProductsUseCase _getRecentProducts;

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());
    final result = await _getProducts(
      GetProductsParams(skip: event.skip, limit: event.limit),
    );
    await result.fold(
      (failure) async {
        final recentResult = await _getRecentProducts(NoParams());
        recentResult.fold(
          (_) => emit(ProductError(failure.message)),
          (recent) => recent.isEmpty
              ? emit(ProductError(failure.message))
              : emit(ProductOffline(recent)),
        );
      },
      (products) async => emit(ProductLoaded(products)),
    );
  }

  Future<void> _onSearchProducts(
    SearchProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());
    final result = await _searchProducts(event.query);
    await result.fold(
      (failure) async {
        final recentResult = await _getRecentProducts(NoParams());
        recentResult.fold(
          (_) => emit(ProductError(failure.message)),
          (recent) => recent.isEmpty
              ? emit(ProductError(failure.message))
              : emit(ProductOffline(recent)),
        );
      },
      (products) async => emit(ProductLoaded(products)),
    );
  }
}
