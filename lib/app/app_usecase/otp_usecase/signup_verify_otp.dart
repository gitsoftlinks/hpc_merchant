import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:happiness_club_merchant/services/error/failure.dart';
import 'package:happiness_club_merchant/services/repository/repository.dart';
import 'package:happiness_club_merchant/services/usecases/usecase.dart';

/// This usecase will send password reset to server
/// Input: [SignupVerifyOtpSendParams] contains userId and token
/// Output: [bool] true if successful else false
/// if unsuccessful the response will be [Failure]
class SignupVerifyOtpSend implements UseCase<bool, SignupVerifyOtpSendParams>{
  final Repository _repository;

  SignupVerifyOtpSend(this._repository);

  @override
  Future<Either<Failure, bool>> call(SignupVerifyOtpSendParams params) {
    return _repository.signupVerifyOtpSend(params);
  }

}


class SignupVerifyOtpSendParams extends Equatable{
  final String userId;
  final String token;

  const SignupVerifyOtpSendParams({required this.userId, required this.token});

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "token": token
  };


  @override
  List<Object?> get props => [userId, token];

}