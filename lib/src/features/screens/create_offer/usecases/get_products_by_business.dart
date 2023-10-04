// To parse this JSON data, do
//
//     final productsByBusinessUseCase = productsByBusinessUseCaseFromJson(jsonString);

import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../services/error/failure.dart';
import '../../../../../services/repository/repository.dart';
import '../../../../../services/usecases/usecase.dart';

/// This method will get all business categories
/// Input: [GetProductByBusinessParams] contains accessToken, businessId and parentId
/// Output : [GetProductByBusinessResponse] contains category response
/// if unsuccessful the response will be [Failure]
class GetProductsByBusiness
    implements
        UseCase<GetProductByBusinessResponse, GetProductByBusinessParams> {
  final Repository _repository;

  GetProductsByBusiness(this._repository);

  @override
  Future<Either<Failure, GetProductByBusinessResponse>> call(
      GetProductByBusinessParams params) {
    return _repository.getProductsByBusiness(params);
  }
}

class GetProductByBusinessResponse {
  GetProductByBusinessResponse({
    required this.productsByBusiness,
  });

  List<ProductByBusiness> productsByBusiness;

  factory GetProductByBusinessResponse.fromJson(Map<String, dynamic> json) =>
      GetProductByBusinessResponse(
        productsByBusiness: List<ProductByBusiness>.from(
            json["businessProducts"].map((x) => ProductByBusiness.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "businessProducts":
            List<dynamic>.from(productsByBusiness.map((x) => x.toJson())),
      };
}

class GetProductByBusinessParams extends Equatable {
  final String accessToken;
  final int businessId;

  const GetProductByBusinessParams(
      {required this.accessToken, required this.businessId});

  factory GetProductByBusinessParams.withAccessToken(
          {required String accessToken,
          required GetProductByBusinessParams params}) =>
      GetProductByBusinessParams(
          accessToken: accessToken, businessId: params.businessId);

  @override
  List<Object?> get props => [businessId];
}

class ProductByBusiness {
  int id;
  int businessId;
  String productTitle;
  String productDetails;
  String productPrice;
  String isQuantityApplicable;
  String isActive;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic business;
  List<ProductImage> productImages;
  List<ProductLocation> productLocations;

  ProductByBusiness({
    required this.id,
    required this.businessId,
    required this.productTitle,
    required this.productDetails,
    required this.productPrice,
    required this.isQuantityApplicable,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.business,
    required this.productImages,
    required this.productLocations,
  });

  factory ProductByBusiness.fromJson(Map<String, dynamic> json) =>
      ProductByBusiness(
        id: json["id"],
        businessId: json["business_id"],
        productTitle: json["product_title"],
        productDetails: json["product_details"],
        productPrice: json["product_price"],
        isQuantityApplicable: json["is_quantity_applicable"],
        isActive: json["is_active"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        business: json["business"],
        productImages: List<ProductImage>.from(
            json["product_images"].map((x) => ProductImage.fromJson(x))),
        productLocations: List<ProductLocation>.from(
            json["product_locations"].map((x) => ProductLocation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "business_id": businessId,
        "product_title": productTitle,
        "product_details": productDetails,
        "product_price": productPrice,
        "is_quantity_applicable": isQuantityApplicable,
        "is_active": isActive,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "business": business,
        "product_images":
            List<dynamic>.from(productImages.map((x) => x.toJson())),
        "product_locations":
            List<dynamic>.from(productLocations.map((x) => x.toJson())),
      };
}

class ProductImage {
  int id;
  int productId;
  dynamic imageName;
  String imagePath;
  DateTime createdAt;
  DateTime updatedAt;

  ProductImage({
    required this.id,
    required this.productId,
    this.imageName,
    required this.imagePath,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) => ProductImage(
        id: json["id"],
        productId: json["product_id"],
        imageName: json["image_name"],
        imagePath: json["image_path"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "image_name": imageName,
        "image_path": imagePath,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class ProductLocation {
  int id;
  int productId;
  int businessId;
  int businessLocationId;
  String lat;
  String lng;
  int isQuantityApplicable;
  int quantityCount;
  int isAvailable;
  DateTime createdAt;
  DateTime updatedAt;

  ProductLocation({
    required this.id,
    required this.productId,
    required this.businessId,
    required this.businessLocationId,
    required this.lat,
    required this.lng,
    required this.isQuantityApplicable,
    required this.quantityCount,
    required this.isAvailable,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductLocation.fromJson(Map<String, dynamic> json) =>
      ProductLocation(
        id: json["id"],
        productId: json["product_id"],
        businessId: json["business_id"],
        businessLocationId: json["business_location_id"],
        lat: json["lat"],
        lng: json["lng"],
        isQuantityApplicable: json["is_quantity_applicable"],
        quantityCount: json["quantity_count"],
        isAvailable: json["is_available"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "business_id": businessId,
        "business_location_id": businessLocationId,
        "lat": lat,
        "lng": lng,
        "is_quantity_applicable": isQuantityApplicable,
        "quantity_count": quantityCount,
        "is_available": isAvailable,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
