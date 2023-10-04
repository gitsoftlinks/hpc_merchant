
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:images_picker/images_picker.dart';

import '../../services/error/failure.dart';
import '../../services/repository/repository.dart';
import '../../services/usecases/usecase.dart';

/// This method returns the path of the image selected by the user
/// Output : if operation successful returns [MediaResponse] path of the user selected file and thumb path
/// if unsuccessful the response will be [Failure]
class PickMultipleImagesFromGallery implements UseCase<List<MediaResponse>, PickType> {
  final Repository _repository;

  PickMultipleImagesFromGallery(Repository repository) : _repository = repository;

  @override
  Future<Either<Failure, List<MediaResponse>>> call(PickType params) {
    return _repository.pickMultipleImagesFromGallery(params);
  }
}

class MediaResponse extends Equatable{
  final String filePath;
  final String? thumbPath;
  final double size;

  const MediaResponse({required this.filePath, required this.thumbPath, required this.size});

  factory MediaResponse.fromString({required String filePath, required String? thumbPath, required double size}) => MediaResponse(
    filePath: filePath,
    thumbPath: thumbPath,
      size: size
  );

  @override
  List<Object?> get props => [filePath, thumbPath];
}