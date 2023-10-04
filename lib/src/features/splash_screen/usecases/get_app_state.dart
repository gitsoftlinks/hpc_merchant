import 'package:dartz/dartz.dart';

import '../../../../services/error/failure.dart';
import '../../../../services/repository/repository.dart';
import '../../../../services/usecases/usecase.dart';
import '../../../../utils/constants/app_state_enum.dart';

/// This method is used to get user app state
/// Output: if successful the response will be [AppStateEnum]
/// if unsuccessful the response will be [Failure]
class GetAppState implements UseCase<AppStateEnum, NoParams> {
  //

  final Repository _repository;

  GetAppState(Repository repository) : _repository = repository;

  @override
  Future<Either<Failure, AppStateEnum>> call(NoParams params) {
    return _repository.getAppState();
  }
}
