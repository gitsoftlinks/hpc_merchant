
import 'package:happiness_club_merchant/services/error/failure.dart';
import 'package:happiness_club_merchant/services/repository/repository.dart';
import 'package:happiness_club_merchant/services/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

/// This method will send email, password and confirm password to server for password change
/// Input: [SendResetPasswordParams] contains email, password and confirm password
/// Output : [bool] returns true if operation is successful
/// if unsuccessful the response will be [Failure]
class SendResetPassword implements UseCase<bool, SendResetPasswordParams>{
  final Repository _repository;

  SendResetPassword(this._repository);

  @override
  Future<Either<Failure, bool>> call(SendResetPasswordParams params) {
    return _repository.sendResetPassword(params);
  }

}


class SendResetPasswordParams extends Equatable{
  final String email;
  final String password;
  final String confirmPassword;

  const SendResetPasswordParams({required this.email, required this.password, required this.confirmPassword});

  Map<String, dynamic> toJson() =>{
    'email': email,
    'password': password,
    'password_confirmation': confirmPassword
  };

  @override
  List<Object?> get props => [email, password, confirmPassword];

}