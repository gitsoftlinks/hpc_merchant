

import 'package:dartz/dartz.dart';

import '../../services/error/failure.dart';
import '../../services/repository/repository.dart';
import '../../services/usecases/usecase.dart';

/// This method returns the path of the image selected by the user
/// Output : if operation successful returns [String] path of the user selected file
/// if unsuccessful the response will be [Failure]
class PickImageFromGallery implements UseCase<String, NoParams> {
  final Repository _repository;

  PickImageFromGallery(Repository repository) : _repository = repository;

  @override
  Future<Either<Failure, String>> call(NoParams params) {
    return _repository.pickImageFromGallery(params);
  }
}
