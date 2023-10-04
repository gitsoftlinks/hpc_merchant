import 'package:happiness_club_merchant/services/error/failure.dart';
import 'package:happiness_club_merchant/services/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../../services/repository/repository.dart';

/// This method will get offer detail by offerId from server
/// Input: [GetOfferDetailParams] contains accessToken and offerId
/// Output : [GetOfferDetailResponse] contains Offer response
/// if unsuccessful the response will be [Failure]
class GetOfferDetail
    implements UseCase<GetOfferDetailResponse, GetOfferDetailParams> {
  final Repository _repository;

  GetOfferDetail(this._repository);

  @override
  Future<Either<Failure, GetOfferDetailResponse>> call(
      GetOfferDetailParams params) {
    return _repository.getOfferDetail(params);
  }
}

class GetOfferDetailParams extends Equatable {
  final String accessToken;
  final int offerId;

  const GetOfferDetailParams(
      {required this.accessToken, required this.offerId});

  factory GetOfferDetailParams.withAccessToken(
          {required String accessToken,
          required GetOfferDetailParams params}) =>
      GetOfferDetailParams(accessToken: accessToken, offerId: params.offerId);

  @override
  List<Object?> get props => [offerId];
}

class GetOfferDetailResponse {
  GetOfferDetailResponse({
    required this.offerDetail,
  });

  OfferDetail offerDetail;

  factory GetOfferDetailResponse.fromJson(Map<String, dynamic> json) =>
      GetOfferDetailResponse(
        offerDetail: OfferDetail.fromJson(json["offer"]),
      );

  Map<String, dynamic> toJson() => {
        "offer": offerDetail.toJson(),
      };
}

class OfferDetail {
  int id;
  int productId;
  String offerTitle;
  int offerDiscount;
  String offerImage;
  String offerImagePath;
  DateTime startDate;
  DateTime expiryDate;
  String shortDescription;
  String offerDescription;
  String isActive;
  DateTime createdAt;
  DateTime updatedAt;
  List<OffersProduct> offersProducts;

  OfferDetail({
    required this.id,
    required this.productId,
    required this.offerTitle,
    required this.offerDiscount,
    required this.offerImage,
    required this.offerImagePath,
    required this.startDate,
    required this.expiryDate,
    required this.shortDescription,
    required this.offerDescription,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.offersProducts,
  });
  factory OfferDetail.empty() => OfferDetail(
        id: 0,
        productId: 0,
        offerDescription: '',
        offerDiscount: 0,
        offerTitle: '',
        offerImage: '',
        isActive: '',
        offerImagePath: '',
        shortDescription: '',
        expiryDate: DateTime.now(),
        startDate: DateTime.now(),
        offersProducts: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
  factory OfferDetail.fromJson(Map<String, dynamic> json) => OfferDetail(
        id: json["id"],
        productId: json["product_id"] ?? 0,
        offerTitle: json["offer_title"],
        offerDiscount: json["offer_discount"],
        offerImage: json["offer_image"],
        offerImagePath: json["offer_image_path"],
        startDate: DateTime.parse(json["start_date"]),
        expiryDate: DateTime.parse(json["expiry_date"]),
        shortDescription: json["short_description"],
        offerDescription: json["offer_description"],
        isActive: json["is_active"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        offersProducts: List<OffersProduct>.from(
            json["offers_products"].map((x) => OffersProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "offer_title": offerTitle,
        "offer_discount": offerDiscount,
        "offer_image": offerImage,
        "offer_image_path": offerImagePath,
        "start_date":
            "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
        "expiry_date":
            "${expiryDate.year.toString().padLeft(4, '0')}-${expiryDate.month.toString().padLeft(2, '0')}-${expiryDate.day.toString().padLeft(2, '0')}",
        "short_description": shortDescription,
        "offer_description": offerDescription,
        "is_active": isActive,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "offers_products":
            List<dynamic>.from(offersProducts.map((x) => x.toJson())),
      };
}

class OffersProduct {
  int id;
  int offerId;
  int productId;
  DateTime createdAt;
  DateTime updatedAt;
  List<Products> product;

  OffersProduct({
    required this.id,
    required this.offerId,
    required this.productId,
    required this.createdAt,
    required this.updatedAt,
    required this.product,
  });

  factory OffersProduct.fromJson(Map<String, dynamic> json) => OffersProduct(
        id: json["id"],
        offerId: json["offer_id"],
        productId: json["product_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        product: List<Products>.from(
            json["product"].map((x) => Products.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "offer_id": offerId,
        "product_id": productId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "product": List<dynamic>.from(product.map((x) => x.toJson())),
      };
}

class Products {
  int id;
  int businessId;
  String productTitle;
  String productDetails;
  String productPrice;
  String isQuantityApplicable;
  String isActive;
  DateTime createdAt;
  DateTime updatedAt;
  List<ProductImage> productImages;
  Business business;

  Products({
    required this.id,
    required this.business,
    required this.businessId,
    required this.productTitle,
    required this.productDetails,
    required this.productPrice,
    required this.isQuantityApplicable,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.productImages,
  });

  factory Products.fromJson(Map<String, dynamic> json) => Products(
        id: json["id"],
        businessId: json["business_id"],
        productTitle: json["product_title"],
        productDetails: json["product_details"],
        productPrice: json["product_price"],
        isQuantityApplicable: json["is_quantity_applicable"],
        isActive: json["is_active"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        business: Business.fromJson(json["business"]),
        productImages: List<ProductImage>.from(
            json["product_images"].map((x) => ProductImage.fromJson(x))),
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
        "business": business.toJson(),
        "product_images":
            List<dynamic>.from(productImages.map((x) => x.toJson())),
      };
}

class Business {
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
  String businessCoverPicture;
  String businessCoverPath;
  String tradeLicense;
  String tradeLicensePath;
  String businessStatus;
  int isActive;
  DateTime createdAt;
  DateTime updatedAt;

  Business({
    required this.id,
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
    required this.updatedAt,
  });

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
    required this.imageName,
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
