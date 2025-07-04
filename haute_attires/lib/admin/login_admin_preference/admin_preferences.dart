import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'admin.dart';

class RememberAdminPrefs {
  static Future<void> storeAdminInfo(Admin adminInfo) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String adminJsonData = jsonEncode(adminInfo.toJson());
    await preferences.setString("currentAdmin", adminJsonData);
  }

  static Future<Admin?> readAdminInfo() async {
    Admin? currentAdminInfo;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? adminInfo = preferences.getString("currentAdmin");
    if (adminInfo != null) {
      Map<String, dynamic> adminDataMap = jsonDecode(adminInfo);
      currentAdminInfo = Admin.fromJson(adminDataMap);
    }
    return currentAdminInfo;
  }

  static Future<void> removeAdminInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove("currentAdmin");
  }
}
