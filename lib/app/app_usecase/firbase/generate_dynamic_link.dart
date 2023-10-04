import 'package:dartz/dartz.dart';

import '../../../../services/error/failure.dart';
import '../../../../services/repository/repository.dart';
import '../../../../services/usecases/usecase.dart';

/// This method will generate dynamic link on app
/// Input: [String] contains link to be share
/// Output : if operation successful returns [Uri] of the dynamic link
/// else returns [DynamicLinkFailure]
class GenerateDynamicLink implements UseCase<String, String> {
  Repository repository;

  GenerateDynamicLink(this.repository);

  @override
  Future<Either<Failure, String>> call(String params) {
    // TODO: implement call
    throw UnimplementedError();
  }

  // Future<Either<Failure, String>> call(String params) {
  //   return repository.generateDynamicLink(params);
  // }
}
