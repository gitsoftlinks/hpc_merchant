import 'package:dartz/dartz.dart';

import '../../services/error/failure.dart';
import '../../services/repository/repository.dart';
import '../../services/usecases/usecase.dart';

/// This method generates a new UDID and also saves it in the local storage
/// Output : if operation successful returns [bool] shows success of failure of the operation
/// if unsuccessful the response will be [Failure]
class GenerateUDID implements UseCase<String, NoParams> {
  final Repository _repository;

  GenerateUDID(Repository repository) : _repository = repository;

  @override
  Future<Either<Failure, String>> call(NoParams params) {
    return _repository.generateUDID();
  }
}
