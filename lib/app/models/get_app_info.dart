import 'package:equatable/equatable.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppInfo extends Equatable {
  final String versionCode;
  final String buildCode;

  const AppInfo(this.versionCode, this.buildCode);

  String get getCodeForRemoteConfig => '$versionCode+$buildCode';

  @override
  List<Object?> get props => [versionCode, buildCode];
}

extension PackageInfoParser on PackageInfo {
  AppInfo getAppInfo() {
    return AppInfo(version, buildNumber);
  }
}
