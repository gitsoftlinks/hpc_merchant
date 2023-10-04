import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../services/error/failure.dart';
import '../../services/repository/repository.dart';
import '../../services/usecases/usecase.dart';

/// This method will get selected language of the user from local storage.
/// Output: [CultureGetResponse] contains culture and uiCulture
/// if unsuccessful the response will be [Failure]
class CultureGet extends UseCase<CultureGetResponse, NoParams> {
  final Repository repository;
  CultureGet(this.repository);

  @override
  Future<Either<Failure, CultureGetResponse>> call(NoParams params) {
    return repository.cultureGet();
  }

}

class CultureGetResponse extends Equatable {
  final String culture;
  final String uiCulture;

  const CultureGetResponse({required this.culture, required this.uiCulture});

  factory CultureGetResponse.empty(){
    return const CultureGetResponse(culture: '', uiCulture: '');
  }

  factory CultureGetResponse.fromJson(Map<String, dynamic> json){
    return CultureGetResponse(culture: json['culture'], uiCulture: json['uiCulture']);
  }

  @override
  List<Object?> get props => [culture, uiCulture];
}