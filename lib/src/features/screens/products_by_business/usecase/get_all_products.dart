import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:happiness_club_merchant/services/error/failure.dart';
import 'package:happiness_club_merchant/services/usecases/usecase.dart';
import '../../../../../services/repository/repository.dart';

/// This method will get all products related to business by businessId from server
/// Input: [GetAllProductsParams] contains accessToken and businessId
/// Output : [GetAllProductsResponse] contains Product response
/// if unsuccessful the response will be [Failure]
class GetAllProducts
    implements UseCase<GetAllProductsResponse, GetAllProductsParams> {
  final Repository _repository;

  GetAllProducts(this._repository);

  @override
  Future<Either<Failure, GetAllProductsResponse>> call(
      GetAllProductsParams params) {
    return _repository.getAllProducts(params);
  }
}

class GetAllProductsParams extends Equatable {
  final String accessToken;
  final int businessId;

  const GetAllProductsParams(
      {required this.accessToken, required this.businessId});

  factory GetAllProductsParams.withAccessToken(
          {required String accessToken,
          required GetAllProductsParams params}) =>
      GetAllProductsParams(
          accessToken: accessToken, businessId: params.businessId);

  @override
  List<Object?> get props => [businessId];
}

class GetAllProductsResponse {
  GetAllProductsResponse({
    required this.businessProducts,
  });

  List<BusinessProduct> businessProducts;

  factory GetAllProductsResponse.fromJson(Map<String, dynamic> json) =>
      GetAllProductsResponse(
        businessProducts: List<BusinessProduct>.from(
            json["businessProducts"].map((x) => BusinessProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "businessProducts":
            List<dynamic>.from(businessProducts.map((x) => x.toJson())),
      };
}

class BusinessProduct {
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

  BusinessProduct({
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

  factory BusinessProduct.fromJson(Map<String, dynamic> json) =>
      BusinessProduct(
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

class ProductData {
  ProductData(
      {required this.id,
      required this.businessId,
      required this.currencyId,
      required this.offerRate,
      required this.quantity,
      required this.sellingPrice,
      required this.isShareAllowed,
      required this.servicePicture,
      required this.pictureDownPath,
      required this.status,
      required this.isAdminService,
      required this.createdAt,
      required this.updatedAt,
      required this.dateAdded,
      required this.addedBy,
      required this.updatedBy,
      required this.dateUpdated,
      required this.serviceDetails,
      required this.businessUserId,
      this.loginUserRoleForBusiness});

  final int id;
  final int businessId;
  final int? currencyId;
  final double offerRate;
  int quantity;
  final double sellingPrice;
  final int isShareAllowed;
  final String servicePicture;
  final String pictureDownPath;
  final int? status;
  final int? isAdminService;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? dateAdded;
  final DateTime? dateUpdated;
  final int? addedBy;
  final int? updatedBy;
  final ServiceDetails serviceDetails;
  final int? businessUserId;
  final LoginUserRoleForBusiness? loginUserRoleForBusiness;

  factory ProductData.empty() => ProductData(
      id: 0,
      businessId: 0,
      currencyId: null,
      offerRate: 0.0,
      quantity: 0,
      sellingPrice: 0.0,
      isShareAllowed: 0,
      servicePicture: '',
      pictureDownPath: '',
      status: null,
      isAdminService: null,
      createdAt: null,
      updatedAt: null,
      dateAdded: null,
      addedBy: null,
      updatedBy: null,
      dateUpdated: null,
      serviceDetails: ServiceDetails.empty(),
      businessUserId: 0);

  factory ProductData.fromJson(Map<String, dynamic> json) => ProductData(
      id: json["id"],
      businessId: json["business_id"],
      businessUserId: json['business_owner_id'],
      currencyId: json["currency_id"],
      offerRate: double.parse(json["offer_rate"].toString()),
      quantity: 1,
      sellingPrice: double.parse(json["selling_price"].toString()),
      isShareAllowed: json["is_share_allowed"],
      servicePicture: json["service_picture"] ?? '',
      pictureDownPath: json["service_picture_downpath"] ?? '',
      status: json["status"],
      isAdminService: json["is_admin_service"],
      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"]),
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.parse(json["updated_at"]),
      dateAdded: json["date_added"] == null
          ? null
          : DateTime.parse(json["date_added"]),
      dateUpdated: json["date_updated"] == null
          ? null
          : DateTime.parse(json["date_updated"]),
      addedBy: json["added_by"],
      updatedBy: json["updated_by"],
      serviceDetails: json["service_details"] == null
          ? ServiceDetails.empty()
          : ServiceDetails.fromJson(json["service_details"]),
      loginUserRoleForBusiness: json['login_user_role_for_business'] == null
          ? null
          : LoginUserRoleForBusiness.fromJson(
              json['login_user_role_for_business']));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductData &&
        other.id == id &&
        other.businessId == businessId &&
        other.currencyId == currencyId &&
        other.offerRate == offerRate &&
        other.sellingPrice == sellingPrice &&
        other.isShareAllowed == isShareAllowed &&
        other.servicePicture == servicePicture &&
        other.pictureDownPath == pictureDownPath &&
        other.status == status &&
        other.isAdminService == isAdminService &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.dateAdded == dateAdded &&
        other.dateUpdated == dateUpdated &&
        other.addedBy == addedBy &&
        other.updatedBy == updatedBy &&
        other.serviceDetails == serviceDetails &&
        other.businessUserId == businessUserId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        businessId.hashCode ^
        currencyId.hashCode ^
        offerRate.hashCode ^
        sellingPrice.hashCode ^
        isShareAllowed.hashCode ^
        servicePicture.hashCode ^
        pictureDownPath.hashCode ^
        status.hashCode ^
        isAdminService.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        dateAdded.hashCode ^
        dateUpdated.hashCode ^
        addedBy.hashCode ^
        updatedBy.hashCode ^
        serviceDetails.hashCode ^
        businessUserId.hashCode;
  }
}

class LoginUserRoleForBusiness {
  int? id;
  int? businessId;
  String? role;
  int? userId;
  DateTime? createdAt;
  DateTime? updatedAt;

  LoginUserRoleForBusiness({
    this.id,
    this.businessId,
    this.role,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  LoginUserRoleForBusiness copyWith({
    int? id,
    int? businessId,
    String? role,
    int? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      LoginUserRoleForBusiness(
        id: id ?? this.id,
        businessId: businessId ?? this.businessId,
        role: role ?? this.role,
        userId: userId ?? this.userId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory LoginUserRoleForBusiness.fromJson(Map<String, dynamic> json) =>
      LoginUserRoleForBusiness(
        id: json["id"],
        businessId: json["business_id"],
        role: json["role"],
        userId: json["user_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "business_id": businessId,
        "role": role,
        "user_id": userId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class ServiceDetails {
  ServiceDetails({
    required this.id,
    required this.languageId,
    required this.serviceId,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.dateAdded,
    required this.addedBy,
    required this.updatedBy,
    required this.dateUpdated,
  });

  final int id;
  final int languageId;
  final int serviceId;
  final String title;
  final String description;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? dateAdded;
  final DateTime? dateUpdated;
  final int? addedBy;
  final int? updatedBy;

  factory ServiceDetails.empty() => ServiceDetails(
      id: 0,
      languageId: 0,
      serviceId: 0,
      title: '',
      description: '',
      createdAt: null,
      updatedAt: null,
      dateAdded: null,
      addedBy: 0,
      updatedBy: null,
      dateUpdated: null);

  factory ServiceDetails.fromJson(Map<String, dynamic> json) => ServiceDetails(
        id: json["id"],
        languageId: json["language_id"],
        serviceId: json["service_id"],
        title: json["title"],
        description: json["description"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        dateAdded: json["date_added"] == null
            ? null
            : DateTime.parse(json["date_added"]),
        dateUpdated: json["date_updated"] == null
            ? null
            : DateTime.parse(json["date_updated"]),
        addedBy: json["added_by"],
        updatedBy: json["updated_by"],
      );
}
