import 'package:happiness_club_merchant/app/app_usecase/pick_multi_images_from_gallery.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:images_picker/images_picker.dart';

import '../../services/error/failure.dart';
import '../../services/repository/repository.dart';
import '../../services/usecases/usecase.dart';

/// This method should image path from gallery or not
/// Output : if operation successful returns [String] get the image path
/// if unsuccessful the response will be [Failure]
class GetImageFromCamera implements UseCase<List<MediaResponse>, GetImageFromCameraParams> {
  final Repository _repository;

  GetImageFromCamera(this._repository);

  @override
  Future<Either<Failure, List<MediaResponse>>> call(GetImageFromCameraParams params) {
    return _repository.getImageFromCamera(params);
  }
}

class GetImageFromCameraParams extends Equatable {
  final int? maxSize;
  final double quality;
  final int maxTime;
  final PickType pickType;

  const GetImageFromCameraParams({this.maxSize, required this.quality, required this.maxTime, required this.pickType});

  @override
  List<Object?> get props => [
        maxSize,
        maxTime,
        quality,
        pickType,
      ];
}
