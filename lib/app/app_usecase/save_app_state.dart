import 'package:dartz/dartz.dart';

import '../../services/error/failure.dart';
import '../../services/repository/repository.dart';
import '../../services/usecases/usecase.dart';
import '../../utils/constants/app_state_enum.dart';

/// This use case is used for saving app state [AppStateEnum] in the secure storage
class SaveAppState implements UseCase<bool, AppStateEnum> {
  final Repository _repository;

  SaveAppState(Repository repository) : _repository = repository;

  @override
  Future<Either<Failure, bool>> call(AppStateEnum params) async {
    return await _repository.saveUserAppState(params);
  }
}
