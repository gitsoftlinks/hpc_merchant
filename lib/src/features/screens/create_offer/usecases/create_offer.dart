// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:io';
import 'package:happiness_club_merchant/app/models/places_obj.dart';
import 'package:happiness_club_merchant/services/error/failure.dart';
import 'package:happiness_club_merchant/services/repository/repository.dart';
import 'package:happiness_club_merchant/services/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:happiness_club_merchant/utils/extensions/extensions.dart';
import 'package:equatable/equatable.dart';

/// This method will add new offer for product on server
/// Input: [CreateOfferParams] contains accessToken and create offer params
/// Output : [bool] returns true if operation is successful
/// if unsuccessful the response will be [Failure]
class CreateOfferResponse implements UseCase<bool, CreateOfferParams> {
  final Repository _repository;

  CreateOfferResponse(this._repository);

  @override
  Future<Either<Failure, bool>> call(CreateOfferParams params) {
    return _repository.createOffer(params);
  }
}

class CreateOfferParams extends Equatable {
  final String accessToken;

  String offerTitle;
  String offerDiscount;
  DateTime startDate;
  DateTime expiryDate;
  File offerImagePath;
  String shortDescription;
  String offerDescription;
  List<int> productidList;

  CreateOfferParams({
    required this.productidList,
    required this.offerTitle,
    required this.offerDiscount,
    required this.startDate,
    required this.offerImagePath,
    required this.expiryDate,
    required this.accessToken,
    required this.shortDescription,
    required this.offerDescription,
  });

  factory CreateOfferParams.withAccessToken(
          {required String accessToken, required CreateOfferParams params}) =>
      CreateOfferParams(
          offerTitle: params.offerTitle,
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
        'offer_image_path': offerImagePath.getFile(),
        'product_id[]': productidList
      };

  @override
  List<Object?> get props => [
        startDate,
        expiryDate,
        offerTitle,
        offerDescription,
        offerDiscount,
        productidList
      ];
}
