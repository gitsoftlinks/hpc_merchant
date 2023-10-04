import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:happiness_club_merchant/services/error/failure.dart';
import 'package:happiness_club_merchant/services/repository/repository.dart';
import 'package:happiness_club_merchant/services/usecases/usecase.dart';

/// This usecase will upload document to server
/// Output: [String] contains url of the file
/// Input: [UploadAttachmentParams] contains fileName, content and accessToken
/// if unsuccessful the response will be [Failure]
class UploadAttachment extends UseCase<String, UploadAttachmentParams> {
  final Repository _repository;

  UploadAttachment(this._repository);

  @override
  Future<Either<Failure, String>> call(UploadAttachmentParams params) {
    // TODO: implement call
    throw UnimplementedError();
  }
}

class UploadAttachmentParams extends Equatable {
  final String fileName;
  final String content;
  final String accessToken;

  const UploadAttachmentParams(
      {required this.fileName,
      required this.content,
      required this.accessToken});

  factory UploadAttachmentParams.withAccessToken(
      {required String accessToken, required UploadAttachmentParams params}) {
    return UploadAttachmentParams(
        fileName: params.fileName,
        content: params.content,
        accessToken: accessToken);
  }

  Map<String, dynamic> toJson() => {'fileName': fileName, 'content': content};

  @override
  List<Object?> get props => [fileName, content];
}
