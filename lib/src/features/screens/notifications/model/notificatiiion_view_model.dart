import 'package:happiness_club_merchant/app/providers/account_provider.dart';
import 'package:happiness_club_merchant/services/usecases/usecase.dart';
import 'package:happiness_club_merchant/utils/extensions/extensions.dart';
import 'package:happiness_club_merchant/utils/globals.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../../app/app_usecase/firbase/generate_dynamic_link.dart';
import '../../../../../services/error/failure.dart';
import '../../../../../utils/constants/dynamic_link_constants.dart';
import '../../../../../utils/constants/notification_type_enum.dart';
import '../../../../../utils/router/app_state.dart';
import '../usecases/get_user_notifications.dart';
import '../usecases/send_read_notification.dart';

class NotificationViewModel extends ChangeNotifier {
  final GetUserNotification _getUserNotification;
  final AppState _appState;
  final SendReadNotification _sendReadNotification;
  final GenerateDynamicLink _generateDynamicLink;
  NotificationViewModel(
      {required GetUserNotification getUserNotification,
      required AppState appState,
      required GenerateDynamicLink generateDynamicLink,
      required SendReadNotification sendReadNotification})
      : _getUserNotification = getUserNotification,
        _appState = appState,
        _sendReadNotification = sendReadNotification,
        _generateDynamicLink = generateDynamicLink;

  ValueChanged<String>? errorMessages;
  bool showShimmer = true;
  List<UserNotification> notifications = [];

  void handleError(Either<Failure, dynamic> either) {
    showShimmer = false;
    notifyListeners();
    either.fold((l) {
      l.checkAndTakeAction(onError: errorMessages);
    }, (r) => null);
  }

  void init() async {
    showShimmer = true;
    // GetIt.I.get<AccountProvider>().clearNotifications();
    await getNotifications();
  }

  Future<void> getNotifications() async {
    var getNotificationsEither = await _getUserNotification.call(NoParams());
    if (getNotificationsEither.isLeft()) {
      handleError(getNotificationsEither);
      return;
    }

    notifications = getNotificationsEither.toOption().toNullable()!;

    showShimmer = false;

    notifyListeners();
  }

  void onClickShareButton(
      {int? postId, int? categoryId, String? postTitle, String? link1}) async {
    if (link1?.isNotEmpty ?? false) {
      //  launchUrl(Uri.parse(link1!), mode: LaunchMode.externalApplication);
      return;
    }
    var linkToGen =
        '/${DynamicLinkQueryConstants.postDetail}?category_id=$categoryId&post_id=$postId';

    var generateLinkEither = await _generateDynamicLink.call(linkToGen);

    if (generateLinkEither.isLeft()) {
      handleError(generateLinkEither);
      return;
    }

    var link = generateLinkEither.getOrElse(() => '');

    // launchUrl(Uri.parse(link), mode: LaunchMode.externalApplication);
  }

  void onTapNotification({required UserNotification notification}) async {
    //

    dp("Notification", notification.categoryId);

    dp("Notification", notification.postId);

    if (notification.categoryId.toString().isNotEmpty &&
        notification.postId.toString().isNotEmpty) {
      onClickShareButton(
          categoryId: int.parse(notification.categoryId.toString()),
          postId: int.parse(notification.postId.toString()),
          postTitle: '');
    } else {
      onClickShareButton(link1: notification.postlink);
    }

    await callNotificationRead(notification);

    switch (notification.notificationType) {
      case NotificationTypeEnum.none:
        // TODO: Handle this case.
        break;
      case NotificationTypeEnum.post_like:
        // var detail = json.decode(notification.actionIds);
        // _appState.currentAction =
        // PageAction(state: PageState.addPage, page: PageConfiguration.withArguments(PostDetailsScreenConfig, {'postId': detail.post_id, 'categoryId': post.categoryId, 'isCommentClicked': false}));
        break;
      case NotificationTypeEnum.post_dislike:
        // TODO: Handle this case.
        break;
      case NotificationTypeEnum.post_comment:
        // TODO: Handle this case.
        break;
      case NotificationTypeEnum.post_comment_reply:
        // TODO: Handle this case.
        break;
      case NotificationTypeEnum.post_share:
        // TODO: Handle this case.
        break;
      case NotificationTypeEnum.business_product_bought:
        // TODO: Handle this case.
        break;
      case NotificationTypeEnum.friend_request:
        // TODO: Handle this case.
        break;
    }
  }

  Future<void> callNotificationRead(UserNotification notification) async {
    var params = SendReadNotificationParams(
        accessToken: '', notificationIds: [notification.id]);
    var sendReadEither = await _sendReadNotification.call(params);
    if (sendReadEither.isLeft()) {
      handleError(sendReadEither);
      return;
    }

    notifications[notifications
            .indexWhere((element) => element.id == notification.id)]
        .notificationReadStatus = 1;
    var counter = 0;
    for (UserNotification item in notifications) {
      if (item.notificationReadStatus == 0) {
        counter++;
      }
    }
    GetIt.I
        .get<AccountProvider>()
        .updateNotificationCounter(notificationCounter: counter);

    // GetIt.I.get<AccountProvider>().unreadNotifications = notifications .
    notifyListeners();
  }
}
