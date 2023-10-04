import 'package:dartz/dartz.dart';
import 'package:happiness_club_merchant/services/error/failure.dart';
import 'package:happiness_club_merchant/services/repository/repository.dart';
import 'package:happiness_club_merchant/services/usecases/usecase.dart';
import 'dart:convert';

/// This use case will get place result from google place api depends on search querry
/// Input: [String] contains query for a place
/// Output: [GoogleMapPlaceGetResponse] contains the response from google place api
/// if unsuccessful the response will be [Failure]
class GoogleMapPlaceGet implements UseCase<GoogleMapPlaceGetResponse, String> {
  final Repository _repository;

  GoogleMapPlaceGet(this._repository);

  @override
  Future<Either<Failure, GoogleMapPlaceGetResponse>> call(String params) {
    return _repository.googleMapPlaceGet(params);
  }
}

// To parse this JSON data, do
//
//     final googleMapPlaceGetResponse = googleMapPlaceGetResponseFromJson(jsonString);

class GoogleMapPlaceGetResponse {
  final List<Prediction> predictions;
  final String status;

  GoogleMapPlaceGetResponse({
    required this.predictions,
    required this.status,
  });

  factory GoogleMapPlaceGetResponse.fromRawJson(String str) =>
      GoogleMapPlaceGetResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GoogleMapPlaceGetResponse.fromJson(Map<String, dynamic> json) =>
      GoogleMapPlaceGetResponse(
        predictions: List<Prediction>.from(
            json["predictions"].map((x) => Prediction.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "predictions": List<dynamic>.from(predictions.map((x) => x.toJson())),
        "status": status,
      };
}

class Prediction {
  Prediction({
    required this.description,
    required this.matchedSubstrings,
    required this.placeId,
    required this.reference,
    required this.structuredFormatting,
    required this.terms,
    required this.types,
  });

  final String description;
  final List<MatchedSubstring> matchedSubstrings;
  final String placeId;
  final String reference;
  final StructuredFormatting structuredFormatting;
  final List<Term> terms;
  final List<String> types;

  factory Prediction.fromRawJson(String str) =>
      Prediction.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Prediction.fromJson(Map<String, dynamic> json) => Prediction(
        description: json["description"],
        matchedSubstrings: List<MatchedSubstring>.from(
            json["matched_substrings"]
                .map((x) => MatchedSubstring.fromJson(x))),
        placeId: json["place_id"],
        reference: json["reference"],
        structuredFormatting:
            StructuredFormatting.fromJson(json["structured_formatting"]),
        terms: List<Term>.from(json["terms"].map((x) => Term.fromJson(x))),
        types: List<String>.from(json["types"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "matched_substrings":
            List<dynamic>.from(matchedSubstrings.map((x) => x.toJson())),
        "place_id": placeId,
        "reference": reference,
        "structured_formatting": structuredFormatting.toJson(),
        "terms": List<dynamic>.from(terms.map((x) => x.toJson())),
        "types": List<dynamic>.from(types.map((x) => x)),
      };
}

class MatchedSubstring {
  MatchedSubstring({
    required this.length,
    required this.offset,
  });

  final int length;
  final int offset;

  factory MatchedSubstring.fromRawJson(String str) =>
      MatchedSubstring.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MatchedSubstring.fromJson(Map<String, dynamic> json) =>
      MatchedSubstring(
        length: json["length"],
        offset: json["offset"],
      );

  Map<String, dynamic> toJson() => {
        "length": length,
        "offset": offset,
      };
}

class StructuredFormatting {
  StructuredFormatting({
    required this.mainText,
    required this.mainTextMatchedSubstrings,
    required this.secondaryText,
  });

  final String mainText;
  final List<MatchedSubstring> mainTextMatchedSubstrings;
  final String? secondaryText;

  factory StructuredFormatting.fromRawJson(String str) =>
      StructuredFormatting.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StructuredFormatting.fromJson(Map<String, dynamic> json) =>
      StructuredFormatting(
        mainText: json["main_text"],
        mainTextMatchedSubstrings: List<MatchedSubstring>.from(
            json["main_text_matched_substrings"]
                .map((x) => MatchedSubstring.fromJson(x))),
        secondaryText: json["secondary_text"],
      );

  Map<String, dynamic> toJson() => {
        "main_text": mainText,
        "main_text_matched_substrings": List<dynamic>.from(
            mainTextMatchedSubstrings.map((x) => x.toJson())),
        "secondary_text": secondaryText,
      };
}

class Term {
  Term({
    required this.offset,
    required this.value,
  });

  final int offset;
  final String value;

  factory Term.fromRawJson(String str) => Term.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Term.fromJson(Map<String, dynamic> json) => Term(
        offset: json["offset"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "offset": offset,
        "value": value,
      };
}
