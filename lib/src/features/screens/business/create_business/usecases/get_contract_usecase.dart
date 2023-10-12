// ignore_for_file: must_be_immutable

import 'package:happiness_club_merchant/services/error/failure.dart';
import 'package:happiness_club_merchant/services/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../../services/repository/repository.dart';

/// This method will get businesses detail by business legal Name from server
/// Input: [GetBusinessContractParams] contains accessToken and business legal name
/// Output : [GetBusinessContractResponse] contains Business response
/// if unsuccessful the response will be [Failure]
class GetBusinessContract
    implements UseCase<GetBusinessContractResponse, GetBusinessContractParams> {
  final Repository _repository;

  GetBusinessContract(this._repository);

  @override
  Future<Either<Failure, GetBusinessContractResponse>> call(
      GetBusinessContractParams params) {
    return _repository.getBusinessContract(params);
  }
}

class GetBusinessContractParams extends Equatable {
  final String accessToken;
  final String businessLegalName;

  const GetBusinessContractParams(
      {required this.accessToken, required this.businessLegalName});

  factory GetBusinessContractParams.withAccessToken(
          {required String accessToken,
          required GetBusinessContractParams params}) =>
      GetBusinessContractParams(
          accessToken: accessToken,
          businessLegalName: params.businessLegalName);

  @override
  List<Object?> get props => [businessLegalName];
}

class GetBusinessContractResponse {
  GetBusinessContractResponse({
    required this.content,
  });

  final String content;

  factory GetBusinessContractResponse.fromJson(Map<String, dynamic> json) =>
      GetBusinessContractResponse(
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "content": content,
      };
}

class BusinessContract extends Equatable {
  String content;

  BusinessContract({
    required this.content,
  });

  factory BusinessContract.fromJson(Map<String, dynamic> json) =>
      BusinessContract(content: json["content"]);

  Map<String, dynamic> toJson() => {
        "content": content,
      };

  @override
  List<Object?> get props => [content];
  BusinessContract copyWith({
    String? content,
  }) {
    return BusinessContract(
      content: content ?? this.content,
    );
  }
}
