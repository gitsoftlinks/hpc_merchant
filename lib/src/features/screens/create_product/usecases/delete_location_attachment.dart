import 'package:happiness_club_merchant/services/error/failure.dart';
import 'package:happiness_club_merchant/services/repository/repository.dart';
import 'package:happiness_club_merchant/services/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

/// This method will remove product locations on server
/// Input: [DeleteProductLocationAttachmentsParams] contains accessToken and attachmentId
/// Output : [bool] returns true if operation is successful
/// if unsuccessful the response will be [Failure]
class DeleteProductLocationAttachments
    implements UseCase<bool, DeleteProductLocationAttachmentsParams> {
  final Repository _repository;

  DeleteProductLocationAttachments(this._repository);

  @override
  Future<Either<Failure, bool>> call(
      DeleteProductLocationAttachmentsParams params) {
    return _repository.deleteProductLocationAttachments(params);
  }
}

class DeleteProductLocationAttachmentsParams extends Equatable {
  final String accessToken;
  final int attachmentId;

  const DeleteProductLocationAttachmentsParams({
    required this.accessToken,
    required this.attachmentId,
  });

  factory DeleteProductLocationAttachmentsParams.withAccessToken(
          {required String accessToken,
          required DeleteProductLocationAttachmentsParams params}) =>
      DeleteProductLocationAttachmentsParams(
          accessToken: accessToken, attachmentId: params.attachmentId);

  @override
  List<Object?> get props => [attachmentId];
}
