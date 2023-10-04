import 'package:dartz/dartz.dart';
import 'package:happiness_club_merchant/services/error/failure.dart';
import 'package:happiness_club_merchant/services/repository/repository.dart';
import 'package:happiness_club_merchant/services/usecases/usecase.dart';

/// This use case will get place result from google place api depends on latitude and longitude
/// Input: [String] contains latlang
/// Output: [GoogleMapLatLngDetailsGetResponse] contains the response from google place api
/// if unsuccessful the response will be [Failure]
class GoogleMapLatLngDetailsGet
    implements UseCase<GoogleMapLatLngDetailsGetResponse, String> {
  final Repository _repository;

  GoogleMapLatLngDetailsGet(this._repository);

  @override
  Future<Either<Failure, GoogleMapLatLngDetailsGetResponse>> call(
      String params) {
    return _repository.googleMapLatLngDetailsGet(params);
  }
}

class GoogleMapLatLngDetailsGetResponse {
  GoogleMapLatLngDetailsGetResponse({
    required this.plusCode,
    required this.results,
  });

  final PlusCode plusCode;
  final List<Result> results;

  factory GoogleMapLatLngDetailsGetResponse.fromJson(
          Map<String, dynamic> json) =>
      GoogleMapLatLngDetailsGetResponse(
        plusCode: PlusCode.fromJson(json["plus_code"]),
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
      );
}

class PlusCode {
  PlusCode({
    required this.compoundCode,
    required this.globalCode,
  });

  final String? compoundCode;
  final String? globalCode;

  factory PlusCode.fromJson(Map<String, dynamic> json) => PlusCode(
        compoundCode: json["compound_code"],
        globalCode: json["global_code"],
      );

  Map<String, dynamic> toJson() => {
        "compound_code": compoundCode,
        "global_code": globalCode,
      };
}

class Result {
  Result({
    required this.addressComponents,
    required this.formattedAddress,
    required this.geometry,
    required this.placeId,
    required this.plusCode,
    required this.types,
  });

  final List<AddressComponent> addressComponents;
  final String formattedAddress;
  final Geometry geometry;
  final String placeId;
  final PlusCode? plusCode;
  final List<String> types;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        addressComponents: List<AddressComponent>.from(
            json["address_components"]
                .map((x) => AddressComponent.fromJson(x))),
        formattedAddress: json["formatted_address"],
        geometry: Geometry.fromJson(json["geometry"]),
        placeId: json["place_id"],
        plusCode: json["plus_code"] == null
            ? null
            : PlusCode.fromJson(json["plus_code"]),
        types: List<String>.from(json["types"].map((x) => x)),
      );
}

class AddressComponent {
  AddressComponent({
    required this.longName,
    required this.shortName,
    required this.types,
  });

  final String longName;
  final String shortName;
  final List<String> types;

  factory AddressComponent.fromJson(Map<String, dynamic> json) =>
      AddressComponent(
        longName: json["long_name"],
        shortName: json["short_name"],
        types: List<String>.from(json["types"].map((x) => x)),
      );
}

class Geometry {
  Geometry({
    required this.location,
    required this.locationType,
    required this.viewport,
    required this.bounds,
  });

  final Location location;
  final String locationType;
  final Viewport viewport;
  final Viewport? bounds;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        location: Location.fromJson(json["location"]),
        locationType: json["location_type"],
        viewport: Viewport.fromJson(json["viewport"]),
        bounds:
            json["bounds"] == null ? null : Viewport.fromJson(json["bounds"]),
      );
}

class Viewport {
  Viewport({
    required this.northeast,
    required this.southwest,
  });

  final Location northeast;
  final Location southwest;

  factory Viewport.fromJson(Map<String, dynamic> json) => Viewport(
        northeast: Location.fromJson(json["northeast"]),
        southwest: Location.fromJson(json["southwest"]),
      );
}

class Location {
  Location({
    required this.lat,
    required this.lng,
  });

  final double lat;
  final double lng;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
      );
}

getCity(double lat, double lng) {
  for (final component in AddressComponent as List) {
    final types = component['types'] as List;

    if (types.contains('locality')) {
      return component['long_name'];
    }
  }
}
