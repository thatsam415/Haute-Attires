import 'dart:convert';
import 'package:haute_attires/users/model/app_colors.dart';
import 'package:haute_attires/users/model/order.dart';
import 'package:haute_attires/users/order/order_details.dart';
import 'package:haute_attires/users/order/order_details_cancel.dart';
import 'package:haute_attires/users/order/order_details_his.dart';
import 'package:haute_attires/users/userPreferences/current_user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../api_connection/api_connection.dart';

class OrderFragmentScreen extends StatefulWidget {
  // Changed to StatefulWidget
  final currentOnlineUser = Get.put(CurrentUser());

  OrderFragmentScreen({super.key});

  @override
  _OrderFragmentScreenState createState() => _OrderFragmentScreenState();
}

class _OrderFragmentScreenState extends State<OrderFragmentScreen> {
  int currentIndex = 0; // 0: My Orders, 1: History, 2: Cancelled Orders

  Future<List<Order>> getCurrentUserHistoryList() async {
    List<Order> ordersListOfCurrentUser = [];

    try {
      var res = await http.post(Uri.parse(API.readOldOrders), body: {
        "currentOnlineUserID": widget.currentOnlineUser.user.user_id.toString(),
      });

      if (res.statusCode == 200) {
        var responseBodyOfCurrentUserOrdersList = jsonDecode(res.body);

        if (responseBodyOfCurrentUserOrdersList['success'] == true) {
          for (var eachCurrentUserOrderData
              in (responseBodyOfCurrentUserOrdersList['currentUserOrdersData']
                  as List)) {
            ordersListOfCurrentUser
                .add(Order.fromJson(eachCurrentUserOrderData));
          }
        }
      } else {
        Fluttertoast.showToast(msg: "Status Code is not 200");
      }
    } catch (errorMsg) {
      Fluttertoast.showToast(msg: "Error:: $errorMsg");
    }

    return ordersListOfCurrentUser;
  }

  Future<List<Order>> getCurrentUserCancelList() async {
    List<Order> ordersListOfCurrentUser = [];

    try {
      var res = await http.post(Uri.parse(API.readCancelOrders), body: {
        "currentOnlineUserID": widget.currentOnlineUser.user.user_id.toString(),
      });

      if (res.statusCode == 200) {
        var responseBodyOfCurrentUserOrdersList = jsonDecode(res.body);

        if (responseBodyOfCurrentUserOrdersList['success'] == true) {
          for (var eachCurrentUserOrderData
              in (responseBodyOfCurrentUserOrdersList['currentUserOrdersData']
                  as List)) {
            ordersListOfCurrentUser
                .add(Order.fromJson(eachCurrentUserOrderData));
          }
        }
      } else {
        Fluttertoast.showToast(msg: "Status Code is not 200");
      }
    } catch (errorMsg) {
      Fluttertoast.showToast(msg: "Error:: $errorMsg");
    }

    return ordersListOfCurrentUser;
  }

  Future<List<Order>> getCurrentUserOrdersList() async {
    List<Order> ordersListOfCurrentUser = [];

    try {
      var res = await http.post(Uri.parse(API.readOrders), body: {
        "currentOnlineUserID": widget.currentOnlineUser.user.user_id.toString(),
      });

      if (res.statusCode == 200) {
        var responseBodyOfCurrentUserOrdersList = jsonDecode(res.body);

        if (responseBodyOfCurrentUserOrdersList['success'] == true) {
          for (var eachCurrentUserOrderData
              in (responseBodyOfCurrentUserOrdersList['currentUserOrdersData']
                  as List)) {
            ordersListOfCurrentUser
                .add(Order.fromJson(eachCurrentUserOrderData));
          }
        }
      } else {
        Fluttertoast.showToast(msg: "Status Code is not 200");
      }
    } catch (errorMsg) {
      Fluttertoast.showToast(msg: "Error:: $errorMsg");
    }

    return ordersListOfCurrentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Header section
            _buildHeader(),
            const SizedBox(height: 16),
          
            const SizedBox(height: 16),
            //Order list
            Expanded(
              child: _getCurrentScreen(),
            )
          ],
        ),
      ),
    );
  }

  // Method to return the appropriate screen based on currentIndex
  Widget _getCurrentScreen() {
    switch (currentIndex) {
      case 0:
        return displayOrdersList();
      case 1:
        return displayHistoryOrdersList();
      case 2:
        return displayCancelOrdersList();
      default:
        return displayOrdersList();
    }
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // My Orders Section
        GestureDetector(
          onTap: () {
            setState(() {
              currentIndex = 0; // Show current orders
            });
          },
          child: Column(
            children: [
              Image.asset(
                "images/orders_icon.png",
                width: 80,
              ),
              const SizedBox(height: 8), // Added space
              const Text(
                "My Orders",
                style: TextStyle(
                  color: Colors.pink, // Changed color
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        // History Section
        GestureDetector(
          onTap: () {
            setState(() {
              currentIndex = 1; // Show order history
            });
          },
          child: Column(
            children: [
              Image.asset(
                "images/history_icon.png",
                width: 45,
              ),
              const SizedBox(height: 8), // Added space
              const Text(
                "History",
                style: TextStyle(
                  color: Colors.pink, // Changed color
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        GestureDetector(
          onTap: () {
            setState(() {
              currentIndex = 2; // Show cancelled orders
            });
          },
          child: Column(
            children: [
              Image.asset(
                "images/cancel.jpeg",
                width: 45,
              ),
              const SizedBox(height: 8), // Added space
              const Text(
                "Cancelled\nOrders",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.pink, // Changed color
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget displayOrdersList() {
    return FutureBuilder(
      future: getCurrentUserOrdersList(),
      builder: (context, AsyncSnapshot<List<Order>> dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (dataSnapshot.data == null || dataSnapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              "No orders found yet...",
              style: TextStyle(
                color: Colors.black87,
              ),
            ),
          );
        }
        List<Order> orderList = dataSnapshot.data!;

        return ListView.separated(
          padding: const EdgeInsets.all(8),
          separatorBuilder: (context, index) {
            return const Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey,
            );
          },
          itemCount: orderList.length,
          itemBuilder: (context, index) {
            Order eachOrderData = orderList[index];

            return Card(
              elevation: 4,
              color: Colors.white.withOpacity(0.9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: ListTile(
                  onTap: () {
                    Get.to(OrderDetailsScreen(
                      clickedOrderInfo: eachOrderData,
                    ));
                  },
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Order ID # ${eachOrderData.order_id}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.deepSeaBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8), // Added space
                      Text(
                        "Amount: ₹ ${eachOrderData.totalAmount}", // Changed dollar sign to rupee sign
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.deepOrangeAccent, // Changed color
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat("dd MMMM, yyyy")
                            .format(eachOrderData.dateTime!),
                        style: const TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat("hh:mm a").format(eachOrderData.dateTime!),
                        style: const TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget displayHistoryOrdersList() {
    return FutureBuilder(
      future: getCurrentUserHistoryList(),
      builder: (context, AsyncSnapshot<List<Order>> dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (dataSnapshot.data == null || dataSnapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              "No orders found yet...",
              style: TextStyle(
                color: Colors.black87,
              ),
            ),
          );
        }
        List<Order> orderList = dataSnapshot.data!;

        return ListView.separated(
          padding: const EdgeInsets.all(8),
          separatorBuilder: (context, index) {
            return const Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey,
            );
          },
          itemCount: orderList.length,
          itemBuilder: (context, index) {
            Order eachOrderData = orderList[index];

            return Card(
              elevation: 4,
              color: const Color.fromARGB(255, 232, 232, 232),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: ListTile(
                  onTap: () {
                    Get.to(OrderDetailsHis(
                      clickedOrderInfo: eachOrderData,
                    ));
                  },
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Order ID # ${eachOrderData.order_id}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.deepSeaBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8), // Added space
                      Text(
                        "Amount: ₹ ${eachOrderData.totalAmount}", // Changed dollar sign to rupee sign
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.deepOrangeAccent, // Changed color
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat("dd MMMM, yyyy")
                            .format(eachOrderData.dateTime!),
                        style: const TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat("hh:mm a").format(eachOrderData.dateTime!),
                        style: const TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget displayCancelOrdersList() {
    return FutureBuilder(
      future: getCurrentUserCancelList(),
      builder: (context, AsyncSnapshot<List<Order>> dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (dataSnapshot.data == null || dataSnapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              "No orders found yet...",
              style: TextStyle(
                color: Colors.black87,
              ),
            ),
          );
        }
        List<Order> orderList = dataSnapshot.data!;

        return ListView.separated(
          padding: const EdgeInsets.all(8),
          separatorBuilder: (context, index) {
            return const Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey,
            );
          },
          itemCount: orderList.length,
          itemBuilder: (context, index) {
            Order eachOrderData = orderList[index];

            return Card(
              elevation: 4,
              color: const Color.fromARGB(255, 255, 228, 228),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: ListTile(
                  onTap: () {
                    Get.to(OrderDetailsCancel(
                      clickedOrderInfo: eachOrderData,
                    ));
                  },
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Order ID # ${eachOrderData.order_id}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.deepSeaBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8), // Added space
                      Text(
                        "Amount: ₹ ${eachOrderData.totalAmount}", // Changed dollar sign to rupee sign
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.deepOrangeAccent, // Changed color
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat("dd MMMM, yyyy")
                            .format(eachOrderData.dateTime!),
                        style: const TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat("hh:mm a").format(eachOrderData.dateTime!),
                        style: const TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
