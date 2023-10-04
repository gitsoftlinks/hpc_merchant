import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:happiness_club_merchant/services/error/failure.dart';
import 'package:happiness_club_merchant/services/repository/repository.dart';
import 'package:happiness_club_merchant/services/usecases/usecase.dart';

/// This usecase will send password reset to server
/// Input: [ChangePasswordSendParams] contains userId, resetToken and new password
/// Output: [bool] return true if otp is send successfully to user's phoneNumber else false
/// if unsuccessful the response will be [Failure]
class ChangePasswordSend implements UseCase<bool, ChangePasswordSendParams>{
  final Repository _repository;

  ChangePasswordSend(this._repository);

  @override
  Future<Either<Failure, bool>> call(ChangePasswordSendParams params) {
    return _repository.changePasswordSend(params);
  }

}


class ChangePasswordSendParams extends Equatable{
  final String userId;
  final String resetToken;
  final String password;

  const ChangePasswordSendParams({required this.userId, required this.resetToken, required this.password});

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "resetToken": resetToken,
    "password": password
  };


  @override
  List<Object?> get props => [userId, resetToken, password];

}