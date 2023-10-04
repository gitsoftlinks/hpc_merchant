

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:happiness_club_merchant/services/error/failure.dart';
import 'package:happiness_club_merchant/services/repository/repository.dart';
import 'package:happiness_club_merchant/services/usecases/usecase.dart';

/// This usecase will send password reset to server
/// Input: [PasswordResetSendParams] contains user's phone number and region
/// Output: [bool] return true if otp is send successfully to user's phoneNumber else false
/// if unsuccessful the response will be [Failure]
class PasswordResetSend implements UseCase<bool, PasswordResetSendParams>{
  final Repository _repository;

  PasswordResetSend(this._repository);

  @override
  Future<Either<Failure, bool>> call(PasswordResetSendParams params) {
    return _repository.passwordResetSend(params);
  }

}


class PasswordResetSendParams extends Equatable{
  final String phoneNumber;
  final String region;

  const PasswordResetSendParams({required this.phoneNumber, required this.region});

  Map<String, dynamic> toJson() => {
    "phoneNumber": phoneNumber,
    "region": region
  };


  @override
  List<Object?> get props => [phoneNumber, region];

}