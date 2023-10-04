import 'package:dartz/dartz.dart';

import '../../../../services/error/failure.dart';
import '../../../../services/repository/repository.dart';
import '../../../../services/usecases/usecase.dart';

/// This method logout the user from the local auth
/// Output : if operation successful returns [bool] tells whether the operation is successful or not
/// if unsuccessful the response will be [Failure]
class LogoutUser implements UseCase<bool, NoParams> {
  Repository repository;

  LogoutUser(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return repository.logoutUser();
  }
}
