

import 'package:dartz/dartz.dart';
import 'package:happiness_club_merchant/services/error/failure.dart';
import 'package:happiness_club_merchant/services/repository/repository.dart';
import 'package:happiness_club_merchant/services/usecases/usecase.dart';

/// This usecase will remove accessToken from localStorage
/// Output: [bool] return true if successfully removed else false
/// if unsuccessful the response will be [Failure]
class AccessTokenDelete implements UseCase<bool, NoParams>{
  final Repository _repository;

  AccessTokenDelete(this._repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return _repository.deleteAccessToken();
  }

}