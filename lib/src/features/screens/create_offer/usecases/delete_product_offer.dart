import 'package:happiness_club_merchant/services/error/failure.dart';
import 'package:happiness_club_merchant/services/repository/repository.dart';
import 'package:happiness_club_merchant/services/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

/// This method will remove products from offer on server
/// Input: [DeleteProductOfferAttachmentsParams] contains accessToken and attachmentId
/// Output : [bool] returns true if operation is successful
/// if unsuccessful the response will be [Failure]
class DeleteProductOfferAttachments
    implements UseCase<bool, DeleteProductOfferAttachmentsParams> {
  final Repository _repository;

  DeleteProductOfferAttachments(this._repository);

  @override
  Future<Either<Failure, bool>> call(
      DeleteProductOfferAttachmentsParams params) {
    return _repository.deleteProductOfferAttachments(params);
  }
}

class DeleteProductOfferAttachmentsParams extends Equatable {
  final String accessToken;
  final int attachmentId;

  const DeleteProductOfferAttachmentsParams({
    required this.accessToken,
    required this.attachmentId,
  });

  factory DeleteProductOfferAttachmentsParams.withAccessToken(
          {required String accessToken,
          required DeleteProductOfferAttachmentsParams params}) =>
      DeleteProductOfferAttachmentsParams(
          accessToken: accessToken, attachmentId: params.attachmentId);

  @override
  List<Object?> get props => [attachmentId];
}
