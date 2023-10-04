


import 'package:dartz/dartz.dart';
import 'package:happiness_club_merchant/services/error/failure.dart';
import 'package:happiness_club_merchant/services/repository/repository.dart';
import 'package:happiness_club_merchant/services/usecases/usecase.dart';
import 'dart:convert';

/// This use case will get place result from google place api depends on place_id
/// Input: [String] contains place_id
/// Output: [GoogleMapPlaceDetailsGetResponse] contains the response from google place api
/// if unsuccessful the response will be [Failure]
class GoogleMapPlaceDetailsGet implements UseCase<GoogleMapPlaceDetailsGetResponse, String>{
  final Repository _repository;

  GoogleMapPlaceDetailsGet(this._repository);

  @override
  Future<Either<Failure, GoogleMapPlaceDetailsGetResponse>> call(String params) {
    return _repository.googleMapPlaceDetailsGet(params);
  }
}


class GoogleMapPlaceDetailsGetResponse {
  GoogleMapPlaceDetailsGetResponse({
    required this.addressComponents,
    required this.adrAddress,
    required this.formattedAddress,
    required this.geometry,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconMaskBaseUri,
    required this.name,
    required this.placeId,
    required this.reference,
    required this.types,
    required this.url,
    required this.utcOffset,
    required this.vicinity,
  });

  final List<AddressComponent> addressComponents;
  final String adrAddress;
  final String formattedAddress;
  final Geometry geometry;
  final String icon;
  final String iconBackgroundColor;
  final String iconMaskBaseUri;
  final String name;
  final String placeId;
  final String reference;
  final List<String> types;
  final String url;
  final int utcOffset;
  final String vicinity;

  factory GoogleMapPlaceDetailsGetResponse.fromJson(Map<String, dynamic> json) => GoogleMapPlaceDetailsGetResponse(
    addressComponents: List<AddressComponent>.from(json["address_components"].map((x) => AddressComponent.fromJson(x))),
    adrAddress: json["adr_address"],
    formattedAddress: json["formatted_address"],
    geometry: Geometry.fromJson(json["geometry"]),
    icon: json["icon"],
    iconBackgroundColor: json["icon_background_color"],
    iconMaskBaseUri: json["icon_mask_base_uri"],
    name: json["name"],
    placeId: json["place_id"],
    reference: json["reference"],
    types: List<String>.from(json["types"].map((x) => x)),
    url: json["url"],
    utcOffset: json["utc_offset"],
    vicinity: json["vicinity"],
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

  factory AddressComponent.fromRawJson(String str) => AddressComponent.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AddressComponent.fromJson(Map<String, dynamic> json) => AddressComponent(
    longName: json["long_name"],
    shortName: json["short_name"],
    types: List<String>.from(json["types"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "long_name": longName,
    "short_name": shortName,
    "types": List<dynamic>.from(types.map((x) => x)),
  };
}

class Geometry {
  Geometry({
    required this.location,
    required this.viewport,
  });

  final Location location;
  final Viewport viewport;

  factory Geometry.fromRawJson(String str) => Geometry.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
    location: Location.fromJson(json["location"]),
    viewport: Viewport.fromJson(json["viewport"]),
  );

  Map<String, dynamic> toJson() => {
    "location": location.toJson(),
    "viewport": viewport.toJson(),
  };
}

class Location {
  Location({
    required this.lat,
    required this.lng,
  });

  final double lat;
  final double lng;

  factory Location.fromRawJson(String str) => Location.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    lat: json["lat"].toDouble(),
    lng: json["lng"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "lng": lng,
  };
}

class Viewport {
  Viewport({
    required this.northeast,
    required this.southwest,
  });

  final Location northeast;
  final Location southwest;

  factory Viewport.fromRawJson(String str) => Viewport.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Viewport.fromJson(Map<String, dynamic> json) => Viewport(
    northeast: Location.fromJson(json["northeast"]),
    southwest: Location.fromJson(json["southwest"]),
  );

  Map<String, dynamic> toJson() => {
    "northeast": northeast.toJson(),
    "southwest": southwest.toJson(),
  };
}

