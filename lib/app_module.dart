import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/dio_client.dart';
import 'features/products/products_module.dart';

class AppModule extends Module {
  AppModule(this._prefs);

  final SharedPreferences _prefs;

  @override
  void binds(i) {
    // SharedPreferences ya instanciado en main() — instancia directa
    i.addInstance<SharedPreferences>(_prefs);
    // Dio y su wrapper como singletons
    i.addSingleton<Dio>(DioClient.createDio);
    i.addSingleton<DioClient>(() => DioClient(i.get<Dio>()));
  }

  @override
  void routes(r) {
    r.module('/', module: ProductModule());
  }
}
