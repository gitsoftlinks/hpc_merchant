import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../services/error/failure.dart';
import '../../services/repository/repository.dart';
import '../../services/usecases/usecase.dart';

/// This method changes the language of the app as selected by the user.
/// Input: [changeLanguageParams] contains culture and uiCulture
/// Output: if operation successful returns [bool] tells user that language has been changed successfully.
/// if unsuccessful the response will be [Failure]
class SwitchCulture extends UseCase<bool, SwitchCultureParams> {
  final Repository repository;
  SwitchCulture(this.repository);

  @override
  Future<Either<Failure, bool>> call(SwitchCultureParams params) {
    return repository.switchCulture(params);
  }

}

class SwitchCultureParams extends Equatable {
  final String culture;
  final String uiCulture;
  const SwitchCultureParams({required this.culture, required this.uiCulture});

  SwitchCultureParams withToken(String token) => SwitchCultureParams(culture: culture, uiCulture: token);

  Map<String, dynamic> toJson() => {
    'culture': culture,
    'uiCulture': uiCulture,
  };

  @override
  List<Object?> get props => [culture, uiCulture];
}