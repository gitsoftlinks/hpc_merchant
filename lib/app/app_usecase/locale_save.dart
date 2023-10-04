

import 'package:dartz/dartz.dart';

import '../../services/error/failure.dart';
import '../../services/repository/repository.dart';
import '../../services/usecases/usecase.dart';
// import 'app_config_get.dart';

/// This method will save locale to local storage
/// Input: [Map<String, dynamic>] contains the locale key and value
/// Output: [bool] if successful return true else false
/// if unsuccessful the response will be [Failure]
class LocaleSave implements UseCase<bool, JsonProps> {
  final Repository _repository;

  LocaleSave(this._repository);

  @override
  Future<Either<Failure, bool>> call(JsonProps params) {
    return _repository.saveLocale(params);
  }
}

class JsonProps {
}
