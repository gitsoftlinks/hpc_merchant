// ignore_for_file: must_be_immutable

import 'package:happiness_club_merchant/services/error/failure.dart';
import 'package:happiness_club_merchant/services/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../../services/repository/repository.dart';

/// This method will get businesses detail by business legal Name from server
/// Input: [GetBusinessContractDownloadParams] contains accessToken and business legal name
/// Output : [GetBusinessContractDownloadResponse] contains Business response
/// if unsuccessful the response will be [Failure]
class GetBusinessContractDownload
    implements
        UseCase<GetBusinessContractDownloadResponse,
            GetBusinessContractDownloadParams> {
  final Repository _repository;

  GetBusinessContractDownload(this._repository);

  @override
  Future<Either<Failure, GetBusinessContractDownloadResponse>> call(
      GetBusinessContractDownloadParams params) {
    return _repository.getBusinessContractDownload(params);
  }
}

class GetBusinessContractDownloadParams extends Equatable {
  final String accessToken;
  final int businessId;

  const GetBusinessContractDownloadParams(
      {required this.accessToken, required this.businessId});

  factory GetBusinessContractDownloadParams.withAccessToken(
          {required String accessToken,
          required GetBusinessContractDownloadParams params}) =>
      GetBusinessContractDownloadParams(
          accessToken: accessToken, businessId: params.businessId);

  @override
  List<Object?> get props => [businessId];
}

class GetBusinessContractDownloadResponse {
  GetBusinessContractDownloadResponse({
    required this.path,
  });

  final String path;

  factory GetBusinessContractDownloadResponse.fromJson(
          Map<String, dynamic> json) =>
      GetBusinessContractDownloadResponse(
        path: json["path"],
      );

  Map<String, dynamic> toJson() => {
        "path": path,
      };
}

class BusinessContractDownload extends Equatable {
  String path;

  BusinessContractDownload({
    required this.path,
  });

  factory BusinessContractDownload.fromJson(Map<String, dynamic> json) =>
      BusinessContractDownload(path: json["path"]);

  Map<String, dynamic> toJson() => {
        "path": path,
      };

  @override
  List<Object?> get props => [path];
  BusinessContractDownload copyWith({
    String? path,
  }) {
    return BusinessContractDownload(
      path: path ?? this.path,
    );
  }
}
