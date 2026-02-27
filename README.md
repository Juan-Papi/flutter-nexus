# Prueba Técnica - Flutter Mobile Developer

## 🛠 Arquitectura y Tecnologías
- **Arquitectura:** Clean Architecture (Domain, Data, Presentation).
- **Gestión de Estado:** BLoC (flutter_bloc).
- **Inyección de Dependencias y Rutas:** flutter_modular.
- **Cliente HTTP:** Dio.
- **Persistencia:** SharedPreferences (últimos 5 productos visitados).
- **Programación Funcional:** fpdart (uso de Either para manejo de errores).

## 📋 Reglas de Desarrollo (Obligatorio)
1. **Manejo de Errores:** No usar try-catch en los BLoCs. El manejo de errores debe hacerse mediante `Either<Failure, T>`.
2. **Typedefs:** Implementar en `core/utils/typedefs.dart`:
   - `typedef ResultFuture<T> = Future<Either<Failure, T>>;`
   - `typedef ResultVoid = ResultFuture<void>;`
3. **Modelos:** Los modelos en la capa de Data deben extender de las Entidades de la capa de Dominio.
4. **Persistencia Local:** Solo se deben persistir los últimos 5 productos vistos. Si se ve un sexto, eliminar el más antiguo.

## 🚀 Tareas
1. Configurar la estructura de carpetas de Clean Architecture.
2. Implementar el Feature de Productos (Lista, Búsqueda, Detalle).
3. Configurar DummyJSON API como fuente de datos.
4. Implementar la lógica de historial local.