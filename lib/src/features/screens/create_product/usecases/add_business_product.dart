import 'dart:io';

import 'package:dio/dio.dart';
import 'package:happiness_club_merchant/services/error/failure.dart';
import 'package:happiness_club_merchant/services/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../services/repository/repository.dart';

/// This method will add new product on server
/// Input: [AddBusinessProductParams] contains accessToken and businessId
/// Output : [bool] return true if operation is suucessful
/// if unsuccessful the response will be [Failure]
class AddBusinessProduct implements UseCase<bool, AddBusinessProductParams> {
  final Repository _repository;

  AddBusinessProduct(this._repository);

  @override
  Future<Either<Failure, bool>> call(AddBusinessProductParams params) {
    return _repository.addBusinessProduct(params);
  }

  Future<Either<Failure, bool>> updateProduct(EditProductParams productParams) {
    return _repository.updateProduct(productParams);
  }
}

class AddBusinessProductParams extends Equatable {
  final String accessToken;
  final int businessId;
  final String price;
  final List<dynamic> productLocations;

  final List<File> productImages;
  final String title;
  final String description;

  AddBusinessProductParams({
    required this.accessToken,
    required this.businessId,
    required this.price,
    required this.productLocations,
    required this.productImages,
    required this.title,
    required this.description,
  });

  factory AddBusinessProductParams.withAccessToken(
          {required String accessToken,
          required AddBusinessProductParams params}) =>
      AddBusinessProductParams(
        accessToken: accessToken,
        businessId: params.businessId,
        price: params.price,
        productLocations: params.productLocations,
        productImages: params.productImages,
        title: params.title,
        description: params.description,
      );

  Map<String, dynamic> toJson() => {
        'business_id': businessId,
        'product_price': price,
        'product_images[]': getFiles(productImages),
        'product_locations[]': productLocations,
        'product_title': title,
        'product_details': description,
      };

  @override
  List<Object?> get props => [businessId];
}

class EditProductParams extends Equatable {
  final String accessToken;
  final int businessId;
  final int id;
  final String price;
  final List<dynamic> productLocations;

  final List<File> productImages;
  final String title;
  final String description;

  EditProductParams({
    required this.accessToken,
    required this.businessId,
    required this.id,
    required this.price,
    required this.productLocations,
    required this.productImages,
    required this.title,
    required this.description,
  });

  factory EditProductParams.withAccessToken(
          {required String accessToken, required EditProductParams params}) =>
      EditProductParams(
        accessToken: accessToken,
        id: params.id,
        businessId: params.businessId,
        price: params.price,
        productLocations: params.productLocations,
        productImages: params.productImages,
        title: params.title,
        description: params.description,
      );

  Map<String, dynamic> toJson() => {
        'business_id': businessId,
        'product_price': price,
        'product_images[]': getFiles(productImages),
        'product_locations[]': productLocations,
        'product_title': title,
        'product_details': description,
      };

  @override
  List<Object?> get props => [businessId, id];
}

List<Object> getFiles(List<File> attachments) {
  List<Object> filesData = <Object>[];

  for (final file in attachments) {
    filesData.add(MultipartFile.fromFileSync(file.path));
  }
  return filesData;
}
