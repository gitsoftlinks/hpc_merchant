import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:happiness_club_merchant/services/error/failure.dart';
import 'package:happiness_club_merchant/services/repository/repository.dart';
import 'package:happiness_club_merchant/services/usecases/usecase.dart';

/// This usecase will send password reset to server
/// Input: [PasswordResetVerifyOtpSendParams] contains user's phone number, region and token
/// Output: [PasswordResetVerifyOtpSendResponse] contains userId and resetToken
/// if unsuccessful the response will be [Failure]
class PasswordResetVerifyOtpSend implements UseCase<PasswordResetVerifyOtpSendResponse, PasswordResetVerifyOtpSendParams>{
  final Repository _repository;

  PasswordResetVerifyOtpSend(this._repository);

  @override
  Future<Either<Failure, PasswordResetVerifyOtpSendResponse>> call(PasswordResetVerifyOtpSendParams params) {
    return _repository.passwordResetVerifyOtpSend(params);
  }

}


class PasswordResetVerifyOtpSendParams extends Equatable{
  final String phoneNumber;
  final String region;
  final String token;

  const PasswordResetVerifyOtpSendParams({required this.phoneNumber, required this.region, required this.token});

  Map<String, dynamic> toJson() => {
    "phoneNumber": phoneNumber,
    "region": region,
    "token": token
  };


  @override
  List<Object?> get props => [phoneNumber, region, token];

}


class PasswordResetVerifyOtpSendResponse extends Equatable{
  final String userId;
  final String resetToken;

  const PasswordResetVerifyOtpSendResponse({required this.userId, required this.resetToken});

  factory PasswordResetVerifyOtpSendResponse.empty(){
    return const PasswordResetVerifyOtpSendResponse(userId: '', resetToken: '');
  }

  factory PasswordResetVerifyOtpSendResponse.fromJson(Map<String, dynamic> json){
    return PasswordResetVerifyOtpSendResponse(userId: json['userId'], resetToken: json['resetToken']);
  }

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "resetToken": resetToken
  };

  @override
  List<Object?> get props => [userId, resetToken];
}