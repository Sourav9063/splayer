import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

class StorageStatusProvider extends ChangeNotifier {
  PermissionStatus _permissionStatus = PermissionStatus.limited;

  PermissionStatus get permissionStatus => _permissionStatus;

  set permissionStatus(PermissionStatus value) {
    _permissionStatus = value;

    notifyListeners();
  }

  Future<void> checkPermission() async {
    permissionStatus = await Permission.storage.status;
  }

  Future<void> reqAccess() async {
    print("reqAccess Called");
    var currentStatus = await Permission.storage.status;
    if (currentStatus.isDenied) {
      var status = await Permission.storage.request();

      permissionStatus = status;
    } else {
      permissionStatus = currentStatus;
    }
  }
}
