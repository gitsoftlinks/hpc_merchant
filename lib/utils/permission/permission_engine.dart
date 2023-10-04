import 'package:permission_handler/permission_handler.dart';
import 'package:happiness_club_merchant/utils/permission/permission_service.dart';

import '../globals.dart';

enum CustomPermission { location, contacts, camera, storage }

abstract class PermissionEngineGetter {
  Future<bool> hasPermission(CustomPermission permission);
}

abstract class PermissionEngineResolver {
  Future<bool> resolvePermission(CustomPermission permission);
}

abstract class PermissionEngine implements PermissionEngineGetter, PermissionEngineResolver {}

class PermissionEngineImp implements PermissionEngine {
  PermissionService permissionsService;

  PermissionEngineImp(this.permissionsService);

  @override
  Future<bool> resolvePermission(CustomPermission permission) async {
    switch (permission) {
      case CustomPermission.location:
        var permissionStatus = await permissionsService.status(Permission.locationWhenInUse);
        await handlerPermissionStatus(customPermission: permission, permissionStatus: permissionStatus);
        var afterPermissionStatus = await permissionsService.status(Permission.locationWhenInUse);
        if (afterPermissionStatus.isPermanentlyDenied || afterPermissionStatus.isDenied) {
          return false;
        }
        return afterPermissionStatus.isGranted;
      case CustomPermission.contacts:
        var permissionStatus = await permissionsService.status(Permission.contacts);
        await handlerPermissionStatus(customPermission: permission, permissionStatus: permissionStatus);
        var afterPermissionStatus = await permissionsService.status(Permission.contacts);
        if (afterPermissionStatus.isPermanentlyDenied || afterPermissionStatus.isDenied) {
          return false;
        }
        return afterPermissionStatus.isGranted;
      case CustomPermission.camera:
        var permissionStatus = await permissionsService.status(Permission.camera);
        await handlerPermissionStatus(customPermission: permission, permissionStatus: permissionStatus);
        var afterPermissionStatus = await permissionsService.status(Permission.camera);
        if (afterPermissionStatus.isPermanentlyDenied || afterPermissionStatus.isDenied) {
          return false;
        }
        return afterPermissionStatus.isGranted;
      case CustomPermission.storage:
        var permissionStatus = await permissionsService.status(Permission.storage);
        await handlerPermissionStatus(customPermission: permission, permissionStatus: permissionStatus);
        var afterPermissionStatus = await permissionsService.status(Permission.storage);
        if (afterPermissionStatus.isPermanentlyDenied || afterPermissionStatus.isDenied) {
          return false;
        }
        return afterPermissionStatus.isGranted;
    }
  }

  @override
  Future<bool> hasPermission(CustomPermission permission) async {
    switch (permission) {
      case CustomPermission.location:
        var permissionStatus = await permissionsService.status(Permission.locationWhenInUse);
        return permissionStatus.isGranted;
      case CustomPermission.contacts:
        var permissionStatus = await permissionsService.status(Permission.contacts);
        return permissionStatus.isGranted;
      case CustomPermission.camera:
        var permissionStatus = await permissionsService.status(Permission.camera);
        return permissionStatus.isGranted;
      case CustomPermission.storage:
        var permissionStatus = await permissionsService.status(Permission.storage);
        return permissionStatus.isGranted;
    }
  }

  Future<bool> handlerPermissionStatus({required CustomPermission customPermission, required PermissionStatus permissionStatus}) async {
    if (permissionStatus.isGranted) {
      return true;
    }

    if (permissionStatus.isDenied) {
      // You can only get permanently denied on android after calling
      var permissionStatus = await requestPermission(customPermission);
      if (permissionStatus == PermissionStatus.permanentlyDenied && isAndroid) {
        await permissionsService.openAppSettings();
      }
      return false;
    }

    if (permissionStatus.isLimited) {
      await permissionsService.openAppSettings();
      return false;
    }

    if (permissionStatus.isPermanentlyDenied) {
      await permissionsService.openAppSettings();
      return false;
    }

    return false;
  }

  Future<PermissionStatus> requestPermission(CustomPermission permission) async {
    switch (permission) {
      case CustomPermission.location:
        return await permissionsService.request(Permission.locationWhenInUse);

      case CustomPermission.contacts:
        return await permissionsService.request(Permission.contacts);
      case CustomPermission.storage:
        return await permissionsService.request(Permission.storage);
      case CustomPermission.camera:
        return await permissionsService.request(Permission.camera);
      default:
        return PermissionStatus.denied;
    }
  }
}
