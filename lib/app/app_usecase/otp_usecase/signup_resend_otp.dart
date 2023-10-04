import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:happiness_club_merchant/services/error/failure.dart';
import 'package:happiness_club_merchant/services/repository/repository.dart';
import 'package:happiness_club_merchant/services/usecases/usecase.dart';

/// This usecase will send password reset to server
/// Input: [SignupResendOtpSendParams] contains userId and phoneNumber
/// Output: [bool] true if successful else false
/// if unsuccessful the response will be [Failure]
class SignupResendOtpSend implements UseCase<bool, SignupResendOtpSendParams>{
  final Repository _repository;

  SignupResendOtpSend(this._repository);

  @override
  Future<Either<Failure, bool>> call(SignupResendOtpSendParams params) {
    return _repository.signupResendOtpSend(params);
  }

}


class SignupResendOtpSendParams extends Equatable{
  final String userId;
  final String phoneNumber;

  const SignupResendOtpSendParams({required this.userId, required this.phoneNumber});

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "phoneNumber": phoneNumber
  };


  @override
  List<Object?> get props => [userId, phoneNumber];

}