import 'package:get/get.dart';
import 'admin.dart';
import 'admin_preferences.dart';

class CurrentAdmin extends GetxController {
  final Rx<Admin> _currentAdmin = Admin(0, '', '', '').obs;

  Admin get admin => _currentAdmin.value;

  getAdminInfo() async {
    Admin? getAdminInfoFromLocalStorage = await RememberAdminPrefs.readAdminInfo();
    if (getAdminInfoFromLocalStorage != null) {
      _currentAdmin.value = getAdminInfoFromLocalStorage;
    }
  }
}
