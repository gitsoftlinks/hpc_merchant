

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:happiness_club_merchant/services/error/failure.dart';
import 'package:happiness_club_merchant/services/usecases/usecase.dart';

import '../../../../../services/repository/repository.dart';

/// This usecase will save otp required data in local storage
/// Input: [OtpRequirementsData] contains userId and phoneNumber
/// Output: [bool] will return true on success
/// if unsuccessful the response will be [Failure]
class OtpRequirementsSave implements UseCase<bool, OtpRequirementsData>{
  final Repository _repository;

  OtpRequirementsSave(this._repository);

  @override
  Future<Either<Failure, bool>> call(OtpRequirementsData params) {
    return _repository.otpRequirementsSave(params);
  }
}

class OtpRequirementsData extends Equatable{
  final String userId;
  final String phoneNumber;

  const OtpRequirementsData({required this.userId, required this.phoneNumber});


  factory OtpRequirementsData.fromJson(Map<String, dynamic> json) {
    return OtpRequirementsData(userId: json['userId'], phoneNumber: json['phoneNumber']);
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'phoneNumber': phoneNumber,
  };


  @override
  List<Object?> get props => [userId, phoneNumber];

}