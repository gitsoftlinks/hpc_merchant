// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:happiness_club_merchant/utils/extensions/extensions.dart';

import '../../../../../services/error/failure.dart';
import '../../../../../services/repository/repository.dart';
import '../../../../../services/usecases/usecase.dart';

/// This method will edit offer on server
/// Input: [EditsProductOfferParams] contains accessToken and edit offer params
/// Output : [bool] returns true if operation is successful
/// if unsuccessful the response will be [Failure]
class EditProductOffer implements UseCase<bool, EditsProductOfferParams> {
  final Repository _repository;

  EditProductOffer(this._repository);

  @override
  Future<Either<Failure, bool>> call(EditsProductOfferParams params) {
    return _repository.updateOffer(params);
  }
}

class EditsProductOfferParams extends Equatable {
  final String accessToken;
  int id;
  String offerTitle;
  String offerDiscount;
  DateTime startDate;
  DateTime expiryDate;
  File? offerImagePath;
  String shortDescription;
  String offerDescription;
  List<int> productidList;

  EditsProductOfferParams({
    required this.productidList,
    required this.id,
    required this.offerTitle,
    required this.offerDiscount,
    required this.startDate,
    this.offerImagePath,
    required this.expiryDate,
    required this.accessToken,
    required this.shortDescription,
    required this.offerDescription,
  });

  factory EditsProductOfferParams.withAccessToken(
          {required String accessToken,
          required EditsProductOfferParams params}) =>
      EditsProductOfferParams(
          offerTitle: params.offerTitle,
          id: params.id,
          accessToken: accessToken,
          startDate: params.startDate,
          productidList: params.productidList,
          expiryDate: params.expiryDate,
          offerImagePath: params.offerImagePath,
          offerDescription: params.offerDescription,
          shortDescription: params.shortDescription,
          offerDiscount: params.offerDiscount);

  Map<String, dynamic> toJson() => {
        'offer_title': offerTitle,
        'offer_discount': offerDiscount,
        'start_date': startDate,
        'expiry_date': expiryDate,
        'short_description': shortDescription,
        'offer_description': offerDescription,
        'offer_image_path':
            offerImagePath == null ? null : offerImagePath!.getFile(),
        'product_id[]': productidList
      };
  List<Object?> get props => [id];
}
