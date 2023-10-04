import 'package:dartz/dartz.dart';

import '../../services/error/failure.dart';
import '../../services/repository/repository.dart';
import '../../services/usecases/usecase.dart';
import '../models/get_app_info.dart';

/// This method returns Info of the app
/// Output : if operation successful returns [AppInfo] which contains info regarding app
/// if unsuccessful the response will be [Failure]
class GetAppInfo implements UseCase<AppInfo, NoParams> {
  Repository repository;

  GetAppInfo(this.repository);

  @override
  Future<Either<Failure, AppInfo>> call(NoParams params) async {
    return await repository.getAppInfo();
  }
}
