import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:haute_attires/api_connection/api_connection.dart';
import 'package:haute_attires/users/model/order.dart';
import 'package:haute_attires/users/model/user.dart';
import 'package:http/http.dart' as http;

class AllOrdersWidget extends StatefulWidget {
  AllOrdersWidget({super.key});

  @override
  State<AllOrdersWidget> createState() => _AllOrdersWidgetState();
}

class _AllOrdersWidgetState extends State<AllOrdersWidget> {
  
  Future<List<User>> getAllUsers() async {
    List<User> allUsersList = [];

    try {
      var res = await http.post(Uri.parse(API.user));

      if (res.statusCode == 200) {
        var responseBodyOfAllUsers = jsonDecode(res.body);
        if (responseBodyOfAllUsers["success"] == true) {
          for (var eachRecord
              in (responseBodyOfAllUsers["allUserData"] as List)) {
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

  Future<List<Order>> getAllOrderItems() async {
    List<Order> allOrderItemsList = [];

    try {
      var res = await http.post(Uri.parse(API.allNew));
      if (res.statusCode == 200) {
        var responseBodyOfAllOrder = jsonDecode(res.body);
        if (responseBodyOfAllOrder["success"] == true) {
          for (var eachRecord in (responseBodyOfAllOrder["allNew"] as List)) {
            allOrderItemsList.add(Order.fromJson(eachRecord));
          }
        }
      } else {
        Fluttertoast.showToast(msg: "Error, status code is not 200");
      }
    } catch (errorMsg) {
      print("Error:: $errorMsg");
    }

    return allOrderItemsList;
  }

  void showDialogForParcelConfirmation(dynamic order) async {

    if (order.status == "new") {
      var response = await Get.dialog(
        AlertDialog(
          backgroundColor: Colors.black,
          title: const Text(
            "Confirmation",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          content: const Text(
            "Have you received your parcel?",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text(
                "No",
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
            TextButton(
              onPressed: () {
                Get.back(result: "yesConfirmed");
              },
              child: const Text(
                "Yes",
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        ),
      );

      if (response == "yesConfirmed") {
        updateStatusValueInDatabase(
            order.order_id);
      }
    }
  }

  void updateStatusValueInDatabase(int order_id) async {
    try {
      var response = await http.post(Uri.parse(API.updateStatusOld), body: {
        "order_id": order_id.toString(),
      });

      if (response.statusCode == 200) {
        var responseBodyOfUpdateStatus = jsonDecode(response.body);

        if (responseBodyOfUpdateStatus["success"] == true) {
          setState(() {
            getAllOrderItems();
          });
          Fluttertoast.showToast(msg: "Item Updated Successfully!");
          
        } else {
          print(responseBodyOfUpdateStatus);
          Fluttertoast.showToast(msg: "Failed to update status.");
        }
      } else {
        Fluttertoast.showToast(
            msg: "Error, status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error updating status: $e");
      Fluttertoast.showToast(msg: "Error updating status: $e");
    }
  }

  final TextEditingController reasonController = TextEditingController();

  void updateStatusCancelInDatabase(int order_id) async {
    try {
      var response = await http.post(Uri.parse(API.updateStatusCancel), body: {
        "order_id": order_id.toString(),
      });

      if (response.statusCode == 200) {
        var responseBodyOfUpdateStatus = jsonDecode(response.body);

        if (responseBodyOfUpdateStatus["success"] == true) {
          Fluttertoast.showToast(msg: "Item Cancelled!");
        } else {
          print(responseBodyOfUpdateStatus);
          Fluttertoast.showToast(msg: "Failed to cancel item.");
        }
      } else {
        Fluttertoast.showToast(
            msg: "Error, status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error updating status: $e");
      Fluttertoast.showToast(msg: "Error updating status: $e");
    }
  }

  void cancelItemDatabase(int order_id) async {
    String cancel_by = "Admin";
    String reason = reasonController.text.trim();
    try {
        var response = await http.post(
            Uri.parse(API.addCancelTable),
            body: {
                "order_id": order_id.toString(),
                "cancel_by": cancel_by,
                "reason": reason,
            },
        );

        if (response.statusCode == 200) {
            var resBodyOfUploadItem = jsonDecode(response.body);
            if (resBodyOfUploadItem['success'] == true) {
                Fluttertoast.showToast(msg: "Order Cancelled");
                updateStatusCancelInDatabase(order_id);
            } else {
                Fluttertoast.showToast(msg: "Order not Cancelled. Try again.");
            }
        } else {
            Fluttertoast.showToast(msg: "Server error. Try again.");
        }
    } catch (errorMsg) {
        print("Error:: $errorMsg");
        Fluttertoast.showToast(msg: "Error cancelling order. Try again.");
    }
}


  cancelOrder(int order_id) async {
    var resultResponse = await Get.dialog(
      AlertDialog(
        backgroundColor: Colors.grey[200],
        title: const Text(
          "Cancel Order",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Are you sure?\nYou want to cancel the order?",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: "Reason for Cancellation of order",
                border: OutlineInputBorder(),
              ),
            ),
          ],
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
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back(result: "loggedOut");
            },
            child: const Text(
              "Yes",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );

    if (resultResponse == "loggedOut") {
      cancelItemDatabase(order_id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Order>>(
      future: getAllOrderItems(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No orders available.'));
        } else {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Order order = snapshot.data![index];
              return buildOrderCard(order);
            },
          );
        }
      },
    );
  }

  Widget buildOrderCard(Order order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order ID: ${order.order_id}',
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                  fontSize: 20),
            ),
            const SizedBox(height: 8),
            FutureBuilder<List<User>>(
              future: getAllUsers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('User information not available.');
                } else {
                  // Find the user corresponding to the order
                  User? user = snapshot.data!.firstWhere(
                    (user) => user.user_id == order.user_id,
                  );
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'User ID: ${order.user_id} | User Name: ${user.user_name} | User Email: ${user.user_email}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildOrderDetailRow('Delivery System', order.deliverySystem!),
                buildOrderDetailRow('Payment System', order.paymentSystem!),
                buildOrderDetailRow('Note', order.note ?? "No note"),
                buildOrderDetailRow(
                  'Total Amount',
                  '₹ ${order.totalAmount?.toStringAsFixed(2)}',
                ),
                buildOrderDetailRow('Status', order.status!),
                buildOrderDetailRow('Order Date', "${order.dateTime}"),
                buildOrderDetailRow('Shipment Address', order.shipmentAddress!),
                buildOrderDetailRow('Phone Number', order.phoneNumber!),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text(
                  'Order Items:',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                      fontSize: 16),
                ),
                const Spacer(),
                buildActionButton('Items Delivered', Colors.blue, () {
                  showDialogForParcelConfirmation(order);
                }),
                const SizedBox(width: 20),
                buildActionButton('Cancel Order', Colors.red, () {
                  cancelOrder(order.order_id!);
                }),
              ],
            ),
            displayClickedOrderItems(order.selectedItems!),
          ],
        ),
      ),
    );
  }

  Widget buildOrderDetailRow(String label, String value) {
    return Row(
      children: [
        Text('$label: ',
            style: const TextStyle(
              fontSize: 16,
            )),
        Text(
          value,
          style: const TextStyle(color: Colors.white70),
        ),
      ],
    );
  }

  Widget buildActionButton(String text, Color color, VoidCallback onPressed) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: IntrinsicWidth(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget displayClickedOrderItems(String selectedItems) {
    List<String> clickedOrderItemsInfo = selectedItems.split("||");

    return Column(
      children: List.generate(clickedOrderItemsInfo.length, (index) {
        Map<String, dynamic> itemInfo =
            jsonDecode(clickedOrderItemsInfo[index]);

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 4,
          color: Colors.white12,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'image_upload/${itemInfo["image"]}',
                    height: 120,
                    width: 120,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.broken_image_outlined,
                        size: 100,
                        color: Colors.grey,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ID: ${itemInfo["item_id"]}'),
                      Text('Name: ${itemInfo["name"]}'),
                      Text("Size: ${itemInfo["size"] ?? "Size N/A"} | Color: ${itemInfo["color"] ?? "Color N/A"}"),
                      Text("₹ ${itemInfo["price"] ?? "0"} x ${itemInfo["quantity"] ?? "0"} = ₹ ${(itemInfo["price"] ?? 0) * (itemInfo["quantity"] ?? 0)}"),
                      Text('Qty: ${itemInfo["quantity"]}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
