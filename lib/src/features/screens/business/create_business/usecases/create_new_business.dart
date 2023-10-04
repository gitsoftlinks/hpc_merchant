import 'dart:io';
import 'package:happiness_club_merchant/services/error/failure.dart';
import 'package:happiness_club_merchant/services/repository/repository.dart';
import 'package:happiness_club_merchant/services/usecases/usecase.dart';
import 'package:happiness_club_merchant/utils/extensions/extensions.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

/// This method will create new business
/// Input: [CreateNewBusinessParams] contains accessToken and new business params
/// Output : [bool] returns true if operation is successful
/// if unsuccessful the response will be [Failure]
class CreateNewBusiness implements UseCase<bool, CreateNewBusinessParams> {
  final Repository _repository;

  CreateNewBusiness(this._repository);

  @override
  Future<Either<Failure, bool>> call(CreateNewBusinessParams params) {
    return _repository.createNewBusiness(params);
  }

  Future updateBusiness(UpdateBusiness params) {
    return _repository.updateBusiness(params);
  }

  Future updateBusinessCover(UpdateNewBusinessCoverParams params) {
    return _repository.updateBusinessCover(params);
  }
}

class CreateNewBusinessParams extends Equatable {
  final String accessToken;
  final String businessDisplayName;
  final int businessCategory;
  final Object? businessLocation;
  final List<Object> businessBranches;
  final File logoImage;
  final File tradeLicense;
  final String businessLegalName;
  final String businessDescription;
  final String trn;
  final String licenseNumber;
  final String licenseExpiryDate;

  const CreateNewBusinessParams(
      {required this.businessDisplayName,
      required this.businessBranches,
      required this.accessToken,
      required this.businessCategory,
      required this.businessLocation,
      required this.logoImage,
      required this.tradeLicense,
      required this.businessLegalName,
      required this.businessDescription,
      required this.licenseNumber,
      required this.licenseExpiryDate,
      required this.trn});

  factory CreateNewBusinessParams.withAccessToken(
          {required String accessToken,
          required CreateNewBusinessParams params}) =>
      CreateNewBusinessParams(
        trn: params.trn,
        licenseNumber: params.licenseNumber,
        licenseExpiryDate: params.licenseExpiryDate,
        businessDisplayName: params.businessDisplayName,
        accessToken: accessToken,
        businessBranches: params.businessBranches,
        businessCategory: params.businessCategory,
        businessLocation: params.businessLocation,
        logoImage: params.logoImage,
        tradeLicense: params.tradeLicense,
        businessLegalName: params.businessLegalName,
        businessDescription: params.businessDescription,
      );

  Map<String, dynamic> toJson() => {
        'business_display_name': businessDisplayName,
        'business_category': businessCategory,
        'business_logo': logoImage.getFile(),
        'trade_license': tradeLicense.getFile(),
        'business_legal_name': businessLegalName,
        'business_description': businessDescription,
        'business_location': businessLocation,
        'business_branches_location[]': businessBranches,
        'trn': trn,
        'trade_license_number': licenseNumber,
        'trade_expiry_date': DateTime.tryParse(licenseExpiryDate)
      };

  @override
  List<Object?> get props => [
        businessDisplayName,
        businessCategory,
        logoImage,
        tradeLicense,
        businessLegalName,
        businessLegalName,
        businessDescription,
        businessLocation,
        businessBranches,
        trn,
        licenseNumber,
        licenseExpiryDate
      ];
}

class UpdateBusiness extends Equatable {
  final String accessToken;
  final String businessDisplayName;
  final int businessCategory;
  final Object? businessLocation;
  final List<Object> businessBranches;
  final File? logoImage;
  final int id;
  final File? tradeLicense;
  final String businessLegalName;
  final String businessDescription;
  final String trn;
  final String licenseNumber;
  final String licenseExpiryDate;

  UpdateBusiness({
    required this.businessDisplayName,
    required this.id,
    required this.businessBranches,
    required this.accessToken,
    required this.businessCategory,
    required this.businessLocation,
    required this.logoImage,
    required this.tradeLicense,
    required this.businessLegalName,
    required this.businessDescription,
    required this.licenseNumber,
    required this.licenseExpiryDate,
    required this.trn
  });

  factory UpdateBusiness.withAccessToken(
          {required String accessToken, required UpdateBusiness params}) =>
      UpdateBusiness(
          trn: params.trn,
          licenseNumber: params.licenseNumber,
          licenseExpiryDate: params.licenseExpiryDate,
          id: params.id,
          businessDisplayName: params.businessDisplayName,
          accessToken: accessToken,
          businessBranches: params.businessBranches,
          businessCategory: params.businessCategory,
          businessLocation: params.businessLocation,
          logoImage: params.logoImage,
          tradeLicense: params.tradeLicense,
          businessLegalName: params.businessLegalName,
          businessDescription: params.businessDescription);

  Map<String, dynamic> toJson() => {
        'id': id,
        'business_display_name': businessDisplayName,
        'business_category': businessCategory,
        'business_logo': logoImage == null ? null : logoImage!.getFile(),
        'trade_license': tradeLicense == null ? null : tradeLicense!.getFile(),
        'business_legal_name': businessLegalName,
        'business_description': businessDescription,
        'business_location': businessLocation,
        'business_branches_location[]': businessBranches,
    'trn': trn,
    'trade_license_number': licenseNumber,
    'trade_expiry_date': DateTime.tryParse(licenseExpiryDate)
      };

  @override
  List<Object?> get props => [
        id,
        businessDisplayName,
        businessCategory,
        logoImage,
        tradeLicense,
        businessLegalName,
        businessLegalName,
        businessDescription,
        businessLocation,
        businessBranches,
    trn,
    licenseNumber,
    licenseExpiryDate
      ];
}

class UpdateNewBusinessCoverParams extends Equatable {
  final String accessToken;
  final File businessCover;
  final int businessId;

  const UpdateNewBusinessCoverParams({
    required this.businessId,
    required this.businessCover,
    required this.accessToken,
  });

  factory UpdateNewBusinessCoverParams.withAccessToken(
          {required String accessToken,
          required UpdateNewBusinessCoverParams params}) =>
      UpdateNewBusinessCoverParams(
        businessCover: params.businessCover,
        accessToken: accessToken,
        businessId: params.businessId,
      );

  Map<String, dynamic> toJson() => {
        'business_cover_picture': businessCover.getFile(),
        'business_id': businessId,
      };

  @override
  List<Object?> get props => [
        businessId,
      ];
}
