import 'dart:convert';

import 'package:happiness_club_merchant/services/error/failure.dart';
import 'package:happiness_club_merchant/services/repository/repository.dart';
import 'package:happiness_club_merchant/services/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

/// This method will register the user
/// Input: [RegisterUserParams] contains fullName, phone, email, interestArea and password
/// Output : [UserRegistrationResponse] contains user details and login token
/// if unsuccessful the response will be [Failure]

class RegisterUser
    implements UseCase<UserRegistrationResponse, RegisterUserParams> {
  final Repository _repository;

  RegisterUser(this._repository);

  @override
  Future<Either<Failure, UserRegistrationResponse>> call(
      RegisterUserParams params) {
    return _repository.registerUser(params);
  }
}

class UserRegistrationResponse {
  final User user;
  final String token;

  UserRegistrationResponse({
    required this.user,
    required this.token,
  });

  factory UserRegistrationResponse.fromJson(Map<String, dynamic> json) =>
      UserRegistrationResponse(
        user: User.fromJson(json["user"]),
        token: json["token"],
      );
}

class User {
  final String fullName;
  final int hasBusiness;
  final String? emailAddress;
  final String? contactNumber;
  final String password;
  final DateTime updatedAt;
  final DateTime createdAt;
  final int id;

  User({
    required this.fullName,
    required this.hasBusiness,
    required this.emailAddress,
    required this.contactNumber,
    required this.password,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        fullName: json["full_name"],
        emailAddress: json["email"],
        contactNumber: json["phone_number"],
        password: json["password"],
        hasBusiness: json['has_business'],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
      );
}

class RegisterUserParams extends Equatable {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String password;

  const RegisterUserParams({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'full_name': fullName,
        'phone_number': phoneNumber,
        'password': password,
        'email': email,
      };

  @override
  List<Object?> get props => [fullName, email, phoneNumber, password];
}
