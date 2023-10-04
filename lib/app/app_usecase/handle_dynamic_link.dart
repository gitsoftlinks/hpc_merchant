import 'package:dartz/dartz.dart';

import '../../services/error/failure.dart';
import '../../services/repository/repository.dart';
import '../../services/usecases/usecase.dart';

/// This use is used for handling dynamic link
class HandleDynamicLink implements InstantUseCase<NoParams, Uri> {
  Repository repository;

  HandleDynamicLink(this.repository);

  @override
  Either<Failure, NoParams> call(Uri params) {
    //repository.handleLink(params);
    return Right(NoParams());
  }
}
