// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:logger/logger.dart';

// import '../../../utils/constants/app_strings.dart';
// import 'fcm_service.dart';

// class FCMServiceImpl extends FCMService {
//   final FirebaseMessaging _firebaseMessaging;
//   final Logger _log;

//   FCMServiceImpl({required FirebaseMessaging firebaseMessaging, required Logger logger}) : _firebaseMessaging = firebaseMessaging, _log = logger;

//   @override
//   Future<void> deleteFCMToken() async {
//     await _firebaseMessaging.deleteToken();
//   }

//   @override
//   Future<String> getFCMToken() async {
//     final token = await _firebaseMessaging.getToken();
//     if(token != null) {
//       _log.i("FCMServiceImpl | FCM TOKEN: $token");
//       return token;
//     }

//     throw SOMETHING_WENT_WRONG;
//   }

// }