import 'package:happiness_club_merchant/services/error/failure.dart';
import 'package:happiness_club_merchant/services/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../services/repository/repository.dart';

/// This method will get all business categories
/// Input: [GetBusinessLocationParams] contains accessToken and businessId
/// Output : [GetBusinessLocationsResponse] contains category response
/// if unsuccessful the response will be [Failure]
class GetBusinessLocations
    implements
        UseCase<GetBusinessLocationsResponse, GetBusinessLocationParams> {
  final Repository _repository;

  GetBusinessLocations(this._repository);

  @override
  Future<Either<Failure, GetBusinessLocationsResponse>> call(
      GetBusinessLocationParams params) {
    return _repository.getBusinessLocations(params);
  }
}

class GetBusinessLocationsResponse {
  GetBusinessLocationsResponse({
    required this.businessLocations,
  });

  List<BusinessLocation> businessLocations;

  factory GetBusinessLocationsResponse.fromJson(Map<String, dynamic> json) =>
      GetBusinessLocationsResponse(
        businessLocations: List<BusinessLocation>.from(
            json["business_locations"]
                .map((x) => BusinessLocation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "business_locations":
            List<dynamic>.from(businessLocations.map((x) => x.toJson())),
      };
}

class GetBusinessLocationParams extends Equatable {
  final String accessToken;
  final int businessId;

  const GetBusinessLocationParams(
      {required this.accessToken, required this.businessId});

  factory GetBusinessLocationParams.withAccessToken(
          {required String accessToken,
          required GetBusinessLocationParams params}) =>
      GetBusinessLocationParams(
          accessToken: accessToken, businessId: params.businessId);

  @override
  List<Object?> get props => [businessId];
}

class BusinessLocation {
  int id;
  int businessId;
  String lat;
  String lng;
  String branchName;
  String cityName;
  DateTime createdAt;
  DateTime updatedAt;

  BusinessLocation({
    required this.id,
    required this.businessId,
    required this.lat,
    required this.branchName,
    required this.lng,
    required this.cityName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BusinessLocation.fromJson(Map<String, dynamic> json) =>
      BusinessLocation(
        id: json["id"],
        businessId: json["business_id"],
        lat: json["lat"],
        branchName: json['branch_name'] ?? '',
        lng: json["lng"],
        cityName: json["city_name"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "business_id": businessId,
        "lat": lat,
        'branch_name': branchName,
        "lng": lng,
        "city_name": cityName,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
