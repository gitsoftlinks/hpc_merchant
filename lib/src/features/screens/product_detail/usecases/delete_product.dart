import 'package:happiness_club_merchant/services/error/failure.dart';
import 'package:happiness_club_merchant/services/repository/repository.dart';
import 'package:happiness_club_merchant/services/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

/// This method will remove product on server
/// Input: [DeleteProductParams] contains accessToken and productId
/// Output : [bool] returns true if operation is successful
/// if unsuccessful the response will be [Failure]
class DeleteProduct implements UseCase<bool, DeleteProductParams> {
  final Repository _repository;

  DeleteProduct(this._repository);

  @override
  Future<Either<Failure, bool>> call(DeleteProductParams params) {
    return _repository.deleteProduct(params);
  }
}

class DeleteProductParams extends Equatable {
  final String accessToken;
  final int productId;

  const DeleteProductParams({
    required this.accessToken,
    required this.productId,
  });

  factory DeleteProductParams.withAccessToken({required String accessToken, required DeleteProductParams params}) =>
      DeleteProductParams(accessToken: accessToken, productId: params.productId);

  @override
  List<Object?> get props => [productId];
}
