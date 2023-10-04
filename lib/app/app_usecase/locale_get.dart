

import 'package:dartz/dartz.dart';

import '../../services/error/failure.dart';
import '../../services/repository/repository.dart';
import '../../services/usecases/usecase.dart';

/// This method get locale from local storage
/// Input: [String] the name of locale to get e.g en or ar
/// Output: [Map<String, dynamic>] contains the locale key and value
/// if unsuccessful the response will be [Failure]
class LocaleGet implements UseCase<Map<String, dynamic>, String> {
  final Repository _repository;

  LocaleGet(this._repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(String params) {
    return _repository.getLocale(params);
  }
}
