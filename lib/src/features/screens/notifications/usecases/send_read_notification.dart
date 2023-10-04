import 'package:happiness_club_merchant/services/error/failure.dart';
import 'package:happiness_club_merchant/services/repository/repository.dart';
import 'package:happiness_club_merchant/services/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

/// This method will send read status on notification to server
/// Input: [SendReadNotificationParams] contains notificationId and accessToken
/// Output : [bool] return true if successful else false
/// if unsuccessful the response will be [Failure]
class SendReadNotification
    implements UseCase<bool, SendReadNotificationParams> {
  final Repository _repository;

  SendReadNotification(this._repository);

  @override
  Future<Either<Failure, bool>> call(SendReadNotificationParams params) {
    // TODO: implement call
    throw UnimplementedError();
  }

  // Future<Either<Failure, bool>> call(SendReadNotificationParams params) {
  //   return _repository.sendReadNotification(params);
  // }
}

class SendReadNotificationParams extends Equatable {
  final String accessToken;
  final List<int> notificationIds;

  const SendReadNotificationParams(
      {required this.accessToken, required this.notificationIds});

  factory SendReadNotificationParams.withAccessToken(
          {required String accessToken,
          required SendReadNotificationParams params}) =>
      SendReadNotificationParams(
          accessToken: accessToken, notificationIds: params.notificationIds);

  Map<String, dynamic> toJson() => {'notification_ids': notificationIds};

  @override
  List<Object?> get props => [notificationIds];
}
