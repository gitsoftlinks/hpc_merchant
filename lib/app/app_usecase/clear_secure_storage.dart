import 'package:dartz/dartz.dart';

import '../../services/error/failure.dart';
import '../../services/repository/repository.dart';
import '../../services/usecases/usecase.dart';

/// This method cleans the secure storage of flutter
/// Output : if operation successful returns [bool] shows whether the operation is successful or not
/// if unsuccessful the response will be [Failure]
class ClearSecureStorage implements UseCase<bool, NoParams> {
  final Repository _repository;

  ClearSecureStorage(this._repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return _repository.clearSecureStorage(params);
  }
}
