sealed class Failure {
  final String message;
  const Failure({required this.message});
}

final class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure({required super.message, this.statusCode});
}

final class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

final class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}
