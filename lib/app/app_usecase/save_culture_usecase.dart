import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../services/error/failure.dart';
import '../../services/repository/repository.dart';
import '../../services/usecases/usecase.dart';

/// This method will save the selected language of the user to localStorage.
/// Input: [CultureSaveParams] contains culture and uiCulture
/// Output: if operation successful returns [bool] tells user that language has been changed successfully.
/// if unsuccessful the response will be [Failure]
class CultureSave extends UseCase<bool, CultureSaveParams> {
  final Repository repository;
  CultureSave(this.repository);

  @override
  Future<Either<Failure, bool>> call(CultureSaveParams params) {
    return repository.cultureSave(params);
  }

}

class CultureSaveParams extends Equatable {
  final String culture;
  final String uiCulture;
  const CultureSaveParams({required this.culture, required this.uiCulture});

  Map<String, dynamic> toJson() => {
    'culture': culture,
    'uiCulture': uiCulture,
  };

  @override
  List<Object?> get props => [culture, uiCulture];
}