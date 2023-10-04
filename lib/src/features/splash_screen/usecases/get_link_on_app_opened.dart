import 'package:dartz/dartz.dart';

import '../../../../services/error/failure.dart';
import '../../../../services/repository/repository.dart';
import '../../../../services/usecases/usecase.dart';

/// This method gives link with which the app is opened
/// Output : if operation successful returns [Uri] of the dynamic link
/// else returns [DynamicLinkFailure]
class GetAppLinkOnAppOpened implements UseCase<Uri, NoParams> {
  Repository repository;

  GetAppLinkOnAppOpened(this.repository);

  @override
  Future<Either<Failure, Uri>> call(NoParams params) {
    return repository.getAppLinkWhichOpened();
  }
}
