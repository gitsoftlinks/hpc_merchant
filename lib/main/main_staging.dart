import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/dependency_injection/dependency_injection.dart' as di;
import '../app/app.dart';
import '../app/settings/settings_controller.dart';
import '../app/settings/settings_service.dart';
import '../utils/constants/app_strings.dart';
import '../utils/globals.dart';
import 'main_developemt.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  sl.registerLazySingleton(() => Logger(filter: ShowAllLogsFilter()));

  await EasyLocalization.ensureInitialized();
  // await FlutterDownloader.initialize(debug: false);

  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  await dotenv.load(fileName: 'env/.x');

  // Load the user's preferred theme while the splash screens is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  await di.init();

  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  deviceInfoPlugin.deviceInfo.then((value) {
    sl.get<Logger>().i(value.toMap());
    deviceInfo[DEVICE_UNIQUE_ID] = value.toMap()["androidId"];
    deviceInfo[DEVICE_ID] = value.toMap()["model"];
    deviceInfo[DEVICE] = value.toMap()["device"];
    deviceInfo[MANUFACTURER] = value.toMap()["brand"];
  });

  PackageInfo.fromPlatform().then((value) {
    deviceInfo[BUILD_ID] = "${value.version}+${value.buildNumber}";
  });

  runZonedGuarded(() {
    GetIt.I.isReady<SharedPreferences>().then((_) async {
      // await sl<RemoteConfigService>().initialise();

      runApp(
        EasyLocalization(
          path: 'assets/translations',
          supportedLocales: const [
            Locale('en'),
            Locale('ar'),
          ],
          fallbackLocale: const Locale('en'),
          //  assetLoader: LocalizationAssetLoader(sl()),
          child: MyApp(
            settingsController: settingsController,
          ),
        ),
      );
    });
  }, (error, stack) => Logger().e(error.toString()));
}
