
import 'package:happiness_club_merchant/services/error/failure.dart';
import 'package:happiness_club_merchant/services/repository/repository.dart';
import 'package:happiness_club_merchant/services/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

/// This method will send otp and email to server for verification
/// Input: [SendForgetPasswordVerifyOtpParams] contains email, otp and password
/// Output : [bool] returns true if operation is successful
/// if unsuccessful the response will be [Failure]
class SendForgetPasswordVerifyOtp implements UseCase<bool, SendForgetPasswordVerifyOtpParams>{
  final Repository _repository;

  SendForgetPasswordVerifyOtp(this._repository);

  @override
  Future<Either<Failure, bool>> call(SendForgetPasswordVerifyOtpParams params) {
    return _repository.sendForgetPasswordVerifyOtp(params);
  }

}


class SendForgetPasswordVerifyOtpParams extends Equatable{
  final String email;
  final String code;

  const SendForgetPasswordVerifyOtpParams({required this.email, required this.code});

  Map<String, dynamic> toJson() =>{
    'email': email,
    'code': code
  };

  @override
  List<Object?> get props => [email, code];

}