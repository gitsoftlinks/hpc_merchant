
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import '../app/app.dart';
import '../app/settings/settings_controller.dart';
import '../app/settings/settings_service.dart';
import '../utils/dependency_injection/dependency_injection.dart' as di;
import '../utils/globals.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
//  await Firebase.initializeApp();

  sl.registerLazySingleton(() => Logger());

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  await dotenv.load(fileName: 'env/.env_prod');

  await di.init();

  runApp(MyApp(settingsController: settingsController));
}
