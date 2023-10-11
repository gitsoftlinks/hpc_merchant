// ignore_for_file: must_be_immutable

import 'package:happiness_club_merchant/services/error/failure.dart';
import 'package:happiness_club_merchant/services/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../../services/repository/repository.dart';

/// This method will get businesses detail by business id from server
/// Input: [GetBusinessDetailParams] contains accessToken and businessId
/// Output : [GetBusinessDetailResponse] contains Business response
/// if unsuccessful the response will be [Failure]
class GetBusinessDetail
    implements UseCase<GetBusinessDetailResponse, GetBusinessDetailParams> {
  final Repository _repository;

  GetBusinessDetail(this._repository);

  @override
  Future<Either<Failure, GetBusinessDetailResponse>> call(
      GetBusinessDetailParams params) {
    return _repository.getBusinessDetail(params);
  }
}

class GetBusinessDetailParams extends Equatable {
  final String accessToken;
  final int businessId;

  const GetBusinessDetailParams(
      {required this.accessToken, required this.businessId});

  factory GetBusinessDetailParams.withAccessToken(
          {required String accessToken,
          required GetBusinessDetailParams params}) =>
      GetBusinessDetailParams(
          accessToken: accessToken, businessId: params.businessId);

  @override
  List<Object?> get props => [businessId];
}

class GetBusinessDetailResponse {
  GetBusinessDetailResponse({
    required this.businessData,
  });

  final BusinessDetail businessData;

  factory GetBusinessDetailResponse.fromJson(Map<String, dynamic> json) =>
      GetBusinessDetailResponse(
        businessData: BusinessDetail.fromJson(json["business"]),
      );

  Map<String, dynamic> toJson() => {
        "business": businessData.toJson(),
      };
}

class BusinessDetail extends Equatable {
  int id;
  int userId;
  String businessDisplayName;
  String businessLegalName;
  String businessDescription;
  String businessCity;
  String businessLat;
  String businessLng;
  String branchName;
  int businessCategory;
  String businessLogo;
  String businessLogoPath;
  String tradeLicense;
  String tradeLicensePath;
  String businessStatus;
  String licenseNumber;
  String trn;
  DateTime licenseExpiryDate;
  int isActive;
  DateTime createdAt;
  DateTime updatedAt;
  Categories categories;
  List<BusinessBranch> businessBranches;

  BusinessDetail(
      {required this.id,
      required this.userId,
      required this.trn,
      required this.licenseNumber,
      required this.licenseExpiryDate,
      required this.branchName,
      required this.businessDisplayName,
      required this.businessLegalName,
      required this.businessDescription,
      required this.businessCity,
      required this.businessLat,
      required this.businessLng,
      required this.businessCategory,
      required this.businessLogo,
      required this.businessLogoPath,
      required this.tradeLicense,
      required this.tradeLicensePath,
      required this.businessStatus,
      required this.isActive,
      required this.createdAt,
      required this.updatedAt,
      required this.categories,
      required this.businessBranches});

  factory BusinessDetail.empty() => BusinessDetail(
      id: 0,
      businessLogo: '',
      branchName: '',
      businessDisplayName: '',
      businessDescription: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      trn: '',
      licenseNumber: '',
      licenseExpiryDate: DateTime.now(),
      businessLegalName: '',
      userId: 0,
      businessCity: '',
      businessLat: '',
      businessLng: '',
      businessCategory: 0,
      isActive: 0,
      businessStatus: '',
      businessLogoPath: '',
      tradeLicense: '',
      tradeLicensePath: '',
      categories: Categories.fromJson({}),
      businessBranches: List<BusinessBranch>.empty());
  factory BusinessDetail.fromJson(Map<String, dynamic> json) => BusinessDetail(
        id: json["id"],
        userId: json["user_id"],
        businessDisplayName: json["business_display_name"],
        businessLegalName: json["business_legal_name"],
        businessDescription: json["business_description"],
        businessCity: json["business_city"] ?? '',
        businessLat: json["business_lat"] ?? '',
        businessLng: json["business_lng"] ?? '',
        branchName: json["branch_name"] ?? '',
        businessCategory: json["business_category"],
        businessLogo: json["business_logo"],
        businessLogoPath: json["business_logo_path"],
        tradeLicense: json["trade_license"],
        tradeLicensePath: json["trade_license_path"],
        businessStatus: json["business_status"],
        isActive: json["is_active"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        categories: Categories.fromJson(json["categories"]),
        trn: json["trn"] ?? '',
        licenseNumber: json['trade_license_number'] ?? '',
        licenseExpiryDate: DateTime.parse(json["trade_expiry_date"] ?? ''),
        businessBranches: List<BusinessBranch>.from(
            json["business_branches"].map((x) => BusinessBranch.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "business_display_name": businessDisplayName,
        "business_legal_name": businessLegalName,
        "business_description": businessDescription,
        "business_city": businessCity,
        "business_lat": businessLat,
        "business_lng": businessLng,
        "business_category": businessCategory,
        "business_logo": businessLogo,
        "business_logo_path": businessLogoPath,
        "trade_license": tradeLicense,
        "trade_license_path": tradeLicensePath,
        "business_status": businessStatus,
        "branch_name": branchName,
        "is_active": isActive,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "categories": categories.toJson(),
        "trade_expiry_date": licenseExpiryDate.toIso8601String(),
        "trn": trn,
        " trade_license_number": licenseNumber,
        "business_branches":
            List<dynamic>.from(businessBranches.map((x) => x.toJson())),
      };

  @override
  List<Object?> get props => [
        id,
        businessDisplayName,
        businessLegalName,
        businessDescription,
        businessCity,
        businessCategory,
        businessLogo,
        businessLogoPath,
        branchName,
        tradeLicense,
        tradeLicensePath,
        isActive,
        businessBranches,
        businessLat,
        businessLng,
        trn,
        licenseNumber,
        licenseExpiryDate
      ];
  BusinessDetail copyWith(
      {int? id,
      int? userId,
      String? businessDisplayName,
      String? businessLegalName,
      String? businessDescription,
      String? businessCity,
      String? businessLat,
      String? businessLng,
      String? trn,
      String? licenseNumber,
      DateTime? licenseExpiryDate,
      int? businessCategory,
      String? businessLogo,
      String? businessLogoPath,
      String? tradeLicense,
      String? tradeLicensePath,
      String? businessStatus,
      int? isActive,
      String? branchName,
      DateTime? createdAt,
      DateTime? updatedAt,
      Categories? categories,
      List<BusinessBranch>? businessBranches}) {
    return BusinessDetail(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        branchName: branchName ?? this.branchName,
        businessDisplayName: businessDisplayName ?? this.businessDisplayName,
        businessLegalName: businessLegalName ?? this.businessLegalName,
        businessDescription: businessDescription ?? this.businessDescription,
        businessCity: businessCity ?? this.businessCity,
        businessLat: businessLat ?? this.businessLat,
        businessLng: businessLng ?? this.businessLng,
        businessCategory: businessCategory ?? this.businessCategory,
        businessLogo: businessLogo ?? this.businessLogo,
        businessLogoPath: businessLogoPath ?? this.businessLogoPath,
        tradeLicense: tradeLicense ?? this.tradeLicense,
        tradeLicensePath: tradeLicensePath ?? this.tradeLicensePath,
        businessStatus: businessStatus ?? this.businessStatus,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        categories: categories ?? this.categories,
        trn: trn ?? this.trn,
        licenseExpiryDate: licenseExpiryDate ?? this.licenseExpiryDate,
        licenseNumber: licenseNumber ?? this.licenseNumber,
        businessBranches: businessBranches ?? this.businessBranches);
  }
}

class BusinessBranch {
  int id;
  int businessId;
  String lat;
  String lng;
  String cityName;
  String branchName;
  DateTime createdAt;
  DateTime updatedAt;

  BusinessBranch({
    required this.id,
    required this.businessId,
    required this.lat,
    required this.lng,
    required this.branchName,
    required this.cityName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BusinessBranch.fromJson(Map<String, dynamic> json) => BusinessBranch(
        id: json["id"] ?? 0,
        businessId: json["business_id"] ?? 0,
        lat: json["lat"] ?? '',
        lng: json["lng"] ?? '',
        cityName: json["city_name"] ?? '',
        branchName: json["branch_name"] ?? '',
        createdAt: DateTime.parse(json["created_at"] ?? ''),
        updatedAt: DateTime.parse(json["updated_at"] ?? ''),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "business_id": businessId,
        "lat": lat,
        "lng": lng,
        "branch_name": branchName,
        "city_name": cityName,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Categories {
  int id;
  String categoryName;

  Categories({
    required this.id,
    required this.categoryName,
  });

  factory Categories.fromJson(Map<String, dynamic> json) => Categories(
        id: json["id"] ?? 0,
        categoryName: json["category_name"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_name": categoryName,
      };
}
