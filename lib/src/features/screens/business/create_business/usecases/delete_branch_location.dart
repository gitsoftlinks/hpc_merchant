import 'package:happiness_club_merchant/services/error/failure.dart';
import 'package:happiness_club_merchant/services/repository/repository.dart';
import 'package:happiness_club_merchant/services/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

/// This method will remove branch locations of business on server
/// Input: [DeletePostAttachmentsParams] contains accessToken and attachmentId
/// Output : [bool] returns true if operation is successful
/// if unsuccessful the response will be [Failure]
class DeleteBranchLocationAttachments
    implements UseCase<bool, DeleteBranchLocationAttachmentsParams> {
  final Repository _repository;

  DeleteBranchLocationAttachments(this._repository);

  @override
  Future<Either<Failure, bool>> call(
      DeleteBranchLocationAttachmentsParams params) {
    return _repository.deleteBranchLocationAttachments(params);
  }
}

class DeleteBranchLocationAttachmentsParams extends Equatable {
  final String accessToken;
  final int attachmentId;

  const DeleteBranchLocationAttachmentsParams({
    required this.accessToken,
    required this.attachmentId,
  });

  factory DeleteBranchLocationAttachmentsParams.withAccessToken(
          {required String accessToken,
          required DeleteBranchLocationAttachmentsParams params}) =>
      DeleteBranchLocationAttachmentsParams(
          accessToken: accessToken, attachmentId: params.attachmentId);

  @override
  List<Object?> get props => [attachmentId];
}
