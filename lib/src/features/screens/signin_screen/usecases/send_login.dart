// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
//import 'package:firebase_auth/firebase_auth.dart';

import 'package:happiness_club_merchant/services/error/failure.dart';
import 'package:happiness_club_merchant/services/repository/repository.dart';
import 'package:happiness_club_merchant/services/usecases/usecase.dart';

import '../../../../../utils/constants/user_types_enum.dart';

/// This method will send login details
/// Input: [SendLoginParams] contains email and password
/// Output : [UserDetailResponse] contains user details and login token
/// if unsuccessful the response will be [Failure]
class SendLogin extends UseCase<UserDetailResponse, SendLoginParams> {
  //

  final Repository _repository;

  SendLogin(this._repository);

  @override
  Future<Either<Failure, UserDetailResponse>> call(SendLoginParams params) {
    return _repository.sendLogin(params);
  }
}

class ThridResponceLogin {
  String name;
  String email;
  String token;
  String proifleUrl;
  ThridResponceLogin({
    required this.name,
    required this.email,
    required this.token,
    required this.proifleUrl,
  });
}

class ThridPartLoginData {
  String email;
  String name;
  String profilePic;
  String loginType;
  String loginToke;
  ThridPartLoginData({
    required this.email,
    required this.name,
    required this.profilePic,
    required this.loginType,
    required this.loginToke,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'name': name,
      'profile_picture': profilePic,
      'login_type': loginType,
      'login_token': loginToke,
    };
  }

  factory ThridPartLoginData.fromMap(Map<String, dynamic> map) {
    return ThridPartLoginData(
      email: map['email'] as String,
      name: map['name'] as String,
      profilePic: map['profilePic'] as String,
      loginType: map['loginType'] as String,
      loginToke: map['loginToke'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ThridPartLoginData.fromJson(String source) =>
      ThridPartLoginData.fromMap(json.decode(source) as Map<String, dynamic>);
}

class SendLoginParams extends Equatable {
  final String email;
  final String password;

  const SendLoginParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      };
}

class UserDetailResponse extends Equatable {
  final UserData user;
  final bool status;
  final String token;
  const UserDetailResponse({
    required this.user,
    required this.status,
    required this.token,
  });

  factory UserDetailResponse.fromJson(Map<String, dynamic> json) =>
      UserDetailResponse(
          user: UserData.fromJson(json["user"]),
          status: json["status"],
          token: json['token'] ?? '');

  @override
  List<Object?> get props => [user, status];
}

class UserData extends Equatable {
  int id;
  String fullName;
  String email;
  String phoneNumber;
  dynamic dateOfBirth;
  dynamic profileImage;
  String password;
  dynamic notificationTokenId;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  int hasBusiness;

  UserData({
    required this.id,
    required this.hasBusiness,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.dateOfBirth,
    this.profileImage,
    required this.password,
    this.notificationTokenId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json["id"],
        fullName: json["full_name"],
        email: json["email"],
        hasBusiness: json['has_business'],
        phoneNumber: json["phone_number"],
        dateOfBirth: json["date_of_birth"],
        profileImage: json["profile_image"] ?? '',
        password: json["password"],
        notificationTokenId: json["notification_token_id"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );
  @override
  List<Object?> get props => [
        id,
        fullName,
        email,
        phoneNumber,
        status,
        updatedAt,
        createdAt,
        password,
        profileImage,
        hasBusiness
      ];

  UserData copyWith({
    int? id,
    String? fullName,
    String? dateOfBirth,
    String? profileImage,
    String? email,
    String? phoneNumber,
    int? status,
    int? hasBusiness,
    DateTime? updatedAt,
    DateTime? createdAt,
    String? notificationsToken,
    String? password,
  }) {
    return UserData(
      id: id ?? this.id,
      hasBusiness: hasBusiness ?? this.hasBusiness,
      fullName: fullName ?? this.fullName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      profileImage: profileImage ?? this.profileImage,
      // oauthProvider: oauthProvider ?? this.oauthProvider,
      // oauthUid: oauthUid ?? this.oauthUid,
      // userName: userName ?? this.userName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      // phoneImeiNumber: phoneImeiNumber ?? this.phoneImeiNumber,
      // professionId: professionId ?? this.professionId,
      // currentJob: currentJob ?? this.currentJob,
      // experience: experience ?? this.experience,
      // userToken: userToken ?? this.userToken,
      // rememberToken: rememberToken ?? this.rememberToken,
      // isGuest: isGuest ?? this.isGuest,
      // isVerified: isVerified ?? this.isVerified,
      status: status ?? this.status,
      password: password ?? this.password,
      // notificationsToken: notificationsToken ?? this.notificationsToken,

      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class DefaultLanguageUser {
  DefaultLanguageUser({
    required this.id,
    required this.languageId,
    required this.userId,
    required this.fullName,
    required this.createdAt,
    required this.updatedAt,
    required this.dateAdded,
    required this.addedBy,
    required this.updatedBy,
    required this.dateUpdated,
  });

  final int id;
  final int languageId;
  final int userId;
  final String fullName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime dateAdded;
  final int addedBy;
  final dynamic updatedBy;
  final dynamic dateUpdated;

  factory DefaultLanguageUser.fromJson(Map<String, dynamic> json) =>
      DefaultLanguageUser(
        id: json["id"],
        languageId: json["language_id"],
        userId: json["user_id"],
        fullName: json["full_name"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        dateAdded: DateTime.parse(json["date_added"]),
        addedBy: json["added_by"],
        updatedBy: json["updated_by"],
        dateUpdated: json["date_updated"],
      );
}

class GetPostAdminUser extends Equatable {
  GetPostAdminUser({
    required this.id,
    required this.employeeAdId,
    required this.isActive,
    required this.entityType,
    required this.createdAt,
    required this.updatedAt,
    required this.entityAssign,
  });

  final int id;
  final String employeeAdId;
  final int isActive;
  final dynamic entityType;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int entityAssign;

  factory GetPostAdminUser.fromJson(Map<String, dynamic> json) =>
      GetPostAdminUser(
        id: json["id"],
        employeeAdId: json["employee_ad_id"],
        isActive: json["is_active"],
        entityType: json["entity_type"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        entityAssign: json["entity_assign"],
      );

  @override
  List<Object?> get props => [
        id,
        employeeAdId,
        isActive,
        entityType,
        createdAt,
        updatedAt,
        entityAssign
      ];

  // @override
  // List<Object?> get props => [];
}
