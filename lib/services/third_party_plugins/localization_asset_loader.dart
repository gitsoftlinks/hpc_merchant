// import 'dart:convert';
// import 'dart:ui';

// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/services.dart';

// import '../remote_config/remote_config_service.dart';

// class LocalizationAssetLoader implements AssetLoader {
//   //

//   final RemoteConfigService localizationRemoteConfigService;

//   LocalizationAssetLoader(this.localizationRemoteConfigService);

//   @override
//   Future<Map<String, dynamic>?> load(String path, Locale locale) async {
//     //

//     var languageMap = <String, dynamic>{};

//     const enPath = 'assets/translations/en.json';

//     const arPath = 'assets/translations/ar.json';

//     switch (locale.languageCode) {
//       case 'en':
//         languageMap = json.decode(await rootBundle.loadString(enPath));

//         if (languageMap.isEmpty) {
//           languageMap = json.decode(await rootBundle.loadString(enPath));
//         }
//         break;

//       case 'ar':
//         languageMap = json.decode(await rootBundle.loadString(arPath));

//         if (languageMap.isEmpty) {
//           languageMap = json.decode(await rootBundle.loadString(arPath));
//         }
//         break;

//       default:
//         languageMap = json.decode(await rootBundle.loadString(enPath));

//         if (languageMap.isEmpty) {
//           const enPath = 'assets/translations/en.json';
//           languageMap = json.decode(await rootBundle.loadString(enPath));
//         }
//     }

//     return languageMap;
//   }
// }
