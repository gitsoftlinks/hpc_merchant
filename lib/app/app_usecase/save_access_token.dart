

import 'package:dartz/dartz.dart';

import '../../services/error/failure.dart';
import '../../services/repository/repository.dart';
import '../../services/usecases/usecase.dart';

/// This method will save accessToken to local storage
/// Input: [String] contains the login token
/// Output: [bool] if successful return true else false
/// if unsuccessful the response will be [Failure]
class SaveAccessToken implements UseCase<bool, String> {
  final Repository _repository;

  SaveAccessToken(this._repository);

  @override
  Future<Either<Failure, bool>> call(String params) {
    return _repository.saveAccessToken(params);
  }
}
