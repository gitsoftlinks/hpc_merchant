
import 'package:happiness_club_merchant/services/error/failure.dart';
import 'package:happiness_club_merchant/services/repository/repository.dart';
import 'package:happiness_club_merchant/services/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

/// This method will send otp to an email on forget password
/// Input: [String] contains email address
/// Output : [bool] returns true if operation is successful
/// if unsuccessful the response will be [Failure]
class SendForgetPasswordOtp implements UseCase<bool, String>{
  final Repository _repository;

  SendForgetPasswordOtp(this._repository);

  @override
  Future<Either<Failure, bool>> call(String params) {
    return _repository.sendForgetPasswordOtp(params);
  }

}
