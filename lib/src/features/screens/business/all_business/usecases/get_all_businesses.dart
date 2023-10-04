// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:happiness_club_merchant/services/error/failure.dart';
import 'package:happiness_club_merchant/services/usecases/usecase.dart';

import '../../../../../../services/repository/repository.dart';
import '../../../signin_screen/usecases/send_login.dart';

/// This method will get all businesses of the user
/// Input: [NoParams] contains accessToken later on
/// Output : [GetAllBusinessesResponse] contains Business response
/// if unsuccessful the response will be [Failure]
class GetAllBusinesses implements UseCase<GetAllBusinessesResponse, NoParams> {
  final Repository _repository;

  GetAllBusinesses(this._repository);

  @override
  Future<Either<Failure, GetAllBusinessesResponse>> call(NoParams params) {
    return _repository.getAllBusinesses(params);
  }
}

class GetAllBusinessesResponse {
  GetAllBusinessesResponse({
    required this.business,
  });

  List<Business> business;

  factory GetAllBusinessesResponse.fromJson(Map<String, dynamic> json) =>
      GetAllBusinessesResponse(
        business: List<Business>.from(
            json["business"].map((x) => Business.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "business": List<dynamic>.from(business.map((x) => x.toJson())),
      };
}

class Business extends Equatable {
     int id;
    int userId;
    String businessDisplayName;
    String businessLegalName;
    String businessDescription;
    String businessCity;
    String businessLat;
    String businessLng;
    int businessCategory;
    String businessLogo;
    String businessLogoPath;
    String? businessCoverPicture;
    String? businessCoverPath;
    String tradeLicense;
    String tradeLicensePath;
    String businessStatus;
    int isActive;
    DateTime createdAt;
    DateTime updatedAt;

  Business(
      { required this.id,
        required this.userId,
        required this.businessDisplayName,
        required this.businessLegalName,
        required this.businessDescription,
        required this.businessCity,
        required this.businessLat,
        required this.businessLng,
        required this.businessCategory,
        required this.businessLogo,
        required this.businessLogoPath,
        required this.businessCoverPicture,
        required this.businessCoverPath,
        required this.tradeLicense,
        required this.tradeLicensePath,
        required this.businessStatus,
        required this.isActive,
        required this.createdAt,
        required this.updatedAt,});

  factory Business.fromJson(Map<String, dynamic> json) => Business(
       id: json["id"],
        userId: json["user_id"],
        businessDisplayName: json["business_display_name"],
        businessLegalName: json["business_legal_name"],
        businessDescription: json["business_description"],
        businessCity: json["business_city"],
        businessLat: json["business_lat"],
        businessLng: json["business_lng"],
        businessCategory: json["business_category"],
        businessLogo: json["business_logo"],
        businessLogoPath: json["business_logo_path"],
        businessCoverPicture: json["business_cover_picture"],
        businessCoverPath: json["business_cover_path"],
        tradeLicense: json["trade_license"],
        tradeLicensePath: json["trade_license_path"],
        businessStatus: json["business_status"],
        isActive: json["is_active"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
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
        "business_cover_picture": businessCoverPicture,
        "business_cover_path": businessCoverPath,
        "trade_license": tradeLicense,
        "trade_license_path": tradeLicensePath,
        "business_status": businessStatus,
        "is_active": isActive,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
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
        tradeLicense,
        tradeLicensePath,
        businessCoverPicture,
        businessCoverPath,
        isActive
      ];
  Business copyWith({
    int? id,
    int? userId,
    String? businessDisplayName,
    String? businessLegalName,
    String? businessDescription,
    String? businessCity,
    String? businessLat,
    String? businessLng,
    int? businessCategory,
    String? businessLogo,
    String? businessLogoPath,
    String? tradeLicense,
    String? tradeLicensePath,
    String? businessStatus,
    int? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? businessCover,
    String? businessCoverPath,
  }) {
    return Business(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        businessCoverPicture: businessCover ?? this.businessCoverPicture,
        businessCoverPath: businessCoverPath ?? this.businessCoverPath,
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
        updatedAt: updatedAt ?? this.updatedAt);
  }
}

class LoginUserRoleForBusiness {
  int? id;
  int? businessId;
  String? role;
  int? userId;
  DateTime? createdAt;
  DateTime? updatedAt;

  LoginUserRoleForBusiness({
    this.id,
    this.businessId,
    this.role,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  LoginUserRoleForBusiness copyWith({
    int? id,
    int? businessId,
    String? role,
    int? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      LoginUserRoleForBusiness(
        id: id ?? this.id,
        businessId: businessId ?? this.businessId,
        role: role ?? this.role,
        userId: userId ?? this.userId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory LoginUserRoleForBusiness.fromJson(Map<String, dynamic> json) =>
      LoginUserRoleForBusiness(
        id: json["id"],
        businessId: json["business_id"],
        role: json["role"],
        userId: json["user_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "business_id": businessId,
        "role": role,
        "user_id": userId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class UserRoleForBusiness {
  int? id;
  int? businessId;
  String? role;
  int? userId;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserRoleForBusiness({
    this.id,
    this.businessId,
    this.role,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  UserRoleForBusiness copyWith({
    int? id,
    int? businessId,
    String? role,
    int? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      UserRoleForBusiness(
        id: id ?? this.id,
        businessId: businessId ?? this.businessId,
        role: role ?? this.role,
        userId: userId ?? this.userId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory UserRoleForBusiness.fromRawJson(String str) =>
      UserRoleForBusiness.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserRoleForBusiness.fromJson(Map<String, dynamic> json) =>
      UserRoleForBusiness(
        id: json["id"],
        businessId: json["business_id"],
        role: json["role"],
        userId: json["user_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "business_id": businessId,
        "role": role,
        "user_id": userId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class BusinessData extends Equatable {
  BusinessData(
      {required this.id,
      required this.businessLogo,
      required this.businessCoverPicture,
      required this.platformType,
      required this.userId,
      required this.approval,
      required this.businessCategoryId,
      required this.businessSubCategoryId,
      required this.businessSubCategoryText,
      required this.rejectedReason,
      required this.actionTakenBy,
      required this.isAdminBusiness,
      required this.streetNumber,
      required this.cityName,
      required this.counteryName,
      required this.address,
      required this.state,
      required this.zipCode,
      required this.lat,
      required this.lng,
      required this.isAddressPivate,
      required this.isPremiumBusiness,
      required this.createdAt,
      required this.updatedAt,
      required this.dateAdded,
      required this.addedBy,
      required this.updatedBy,
      required this.dateUpdated,
      required this.businesslangdetails,
      required this.getCityArea,
      required this.getBusinessOwner,
      required this.getActionTakenby,
      this.loginUserRoleForBusiness,
      this.userRoleForBusiness,
      this.tradeLicence});

  final int? id;
  final String? businessLogo;
  final String? businessCoverPicture;
  final String? platformType;
  final int? userId;
  final String? approval;
  final int? businessCategoryId;
  final int? businessSubCategoryId;
  final dynamic businessSubCategoryText;
  final dynamic rejectedReason;
  final int? actionTakenBy;
  final int? isAdminBusiness;
  final String? streetNumber;
  final String? tradeLicence;
  final String? cityName;
  final String? counteryName;
  final String? address;
  final String? state;
  final String? zipCode;
  final double? lat;
  final double? lng;
  final int? isAddressPivate;
  final int? isPremiumBusiness;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? dateAdded;
  final int? addedBy;
  final dynamic updatedBy;
  final DateTime? dateUpdated;
  final Businesslangdetails? businesslangdetails;
  final dynamic getCityArea;
  final UserData? getBusinessOwner;
  final dynamic getActionTakenby;
  final LoginUserRoleForBusiness? loginUserRoleForBusiness;
  final List<UserRoleForBusiness>? userRoleForBusiness;

  factory BusinessData.empty() => BusinessData(
      id: 0,
      businessLogo: '',
      businessCoverPicture: '',
      platformType: '',
      userId: 0,
      approval: '',
      businessCategoryId: 0,
      businessSubCategoryId: 0,
      businessSubCategoryText: '',
      rejectedReason: '',
      actionTakenBy: 0,
      isAdminBusiness: 0,
      streetNumber: '',
      cityName: '',
      counteryName: '',
      address: '',
      state: '',
      zipCode: '',
      lat: 0.0,
      lng: 0.0,
      isAddressPivate: 0,
      isPremiumBusiness: 0,
      createdAt: null,
      updatedAt: null,
      dateAdded: null,
      addedBy: 0,
      updatedBy: null,
      dateUpdated: null,
      businesslangdetails: Businesslangdetails.empty(),
      getCityArea: null,
      getBusinessOwner: null,
      getActionTakenby: null);

  factory BusinessData.fromJson(Map<String, dynamic> json) => BusinessData(
      id: json["id"],
      businessLogo: json["business_logo_down_path"],
      businessCoverPicture: json["business_cover_picture_down_path"],
      platformType: json["platform_type"],
      userId: json["user_id"],
      approval: json["approval"],
      businessCategoryId: json["business_category_id"],
      businessSubCategoryId: json["business_sub_category_id"],
      businessSubCategoryText: json["business_sub_category_text"],
      rejectedReason: json["rejected_reason"],
      actionTakenBy: json["action_taken_by"],
      isAdminBusiness: json["is_admin_business"],
      streetNumber: json["street_number"],
      cityName: json["city_name"],
      counteryName: json["countery_name"],
      address: json["address"],
      state: json["state"],
      zipCode: json["zip_code"],
      lat: json["lat"].toDouble(),
      lng: json["lng"].toDouble(),
      isAddressPivate: json["is_address_pivate"],
      isPremiumBusiness: json["is_premium_business"],
      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"]),
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.parse(json["updated_at"]),
      dateAdded: json["date_added"] == null
          ? null
          : DateTime.parse(json["date_added"]),
      addedBy: json["added_by"],
      updatedBy: json["updated_by"],
      dateUpdated: json["date_updated"] == null
          ? null
          : DateTime.parse(json["date_updated"]),
      businesslangdetails:
          Businesslangdetails.fromJson(json["default_language_business"]),
      getCityArea: json["get_city_area"],
      getBusinessOwner: json["get_business_owner"] != null
          ? UserData.fromJson(json["get_business_owner"])
          : null,
      loginUserRoleForBusiness: json["login_user_role_for_business"] != null
          ? LoginUserRoleForBusiness.fromJson(
              json["login_user_role_for_business"])
          : null,
      getActionTakenby: json["get_action_takenby"],
      tradeLicence: json['trade_license_number'] ?? "",
      userRoleForBusiness: json["user_role_for_business"] == null
          ? []
          : List<UserRoleForBusiness>.from(json["user_role_for_business"]!
              .map((x) => UserRoleForBusiness.fromJson(x))));

  @override
  List<Object?> get props => [
        id,
        businessLogo,
        businessCoverPicture,
        platformType,
        userId,
        approval,
        businessCategoryId,
        businessSubCategoryId,
        businessSubCategoryText,
        rejectedReason,
        actionTakenBy,
        isAdminBusiness,
        streetNumber,
        cityName,
        counteryName,
        address,
        state,
        zipCode,
        lat,
        lng,
        isAddressPivate,
        isPremiumBusiness,
        createdAt,
        updatedAt,
        dateAdded,
        addedBy,
        updatedBy,
        dateUpdated,
        businesslangdetails,
        getCityArea,
        getBusinessOwner,
        getActionTakenby
      ];

  @override
  String toString() {
    return 'BusinessData(id: $id, businessLogo: $businessLogo, businessCoverPicture: $businessCoverPicture, platformType: $platformType, userId: $userId, approval: $approval, businessCategoryId: $businessCategoryId, businessSubCategoryId: $businessSubCategoryId, businessSubCategoryText: $businessSubCategoryText, rejectedReason: $rejectedReason, actionTakenBy: $actionTakenBy, isAdminBusiness: $isAdminBusiness, streetNumber: $streetNumber, cityName: $cityName, counteryName: $counteryName, address: $address, state: $state, zipCode: $zipCode, lat: $lat, lng: $lng, isAddressPivate: $isAddressPivate, isPremiumBusiness: $isPremiumBusiness, createdAt: $createdAt, updatedAt: $updatedAt, dateAdded: $dateAdded, addedBy: $addedBy, updatedBy: $updatedBy, dateUpdated: $dateUpdated, businesslangdetails: $businesslangdetails, getCityArea: $getCityArea, getBusinessOwner: $getBusinessOwner, getActionTakenby: $getActionTakenby)';
  }
}

class Businesslangdetails {
  Businesslangdetails({
    required this.id,
    required this.languageId,
    required this.businessId,
    required this.businessName,
    required this.businessDescription,
    required this.areaId,
    required this.createdAt,
    required this.updatedAt,
    required this.dateAdded,
    required this.addedBy,
    required this.updatedBy,
    required this.dateUpdated,
  });

  final int? id;
  final int? languageId;
  final int? businessId;
  final String? businessName;
  final String? businessDescription;
  final dynamic areaId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? dateAdded;
  final int? addedBy;
  final dynamic updatedBy;
  final DateTime? dateUpdated;

  factory Businesslangdetails.empty() => Businesslangdetails(
      id: 0,
      languageId: 0,
      businessId: 0,
      businessName: '',
      businessDescription: '',
      areaId: null,
      createdAt: null,
      updatedAt: null,
      dateAdded: null,
      addedBy: 0,
      updatedBy: null,
      dateUpdated: null);

  factory Businesslangdetails.fromJson(Map<String, dynamic> json) =>
      Businesslangdetails(
        id: json["id"],
        languageId: json["language_id"],
        businessId: json["business_id"],
        businessName: json["business_name"],
        businessDescription: json["business_description"],
        areaId: json["area_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        dateAdded: json["date_added"] == null
            ? null
            : DateTime.parse(json["date_added"]),
        addedBy: json["added_by"],
        updatedBy: json["updated_by"],
        dateUpdated: json["date_updated"] == null
            ? null
            : DateTime.parse(json["date_updated"]),
      );
}
