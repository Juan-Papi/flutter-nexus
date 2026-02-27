import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_nexus/core/network/dio_client.dart';

import 'data/datasources/product_local_data_source.dart';
import 'data/datasources/product_remote_data_source.dart';
import 'data/repositories/product_repository_impl.dart';
import 'domain/repositories/product_repository.dart';
import 'domain/usecases/get_product_detail_usecase.dart';
import 'domain/usecases/get_products_usecase.dart';
import 'domain/usecases/get_recent_products_usecase.dart';
import 'domain/usecases/search_products_usecase.dart';
import 'presentation/bloc/product_bloc.dart';
import 'presentation/bloc/product_detail_bloc.dart';
import 'presentation/pages/detail_page.dart';
import 'presentation/pages/home_page.dart';

class ProductModule extends Module {
  static const home = '/';
  static const detail = '/detail';
  @override
  void binds(i) {
    // ── Data sources ────────────────────────────────────────────────────
    // DioClient y SharedPreferences viven en AppModule → Modular.get accede
    // al contenedor global que incluye todos los módulos activos.
    i.addSingleton<ProductRemoteDataSource>(
      () => ProductRemoteDataSourceImpl(Modular.get<DioClient>()),
    );
    i.addSingleton<ProductLocalDataSource>(
      () => ProductLocalDataSourceImpl(Modular.get<SharedPreferences>()),
    );

    // ── Repository ───────────────────────────────────────────────────────
    i.addSingleton<ProductRepository>(
      () => ProductRepositoryImpl(
        remoteDataSource: i.get<ProductRemoteDataSource>(),
        localDataSource: i.get<ProductLocalDataSource>(),
      ),
    );

    // ── Use cases ────────────────────────────────────────────────────────
    i.addSingleton<GetProductsUseCase>(
      () => GetProductsUseCase(i.get<ProductRepository>()),
    );
    i.addSingleton<SearchProductsUseCase>(
      () => SearchProductsUseCase(i.get<ProductRepository>()),
    );
    i.addSingleton<GetProductDetailUseCase>(
      () => GetProductDetailUseCase(i.get<ProductRepository>()),
    );
    i.addSingleton<GetRecentProductsUseCase>(
      () => GetRecentProductsUseCase(i.get<ProductRepository>()),
    );

    // ── BLoCs (factory → instancia nueva por página) ─────────────────────
    i.add<ProductBloc>(
      () => ProductBloc(
        getProductsUseCase: i.get<GetProductsUseCase>(),
        searchProductsUseCase: i.get<SearchProductsUseCase>(),
      ),
    );
    i.add<ProductDetailBloc>(
      () => ProductDetailBloc(
        getProductDetailUseCase: i.get<GetProductDetailUseCase>(),
        getRecentProductsUseCase: i.get<GetRecentProductsUseCase>(),
      ),
    );
  }

  @override
  void routes(r) {
    r.child(home, child: (context) => const HomePage());
    r.child(
      detail,
      child: (context) => DetailPage(productId: Modular.args.data as int),
    );
  }
}
