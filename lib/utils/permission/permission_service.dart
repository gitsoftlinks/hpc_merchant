import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:happiness_club_merchant/app/app_theme/app_theme.dart';
import 'package:happiness_club_merchant/app/custom_widgets/custom_snackbar.dart';
import 'package:permission_handler/permission_handler.dart'
    as permission_handler show openAppSettings;
import 'package:permission_handler/permission_handler.dart';

abstract class PermissionService {
  /// Check the status of a specific [Permission]
  Future<PermissionStatus> status(Permission permission);

  Future<PermissionStatus> request(Permission permission);

  /// Open the app settings.
  Future<bool> openAppSettings();
}

class PermissionsServiceImp implements PermissionService {
  /// Check the status of a specific [Permission]
  @override
  Future<PermissionStatus> status(Permission permission) {
    return permission.status;
  }

  /// Open the app settings.
  @override
  Future<bool> openAppSettings() {
    return permission_handler.openAppSettings();
  }

  /// Request permissions for a single permission.
  @override
  Future<PermissionStatus> request(Permission permission) {
    return permission.request();
  }
}
