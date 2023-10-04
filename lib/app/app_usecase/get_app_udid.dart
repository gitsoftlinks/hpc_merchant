import 'package:dartz/dartz.dart';

import '../../services/error/failure.dart';
import '../../services/repository/repository.dart';
import '../../services/usecases/usecase.dart';

/// This method gives udid against
/// Output : if operation successful returns [String] returns UDID for the user
/// if unsuccessful the response will be [Failure]
class GetAppUDID implements UseCase<String, NoParams> {
  final Repository _repository;

  GetAppUDID(Repository repository) : _repository = repository;

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return await _repository.getUDID();
  }
}
