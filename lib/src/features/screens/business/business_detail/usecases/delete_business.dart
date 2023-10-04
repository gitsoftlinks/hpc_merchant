import 'package:happiness_club_merchant/services/error/failure.dart';
import 'package:happiness_club_merchant/services/repository/repository.dart';
import 'package:happiness_club_merchant/services/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

/// This method will remove business on server
/// Input: [DeleteBusinessParams] contains accessToken and businessId
/// Output : [bool] returns true if operation is successful
/// if unsuccessful the response will be [Failure]
class DeleteBusiness implements UseCase<bool, DeleteBusinessParams> {
  final Repository _repository;

  DeleteBusiness(this._repository);

  @override
  Future<Either<Failure, bool>> call(DeleteBusinessParams params) {
    return _repository.deleteBusiness(params);
  }
}

class DeleteBusinessParams extends Equatable {
  final String accessToken;
  final int businessId;

  const DeleteBusinessParams({
    required this.accessToken,
    required this.businessId,
  });

  factory DeleteBusinessParams.withAccessToken({required String accessToken, required DeleteBusinessParams params}) =>
      DeleteBusinessParams(accessToken: accessToken, businessId: params.businessId);

  @override
  List<Object?> get props => [businessId];
}
