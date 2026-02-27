import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nexus/core/usecases/usecase.dart';
import 'package:flutter_nexus/features/products/domain/entities/product.dart';
import 'package:flutter_nexus/features/products/domain/usecases/get_product_detail_usecase.dart';
import 'package:flutter_nexus/features/products/domain/usecases/get_recent_products_usecase.dart';

import 'product_detail_event.dart';
import 'product_detail_state.dart';

class ProductDetailBloc
    extends Bloc<ProductDetailEvent, ProductDetailState> {
  ProductDetailBloc({
    required GetProductDetailUseCase getProductDetailUseCase,
    required GetRecentProductsUseCase getRecentProductsUseCase,
  })  : _getProductDetail = getProductDetailUseCase,
        _getRecentProducts = getRecentProductsUseCase,
        super(const ProductDetailInitial()) {
    on<LoadProductDetail>(_onLoadProductDetail);
  }

  final GetProductDetailUseCase _getProductDetail;
  final GetRecentProductsUseCase _getRecentProducts;

  /// 1. Obtiene el detalle del producto (internamente guarda en caché si hay red).
  /// 2. Siempre carga el historial de recientes desde el caché local.
  /// 3a. Si el detalle tuvo éxito → emite [ProductDetailLoaded] con ambos.
  /// 3b. Si el detalle falló (ej. sin red) → emite [ProductDetailError] con
  ///     el mensaje de error Y los recientes disponibles en caché.
  Future<void> _onLoadProductDetail(
    LoadProductDetail event,
    Emitter<ProductDetailState> emit,
  ) async {
    emit(const ProductDetailLoading());

    final detailResult = await _getProductDetail(event.id);
    // Los recientes se leen del LocalDataSource: no dependen de la red.
    final recentsResult = await _getRecentProducts(const NoParams());
    final recent = recentsResult.fold((_) => <Product>[], (r) => r);

    detailResult.fold(
      (failure) => emit(
        ProductDetailError(failure.message, recentProducts: recent),
      ),
      (product) => emit(
        ProductDetailLoaded(product: product, recentProducts: recent),
      ),
    );
  }
}
