// import 'dart:async';
// import 'dart:convert';

// import 'package:happiness_club_merchant/app/providers/account_provider.dart';
// import 'package:happiness_club_merchant/utils/router/app_state.dart';
// import 'package:happiness_club_merchant/utils/router/models/page_action.dart';
// //import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get_it/get_it.dart';
// import 'package:logger/logger.dart';
// import 'package:happiness_club_merchant/utils/extensions/extensions.dart';

// import '../../app/models/pending_action_forwarder.dart';
// import '../../app/models/user_runtime_config.dart';
// import '../../utils/constants/notification_type_enum.dart';
// import '../../utils/router/models/page_config.dart';
// import '../../utils/router/ui_pages.dart';
// import '../dynamic_link_core_logic/usecases/save_pending_action.dart';
// import '../error/failure.dart';

// /// This class will act as a view model for the notifications
// abstract class RemoteNotificationsService {
//   /// This method gives token for remote notifications
//   /// Output : [String] token used to identify device for remote messaging
//   Future<String> getToken();

//   /// This method gives the notification permission only in IOS
//   Future getNotificationsPermission();

//   /// This method listens to the firebase notification when the app is in foreground
//   void listenToForegroundNotification();

//   /// This method listens to the firebase notification when the app is closed
//   Future<void> listenToBackGroundNotification(RemoteMessage message);
// }

// class RemoteNotificationsServiceImp implements RemoteNotificationsService {
//   static const String CHANNEL_ID = 'ajwaae_channel';
//   static const String CHANNEL_NAME = 'Ajwaae related notifications';
//   static const String CHANNEL_DESCRIPTION =
//       'This channel is used for important notifications.';

//  // final FirebaseMessaging firebaseMessaging;
//   // final AppState appState;

//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

//   Logger log;

//   RemoteNotificationsServiceImp({
//   //  required this.firebaseMessaging,
//     required this.flutterLocalNotificationsPlugin,
//     required this.log,
//     // required this.appState,
//   });
//   final StreamController<String?> selectNotificationStream =
//       StreamController<String?>.broadcast();

//   @override
//   Future<String> getToken() async {
//     // var token = await firebaseMessaging.getToken();
//     // if (token == null || token.isEmpty) {
//     //   throw FcmTokenReterivalError('something_went_wrong'.ntr());
//     // }
//      return 'token';
//   }

//   @override
//   Future getNotificationsPermission() async {
//     await firebaseMessaging.setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     const initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/launcher_icon');
//     final initializationSettingsIOS = DarwinInitializationSettings(
//         onDidReceiveLocalNotification: onDidReceiveLocalNotification);
//     const initializationSettingsMacOS = DarwinInitializationSettings();
//     final initializationSettings = InitializationSettings(
//         android: initializationSettingsAndroid,
//         iOS: initializationSettingsIOS,
//         macOS: initializationSettingsMacOS);

//     await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onDidReceiveNotificationResponse: selectNotification);
//     var channel = const AndroidNotificationChannel(
//       CHANNEL_ID,
//       CHANNEL_NAME,
//       description: CHANNEL_DESCRIPTION, // description
//       importance: Importance.max,
//     );

//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);

//     return false;
//   }

//   @override
//   void listenToForegroundNotification() {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//       if (kDebugMode) {
//         log.i('Got a message whilst in the foreground!');
//         log.i('Message data: ${message.data}');
//         log.i(message);

//         if (message.notification != null) {
//           log.i(
//               'Message also contained a notification: ${message.notification}');
//         }
//       }
//       await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

//       var action = '';
//       if (message.data.containsKey('action_ids')) {
//         action =
//             '${message.data['action_ids']}@${message.data['notification_type']}';
//       }
//       var notification = message.notification;
//       var android = message.notification?.android;

//       if (notification != null && android != null) {
//         flutterLocalNotificationsPlugin.show(
//             notification.hashCode,
//             notification.title,
//             notification.body,
//             NotificationDetails(
//               android: AndroidNotificationDetails(CHANNEL_ID, CHANNEL_NAME,
//                   channelDescription: CHANNEL_DESCRIPTION,
//                   icon: android.smallIcon,
//                   importance: Importance.max),
//             ),
//             payload: action);
//       }
//       onReceiveNotificationHandler(message);
//     });
//   }

//   void onReceiveNotificationHandler(RemoteMessage message) {
//     Map<String, dynamic> data = message.data;
//     if (!data.containsKey('notification_type')) {
//       return;
//     }
//     GetIt.I.get<AccountProvider>().updateNotifications(message);
//   }

//   void onDidReceiveLocalNotification(
//       int id, String? title, String? body, String? payload) {}

//   void selectNotification(NotificationResponse? payload) {
//     var actionIds = payload!.payload!.split('@')[0];
//     var notificationTypeString = payload.payload!.split('@')[1];
//     NotificationTypeEnum notificationType =
//         notificationTypeString.toString().toNotificationTypeEnum();
//     // log.i('Message selectNotification: ${payload.payload}');

//     switch (notificationType) {
//       case NotificationTypeEnum.none:
//         // TODO: Handle this case.
//         break;
//       case NotificationTypeEnum.post_like:
//         if (GetIt.I.get<UserRuntimeConfig>().isLogin) {
//           var detail = json.decode(actionIds.toString());
//           detail['isCommentClicked'] = false;
//           PendingActionForwarder.movePendingAction(
//               SavePendingAction.postDetailAction,
//               data: detail);
//           // return;
//         }
//         break;
//       case NotificationTypeEnum.post_dislike:
//         if (GetIt.I.get<UserRuntimeConfig>().isLogin) {
//           var detail = json.decode(actionIds.toString());
//           detail['isCommentClicked'] = false;
//           PendingActionForwarder.movePendingAction(
//               SavePendingAction.postDetailAction,
//               data: detail);
//         }
//         break;
//       case NotificationTypeEnum.post_comment:
//         if (GetIt.I.get<UserRuntimeConfig>().isLogin) {
//           var detail = json.decode(actionIds.toString());
//           detail['isCommentClicked'] = true;
//           PendingActionForwarder.movePendingAction(
//               SavePendingAction.postDetailAction,
//               data: detail);
//         }
//         break;
//       case NotificationTypeEnum.post_comment_reply:
//         if (GetIt.I.get<UserRuntimeConfig>().isLogin) {
//           var detail = json.decode(actionIds.toString());
//           detail['isCommentClicked'] = true;
//           PendingActionForwarder.movePendingAction(
//               SavePendingAction.postDetailAction,
//               data: detail);
//         }
//         break;
//       case NotificationTypeEnum.post_share:
//         if (GetIt.I.get<UserRuntimeConfig>().isLogin) {
//           var detail = json.decode(actionIds.toString());
//           detail['isCommentClicked'] = false;
//           PendingActionForwarder.movePendingAction(
//               SavePendingAction.postDetailAction,
//               data: detail);
//         }
//         break;
//       case NotificationTypeEnum.business_product_bought:
//         if (GetIt.I.get<UserRuntimeConfig>().isLogin) {
//           PendingActionForwarder.movePendingAction(
//               SavePendingAction.orderDetailAction);
//         }
//         break;
//     }
//     // log.i('onDidReceiveNotificationResponse payload: ${payload.payload}');
//     // log.i('onDidReceiveNotificationResponse id: ${payload.id}');
//     // log.i('onDidReceiveNotificationResponse actionId: ${payload.actionId}');
//     // log.i('onDidReceiveNotificationResponse input: ${payload.input}');
//     // log.i('onDidReceiveNotificationResponse type: ${payload.notificationResponseType}');
//   }

//   @override
//   Future<void> listenToBackGroundNotification(RemoteMessage message) async {
//     Map<String, dynamic> data = message.data;
//     if (!data.containsKey('notification_type')) {
//       return;
//     }

//     if (!message.data.containsKey('action_ids')) {
//       return;
//     }
//     var actionIds = message.data['action_ids'];
//     var notificationTypeString = message.data['notification_type'];
//     NotificationTypeEnum notificationType =
//         notificationTypeString.toString().toNotificationTypeEnum();
//     log.i('Message BackGroundNotification: $message');

//     switch (notificationType) {
//       case NotificationTypeEnum.none:
//         // TODO: Handle this case.
//         break;
//       case NotificationTypeEnum.post_like:
//         if (GetIt.I.get<UserRuntimeConfig>().isLogin) {
//           var detail = json.decode(actionIds.toString());
//           detail['isCommentClicked'] = false;
//           PendingActionForwarder.movePendingAction(
//               SavePendingAction.postDetailAction,
//               data: detail);
//           // return;
//         }
//         break;
//       case NotificationTypeEnum.post_dislike:
//         if (GetIt.I.get<UserRuntimeConfig>().isLogin) {
//           var detail = json.decode(actionIds.toString());
//           detail['isCommentClicked'] = false;
//           PendingActionForwarder.movePendingAction(
//               SavePendingAction.postDetailAction,
//               data: detail);
//         }
//         break;
//       case NotificationTypeEnum.post_comment:
//         if (GetIt.I.get<UserRuntimeConfig>().isLogin) {
//           var detail = json.decode(actionIds.toString());
//           detail['isCommentClicked'] = true;
//           PendingActionForwarder.movePendingAction(
//               SavePendingAction.postDetailAction,
//               data: detail);
//         }
//         break;
//       case NotificationTypeEnum.post_comment_reply:
//         if (GetIt.I.get<UserRuntimeConfig>().isLogin) {
//           var detail = json.decode(actionIds.toString());
//           detail['isCommentClicked'] = true;
//           PendingActionForwarder.movePendingAction(
//               SavePendingAction.postDetailAction,
//               data: detail);
//         }
//         break;
//       case NotificationTypeEnum.post_share:
//         if (GetIt.I.get<UserRuntimeConfig>().isLogin) {
//           var detail = json.decode(actionIds.toString());
//           detail['isCommentClicked'] = false;
//           PendingActionForwarder.movePendingAction(
//               SavePendingAction.postDetailAction,
//               data: detail);
//         }
//         break;
//       case NotificationTypeEnum.business_product_bought:
//         if (GetIt.I.get<UserRuntimeConfig>().isLogin) {
//           PendingActionForwarder.movePendingAction(
//               SavePendingAction.orderDetailAction);
//         }
//         break;
//     }
//   }
// }
