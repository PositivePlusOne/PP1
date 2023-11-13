// Package imports:
import 'package:permission_handler/permission_handler.dart';

extension PermissionStatusExtensions on PermissionStatus {
  bool get canUsePermission {
    switch (this) {
      case PermissionStatus.granted:
      case PermissionStatus.limited:
        return true;
      default:
        return false;
    }
  }
}
