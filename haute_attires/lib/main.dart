import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haute_attires/admin/admin_dashboard_screen.dart';
import 'package:haute_attires/admin/login_admin_preference/admin_preferences.dart';
import 'package:haute_attires/admin/login_admin_preference/current_admin.dart';
import 'package:haute_attires/users/authentication/login_screen.dart';
import 'package:haute_attires/users/fragments/dashboard_of_fragments.dart';
import 'package:haute_attires/users/userPreferences/current_user.dart';
import 'package:haute_attires/users/userPreferences/user_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Haute Attires',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Show loading spinner while checking
          } else if (snapshot.hasData) {
            // Direct user to respective dashboards based on login status
            if (snapshot.data == 'admin') {
              Get.put(CurrentAdmin()); // Initialize CurrentAdmin
              Get.find<CurrentAdmin>().getAdminInfo();
              return AdminDashboardScreen();
            } else if (snapshot.data == 'user') {
              Get.put(CurrentUser()); // Initialize CurrentUser
              Get.find<CurrentUser>().getUserInfo();
              return DashboardOfFragments();
            } else {
              return const LoginScreen(); // No login found, show user login screen
            }
          } else {
            return const LoginScreen(); // Default to user login
          }
        },
      ),
    );
  }

  // Check login status for both admin and user
  Future<String?> _checkLoginStatus() async {
    // Check for saved admin info
    var adminInfo = await RememberAdminPrefs.readAdminInfo();
    if (adminInfo != null) {
      return 'admin'; // If admin info exists, return 'admin'
    }

    // Check for saved user info
    var userInfo = await RememberUserPrefs.readUserInfo();
    if (userInfo != null) {
      return 'user'; // If user info exists, return 'user'
    }

    return null; // No login info found, show login screen
  }
}