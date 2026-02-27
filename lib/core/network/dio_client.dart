import 'package:dio/dio.dart';

class DioClient {
  DioClient(this._dio);

  final Dio _dio;

  static Dio createDio() => Dio(
        BaseOptions(
          baseUrl: 'https://dummyjson.com',
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: const {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) =>
      _dio.get<T>(path, queryParameters: queryParameters);
}
