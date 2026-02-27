import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nexus/features/products/domain/usecases/get_products_usecase.dart';
import 'package:flutter_nexus/features/products/domain/usecases/search_products_usecase.dart';

import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc({
    required GetProductsUseCase getProductsUseCase,
    required SearchProductsUseCase searchProductsUseCase,
  })  : _getProducts = getProductsUseCase,
        _searchProducts = searchProductsUseCase,
        super(const ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<SearchProducts>(_onSearchProducts);
  }

  final GetProductsUseCase _getProducts;
  final SearchProductsUseCase _searchProducts;

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());
    final result = await _getProducts(
      GetProductsParams(skip: event.skip, limit: event.limit),
    );
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) => emit(ProductLoaded(products)),
    );
  }

  Future<void> _onSearchProducts(
    SearchProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());
    final result = await _searchProducts(event.query);
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) => emit(ProductLoaded(products)),
    );
  }
}
