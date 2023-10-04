

import 'package:dartz/dartz.dart';

import '../../services/error/failure.dart';
import '../../services/repository/repository.dart';
import '../../services/usecases/usecase.dart';

/// This method will get accessToken from local storage
/// Output: [String] contains the login token
/// if unsuccessful the response will be [Failure]
class GetSavedAccessToken implements UseCase<String, NoParams> {
  final Repository _repository;

  GetSavedAccessToken(this._repository);

  @override
  Future<Either<Failure, String>> call(NoParams params) {
    return _repository.getSavedAccessToken();
  }
}
