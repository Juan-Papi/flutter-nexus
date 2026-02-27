import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_module.dart';
import 'app_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // SharedPreferences se inicializa antes de correr la app para garantizar
  // disponibilidad síncrona en todos los binds del módulo.
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ModularApp(
      module: AppModule(prefs),
      child: const AppWidget(),
    ),
  );
}
