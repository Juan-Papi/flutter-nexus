import '../utils/typedefs.dart';

abstract interface class UseCase<T, Params> {
  ResultFuture<T> call(Params params);
}

class NoParams {
  const NoParams();
}
