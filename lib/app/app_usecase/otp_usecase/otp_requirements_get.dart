

import 'package:dartz/dartz.dart';
import 'package:happiness_club_merchant/services/error/failure.dart';
import 'package:happiness_club_merchant/services/usecases/usecase.dart';

import '../../../../services/repository/repository.dart';
import 'otp_requirements_save.dart';

/// This usecase will get otp required data from local storage
/// Output: [OtpRequirementsData] contains userId and phoneNumber
/// if unsuccessful the response will be [Failure]
class OtpRequirementsGet implements UseCase<OtpRequirementsData, NoParams>{
  final Repository _repository;

  OtpRequirementsGet(this._repository);

  @override
  Future<Either<Failure, OtpRequirementsData>> call(NoParams params) {
    return _repository.otpRequirementsGet();
  }
}
