import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../services/error/failure.dart';
import '../../../../../services/repository/repository.dart';
import '../../../../../services/usecases/usecase.dart';

/// This method will get offers by business on server
/// Input: [GetAllOffersByBusinessParams] contains accessToken and businessId
/// Output : [GetAllOffersByBusinessResponse] returns true if operation is successful
/// if unsuccessful the response will be [Failure]
class GetAllOffersByBusiness
    implements
        UseCase<GetAllOffersByBusinessResponse, GetAllOffersByBusinessParams> {
  final Repository _repository;

  GetAllOffersByBusiness(this._repository);

  @override
  Future<Either<Failure, GetAllOffersByBusinessResponse>> call(
      GetAllOffersByBusinessParams params) {
    return _repository.getAllOffersByBusiness(params);
  }
}

class GetAllOffersByBusinessParams extends Equatable {
  final String accessToken;
  final int businessId;

  const GetAllOffersByBusinessParams(
      {required this.accessToken, required this.businessId});

  factory GetAllOffersByBusinessParams.withAccessToken(
          {required String accessToken,
          required GetAllOffersByBusinessParams params}) =>
      GetAllOffersByBusinessParams(
          accessToken: accessToken, businessId: params.businessId);

  @override
  List<Object?> get props => [businessId];
}

class GetAllOffersByBusinessResponse {
  GetAllOffersByBusinessResponse({
    required this.offers,
  });

  List<Offer> offers;

  factory GetAllOffersByBusinessResponse.fromJson(Map<String, dynamic> json) =>
      GetAllOffersByBusinessResponse(
        offers: List<Offer>.from(json["offers"].map((x) => Offer.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "offers": List<dynamic>.from(offers.map((x) => x.toJson())),
      };
}

class Offer {
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

  Offer({
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

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
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
  List<Product> product;

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
        product:
            List<Product>.from(json["product"].map((x) => Product.fromJson(x))),
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

class Product {
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

  Product({
    required this.id,
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

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        businessId: json["business_id"],
        productTitle: json["product_title"],
        productDetails: json["product_details"],
        productPrice: json["product_price"],
        isQuantityApplicable: json["is_quantity_applicable"],
        isActive: json["is_active"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
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
        "product_images":
            List<dynamic>.from(productImages.map((x) => x.toJson())),
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
