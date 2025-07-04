import 'package:haute_attires/admin/login_admin_preference/admin_preferences.dart';
import 'package:haute_attires/admin/login_admin_preference/current_admin.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:haute_attires/users/authentication/login_screen.dart';

class AdminLogout extends StatelessWidget {
  final CurrentAdmin _currentAdmin = Get.put(CurrentAdmin());

  AdminLogout({super.key});

  signOutAdmin() async {
    var resultResponse = await Get.dialog(
      AlertDialog(
        backgroundColor: Colors.grey,
        title: const Text(
          "Logout",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          "Are you sure?\nYou want to logout from app?",
        ),
        actions: [
          TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text(
                "No",
                style: TextStyle(
                  color: Colors.black,
                ),
              )),
          TextButton(
              onPressed: () {
                Get.back(result: "loggedOut");
              },
              child: const Text(
                "Yes",
                style: TextStyle(
                  color: Colors.black,
                ),
              )),
        ],
      ),
    );

    if (resultResponse == "loggedOut") {
      //delete-remove the user data from phone local storage
      RememberAdminPrefs.removeAdminInfo().then((value) {
        Get.off(const LoginScreen());
      });
    }
  }

  Widget adminInfoItemProfile(IconData iconData, String userData) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Row(
        children: [
          Icon(
            iconData,
            size: 30,
            color: Colors.black,
          ),
          const SizedBox(
            width: 16,
          ),
          Text(
            userData,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final screenSize = MediaQuery.of(context).size;
    final isDesktop = screenSize.width >= 600; // Adjust threshold for desktop

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isDesktop ? 50 : 18),
        child: Column(
          children: [
            SizedBox(height: 18),
            Container(
              height: screenSize.height * 0.7, // Set a height based on screen size
              child: ListView(
                padding: const EdgeInsets.all(32),
                children: [
                  Center(
                    child: Image.asset(
                      "images/woman.png",
                      width: 150, // Responsive width
                      height: 150,
                    ),
                  ),
                  const SizedBox(height: 20),
                  adminInfoItemProfile(Icons.person, _currentAdmin.admin.admin_name),
                  const SizedBox(height: 20),
                  adminInfoItemProfile(Icons.email, _currentAdmin.admin.admin_email), // Corrected to use admin_email
                  const SizedBox(height: 20),
                  Center(
                    child: Material(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        onTap: () {
                          signOutAdmin();
                        },
                        borderRadius: BorderRadius.circular(32),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 12,
                          ),
                          child: Text(
                            "Sign Out",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
