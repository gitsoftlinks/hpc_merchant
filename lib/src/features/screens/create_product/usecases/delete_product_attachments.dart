import 'package:happiness_club_merchant/services/error/failure.dart';
import 'package:happiness_club_merchant/services/repository/repository.dart';
import 'package:happiness_club_merchant/services/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

/// This method will remove product images  on server
/// Input: [DeleteProductAttachmentsParams] contains accessToken and attachmentId
/// Output : [bool] returns true if operation is successful
/// if unsuccessful the response will be [Failure]
class DeleteProductAttachments
    implements UseCase<bool, DeleteProductAttachmentsParams> {
  final Repository _repository;

  DeleteProductAttachments(this._repository);

  @override
  Future<Either<Failure, bool>> call(DeleteProductAttachmentsParams params) {
    return _repository.deleteProductAttachments(params);
  }
}

class DeleteProductAttachmentsParams extends Equatable {
  final String accessToken;
  final int attachmentId;

  const DeleteProductAttachmentsParams({
    required this.accessToken,
    required this.attachmentId,
  });

  factory DeleteProductAttachmentsParams.withAccessToken(
          {required String accessToken,
          required DeleteProductAttachmentsParams params}) =>
      DeleteProductAttachmentsParams(
          accessToken: accessToken, attachmentId: params.attachmentId);

  @override
  List<Object?> get props => [attachmentId];
}
