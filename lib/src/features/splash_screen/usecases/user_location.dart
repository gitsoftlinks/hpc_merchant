import 'package:dartz/dartz.dart';

import '../../../../services/error/failure.dart';
import '../../../../services/repository/repository.dart';
import '../../../../services/usecases/usecase.dart';

/// This method is used to get user location
/// Output: if successful the response will be [String] which represents users iso code
/// if unsuccessful the response will be [Failure]
class GetUserCountryISO implements UseCase<String, NoParams> {
  Repository repository;

  GetUserCountryISO(this.repository);

  @override
  Future<Either<Failure, String>> call(NoParams params) {
    return repository.getUserCountryISO();
  }
}
