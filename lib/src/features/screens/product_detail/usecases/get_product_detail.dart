import 'package:happiness_club_merchant/services/error/failure.dart';
import 'package:happiness_club_merchant/services/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../services/repository/repository.dart';
import '../../products_by_business/usecase/get_all_products.dart';

/// This method will get product detail by productId from server
/// Input: [GetProductDetailParams] contains accessToken and productId
/// Output : [GetProductDetailResponse] contains Business response
/// if unsuccessful the response will be [Failure]
class GetProductDetail
    implements UseCase<GetProductDetailResponse, GetProductDetailParams> {
  final Repository _repository;

  GetProductDetail(this._repository);

  @override
  Future<Either<Failure, GetProductDetailResponse>> call(
      GetProductDetailParams params) {
    return _repository.getProductDetail(params);
  }
}

class GetProductDetailParams extends Equatable {
  final String accessToken;
  final int productId;

  const GetProductDetailParams(
      {required this.accessToken, required this.productId});

  factory GetProductDetailParams.withAccessToken(
          {required String accessToken,
          required GetProductDetailParams params}) =>
      GetProductDetailParams(
          accessToken: accessToken, productId: params.productId);

  @override
  List<Object?> get props => [productId];
}

class GetProductDetailResponse {
  GetProductDetailResponse({
    required this.productDetail,
  });

  ProductDetail productDetail;

  factory GetProductDetailResponse.fromJson(Map<String, dynamic> json) =>
      GetProductDetailResponse(
        productDetail: ProductDetail.fromJson(json["productDetail"]),
      );

  Map<String, dynamic> toJson() => {
        "productDetail": productDetail.toJson(),
      };
}

class ProductDetail {
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
  List<dynamic> productLocations;

  ProductDetail({
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
  factory ProductDetail.empty() => ProductDetail(
        id: 0,
        businessId: 0,
        productDetails: '',
        isQuantityApplicable: '',
        productTitle: '',
        productPrice: '',
        isActive: '',
        productImages: [],
        productLocations: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
  factory ProductDetail.fromJson(Map<String, dynamic> json) => ProductDetail(
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
        productLocations:
            List<dynamic>.from(json["product_locations"].map((x) => x)),
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
        "product_locations": List<dynamic>.from(productLocations.map((x) => x)),
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
