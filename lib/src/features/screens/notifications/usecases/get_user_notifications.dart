import 'dart:convert';

import 'package:happiness_club_merchant/services/error/failure.dart';
import 'package:happiness_club_merchant/services/repository/repository.dart';
import 'package:happiness_club_merchant/services/usecases/usecase.dart';
import 'package:happiness_club_merchant/src/features/screens/signin_screen/usecases/send_login.dart';
import 'package:happiness_club_merchant/utils/constants/notification_type_enum.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

/// This method will get all notifications of the user
/// Input: [NoParams] contains accessToken later on
/// Output : List[UserNotification] contains list of all notifications
/// if unsuccessful the response will be [Failure]
class GetUserNotification implements UseCase<List<UserNotification>, NoParams> {
  final Repository _repository;

  GetUserNotification(this._repository);

  @override
  Future<Either<Failure, List<UserNotification>>> call(NoParams params) {
    return _repository.getUserNotifications();
  }
}

class UserNotification extends Equatable {
  UserNotification(
      {required this.id,
      required this.fromUserId,
      required this.toUserId,
      required this.title,
      required this.detail,
      required this.actionIds,
      required this.toFcmToken,
      required this.notificationType,
      required this.pushStatus,
      required this.notificationReadStatus,
      required this.firebaseRequest,
      required this.firebaseResponse,
      required this.createdAt,
      required this.updatedAt,
      required this.dateAdded,
      required this.addedBy,
      required this.updatedBy,
      required this.dateUpdated,
      required this.fromuserdetails,
      this.categoryId,
      this.postId,
      this.postlink});

  final int id;
  final int fromUserId;
  final int toUserId;
  final String title;
  final String detail;
  final String actionIds;
  final dynamic categoryId;
  final dynamic postId;
  final String? toFcmToken;
  final NotificationTypeEnum notificationType;
  final int pushStatus;
  int notificationReadStatus;
  final String firebaseRequest;
  final String firebaseResponse;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? dateAdded;
  final int addedBy;
  final dynamic updatedBy;
  final DateTime? dateUpdated;
  final UserData fromuserdetails;
  final dynamic postlink;

  factory UserNotification.fromJson(Map<String, dynamic> json) =>
      UserNotification(
        id: json["id"],
        fromUserId: json["from_user_id"],
        toUserId: json["to_user_id"],
        title: json["title"],
        detail: json["detail"],
        actionIds: json["action_ids"],
        toFcmToken: json["to_fcm_token"],
        notificationType:
            json["notification_type"].toString().toNotificationTypeEnum(),
        pushStatus: json["push_status"],
        notificationReadStatus: json["notification_read_status"],
        firebaseRequest: json["firebase_request"],
        firebaseResponse: json["firebase_response"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        dateAdded: json["date_added"] == null
            ? null
            : DateTime.parse(json["date_added"]),
        dateUpdated: json["date_updated"] == null
            ? null
            : DateTime.parse(json["date_updated"]),
        addedBy: json["added_by"],
        updatedBy: json["updated_by"],
        fromuserdetails: UserData.fromJson(json["fromuserdetails"]),
        postlink: jsonDecode(json["action_ids"])['post_link'] ?? '',
        categoryId: jsonDecode(json["action_ids"])['category_id'] ?? '',
        postId: jsonDecode(json["action_ids"])['post_id'] ?? '',
      );

  @override
  List<Object?> get props => [
        id,
        fromUserId,
        toUserId,
        title,
        detail,
        actionIds,
        categoryId,
        postId,
        toFcmToken,
        notificationType,
        pushStatus,
        notificationReadStatus,
        firebaseRequest,
        firebaseResponse,
        createdAt,
        updatedAt,
        dateAdded,
        addedBy,
        updatedBy,
        dateUpdated,
        fromuserdetails
      ];

  @override
  String toString() {
    return 'UserNotification{id=$id, fromUserId=$fromUserId, toUserId=$toUserId, title=$title, detail=$detail, actionIds=$actionIds, categoryId=$categoryId, postId=$postId, toFcmToken=$toFcmToken, notificationType=$notificationType, pushStatus=$pushStatus, notificationReadStatus=$notificationReadStatus, firebaseRequest=$firebaseRequest, firebaseResponse=$firebaseResponse, createdAt=$createdAt, updatedAt=$updatedAt, dateAdded=$dateAdded, addedBy=$addedBy, updatedBy=$updatedBy, dateUpdated=$dateUpdated, fromuserdetails=$fromuserdetails}';
  }
}
