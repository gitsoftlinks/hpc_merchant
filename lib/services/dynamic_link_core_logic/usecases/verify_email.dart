import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../error/failure.dart';
import '../../repository/repository.dart';
import '../../usecases/usecase.dart';

/// This use case verify user email token
class VerifyEmail implements UseCase<bool, VerifyEmailParams> {
  Repository repository;

  VerifyEmail(this.repository);

  @override
  Future<Either<Failure, bool>> call(VerifyEmailParams params) {
    return repository.verifyEmail(params);
  }
}

class VerifyEmailParams extends Equatable {
  final String verificationCode;
  final String udid;

  const VerifyEmailParams(this.verificationCode, this.udid);

  @override
  List<Object?> get props => [verificationCode, udid];
}
