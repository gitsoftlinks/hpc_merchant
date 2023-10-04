import 'dart:io';

import 'package:happiness_club_merchant/services/error/failure.dart';
import 'package:happiness_club_merchant/services/usecases/usecase.dart';
import 'package:happiness_club_merchant/utils/extensions/extensions.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../../../../../services/repository/repository.dart';

/// This method will update user info
/// Input: [UpdatePersonalInfoParams] contains accessToken and personal info
/// Output : [bool] return true if response is successful
/// if unsuccessful the response will be [Failure]
class UpdatePersonalInfo implements UseCase<bool, UpdatePersonalInfoParams> {
  final Repository _repository;

  UpdatePersonalInfo(this._repository);

  @override
  Future<Either<Failure, bool>> call(UpdatePersonalInfoParams params) {
    return _repository.updatePersonalInfo(params);
  }
}

class UpdatePersonalInfoParams extends Equatable {
  final String accessToken;
  final String fullName;
  final String contactNumber;
  final String email;
  final File? profileImage;

  const UpdatePersonalInfoParams(
      {required this.contactNumber,
      required this.email,
      required this.accessToken,
      required this.fullName,
      required this.profileImage});

  factory UpdatePersonalInfoParams.withAccessToken(
          {required String accessToken,
          required UpdatePersonalInfoParams params}) =>
      UpdatePersonalInfoParams(
          contactNumber: params.contactNumber,
          email: params.email,
          accessToken: accessToken,
          fullName: params.fullName,
          profileImage: params.profileImage);

  @override
  List<Object?> get props => [fullName, contactNumber, email, profileImage];

  Map<String, dynamic> toJson() => {
        'full_name': fullName,
        'phone_number': contactNumber,
        'email': email,
        'profile_image': profileImage == null ? null : profileImage!.getFile(),
      };
}
