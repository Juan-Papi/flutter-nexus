import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nexus/core/usecases/usecase.dart';
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

  /// 1. Obtiene el detalle del producto (que internamente guarda en caché).
  /// 2. Con el caché ya actualizado, carga el historial de recientes.
  /// 3. Emite un único [ProductDetailLoaded] con ambos datos.
  Future<void> _onLoadProductDetail(
    LoadProductDetail event,
    Emitter<ProductDetailState> emit,
  ) async {
    emit(const ProductDetailLoading());

    final detailResult = await _getProductDetail(event.id);

    await detailResult.fold(
      (failure) async => emit(ProductDetailError(failure.message)),
      (product) async {
        final recentsResult = await _getRecentProducts(const NoParams());
        recentsResult.fold(
          (_) => emit(ProductDetailLoaded(product: product)),
          (recent) => emit(
            ProductDetailLoaded(product: product, recentProducts: recent),
          ),
        );
      },
    );
  }
}
