import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:haute_attires/api_connection/api_connection.dart';
import 'package:haute_attires/users/model/user.dart';
import 'package:http/http.dart' as http;

class AllUsersWidget extends StatefulWidget {
  const AllUsersWidget({super.key});

  @override
  State<AllUsersWidget> createState() => _AllUsersWidgetState();
}

class _AllUsersWidgetState extends State<AllUsersWidget> {
  Future<List<User>> getAllUsers() async {
    List<User> allUsersList = [];

    try {
      var res = await http.post(Uri.parse(API.user));

      if (res.statusCode == 200) {
        var responseBodyOfAllUsers = jsonDecode(res.body);
        if (responseBodyOfAllUsers["success"] == true) {
          for (var eachRecord in (responseBodyOfAllUsers["allUserData"] as List)) {
            allUsersList.add(User.fromJson(eachRecord));
          }
        }
      } else {
        Fluttertoast.showToast(msg: "Error, status code is not 200");
      }
    } catch (errorMsg) {
      print("Error:: $errorMsg");
    }

    return allUsersList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>>(
      future: getAllUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text("An error occurred. Please try again."),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text("No users found."),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            // Adjust the layout based on screen width
            bool isLargeScreen = constraints.maxWidth > 600;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        User user = snapshot.data![index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                // Display user ID, name, and email
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "User ID: ${user.user_id}",
                                        style: TextStyle(
                                          fontSize: isLargeScreen ? 18 : 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Name: ${user.user_name}",
                                        style: TextStyle(
                                          fontSize: isLargeScreen ? 16 : 14,
                                          color: Colors.white70,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Email: ${user.user_email}",
                                        style: TextStyle(
                                          fontSize: isLargeScreen ? 16 : 14,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Optional: Add user profile picture or icon
                                Icon(
                                  Icons.person,
                                  size: isLargeScreen ? 40 : 30,
                                  color: Colors.blueAccent,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
