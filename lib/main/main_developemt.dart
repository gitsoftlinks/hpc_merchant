import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:happiness_club_merchant/app/app.dart';
import 'package:happiness_club_merchant/app/app_theme/app_theme.dart';
import 'package:happiness_club_merchant/app/settings/settings_controller.dart';
import 'package:happiness_club_merchant/app/settings/settings_service.dart';
import 'package:happiness_club_merchant/utils/constants/app_strings.dart';

import '../firebase_options.dart';

import '../utils/dependency_injection/dependency_injection.dart' as di;
import '../utils/globals.dart';

@pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // If you're going to use other Firebase services in the background, such as Firestore,

//   // make sure you call `initializeApp` before using other Firebase services.
//   // await Firebase.initializeApp();

//   print("Handling a background messageId: ${message.messageId}");
//   print("Handling a background data: ${message.data}");
//   print(
//       "Handling a background notification_type: ${message.data["notification_type"]}");
//   print(
//       "Handling a background notification body: ${message.notification!.body}");
//   print("Handling a background title: ${message.notification!.title}");

//   //
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;
  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    mapsImplementation.useAndroidViewSurface = false;
  }

  sl.registerLazySingleton(() => Logger(filter: ShowAllLogsFilter()));

  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
  //     .catchError((error) async {
  //   sl.get<Logger>().wtf(error);
  // });

  // FirebaseMessaging.onBackgroundMessage(
  //     _firebaseMessagingBackgroundHandler); //await sl<RemoteNotificationsService>().listenToBackGroundNotification(message));

  await dotenv.load(fileName: 'env/.env_development');

  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());
  // Load the user's preferred theme while the splash screens is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.

  await settingsController.loadSettings();

  // Registers all dependencies

  await di.init();

  await EasyLocalization.ensureInitialized();

  // await sl<RemoteConfigService>().initialise();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: kPrimaryColor));

  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  deviceInfoPlugin.deviceInfo.then((BaseDeviceInfo value) {
    sl.get<Logger>().i(value.toString());

    // deviceInfo[DEVICE_UNIQUE_ID] = value.toMap()["androidId"];
    // deviceInfo[DEVICE_ID] = value.toMap()["model"];
    // deviceInfo[DEVICE] = value.toMap()["name"];
    // deviceInfo[MANUFACTURER] = value.toMap()["model"];
  });

  PackageInfo.fromPlatform().then((value) {
    deviceInfo[BUILD_ID] = "${value.version}+${value.buildNumber}";
  });

  // runZonedGuarded(() {
  runApp(
    // EasyLocalization(
    //   path: 'assets/translations',
    //   supportedLocales: const [
    //     Locale('en', 'US'),
    //     Locale('ar', 'AE'),
    //   ],
    //   fallbackLocale: const Locale('en'),
    // assetLoader: LocalizationAssetLoader(sl()),
    MyApp(
      settingsController: settingsController,
    ),
    //),
  );
  // }, (error, stack) => Logger().e(error.toString(), '', stack));
}

class ShowAllLogsFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return true;
  }
}
