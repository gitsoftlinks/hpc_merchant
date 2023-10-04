import 'package:happiness_club_merchant/services/error/failure.dart';
import 'package:happiness_club_merchant/services/repository/repository.dart';
import 'package:happiness_club_merchant/services/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';


/// This method will send settings data to server
/// Input: [SendSettingsParams] contains email and password
/// Output : [bool] return true if successful
/// if unsuccessful the response will be [Failure]
class SendSettings extends UseCase<bool, SendSettingsParams>{
  final Repository _repository;

  SendSettings(this._repository);

  @override
  Future<Either<Failure, bool>> call(SendSettingsParams params) {
    return _repository.sendSettings(params);
  }
}


class SendSettingsParams extends Equatable{
  final String accessToken;
  final SettingOptionsEnum property;
  final String status;

  const SendSettingsParams({required this.accessToken, required this.property, required this.status});

  factory SendSettingsParams.withAccessToken({required String accessToken, required SendSettingsParams params}) =>
      SendSettingsParams(accessToken: accessToken, property: params.property, status: params.status);

  @override
  List<Object?> get props => [property, status];

  Map<String, dynamic> toJson() => {
    "property": property.name,
    "property_status": status,
  };
}

enum SettingOptionsEnum { none, is_notification_allowed, is_visible, is_deleted, is_deactivate_account }

extension SettingOptionsEnumPar on String {
  SettingOptionsEnum toSettingOptionsEnum() {
    return SettingOptionsEnum.values.firstWhere((e) => e.toString().toLowerCase() == 'SettingOptionsEnum.$this'.toLowerCase(), orElse: () => SettingOptionsEnum.none);
  }
}
