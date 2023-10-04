import 'package:dartz/dartz.dart';

import '../../../services/error/failure.dart';
import '../../../services/repository/repository.dart';
import '../../../services/usecases/usecase.dart';

/// This method will check if internet connection is available or not
/// output: [bool] if internet is available return true else false
class CheckInternetConnection implements UseCase<bool, NoParams>{
  final Repository _repository;

  CheckInternetConnection(this._repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return _repository.checkInternetConnection(params);
  }

}