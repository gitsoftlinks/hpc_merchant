


import 'package:happiness_club_merchant/services/error/failure.dart';
import 'package:happiness_club_merchant/services/repository/repository.dart';
import 'package:happiness_club_merchant/services/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

/// This method will send logout to server
/// Output : [bool] returns true if operation is successful
/// if unsuccessful the response will be [Failure]
class SendLogout implements UseCase<bool, NoParams>{
  final Repository _repository;

  SendLogout(this._repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return _repository.sendLogout();
  }

}
