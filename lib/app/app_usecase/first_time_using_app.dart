import 'package:dartz/dartz.dart';

import '../../services/error/failure.dart';
import '../../services/repository/repository.dart';
import '../../services/usecases/usecase.dart';

/// This method returns true if the user is using app for the first time. This method should be only use for ios
/// Output : if operation successful returns [bool] shows whether the app is used first time or not
/// if unsuccessful the response will be [Failure]
class IsFirstTimeUsingTheApp implements UseCase<bool, NoParams> {
  final Repository _repository;

  IsFirstTimeUsingTheApp(this._repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return _repository.getIsFirstTimeUsingApp(params);
  }
}
