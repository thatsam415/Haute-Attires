import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:haute_attires/api_connection/api_connection.dart';
import 'package:haute_attires/users/model/order.dart';
import 'package:haute_attires/users/model/user.dart';
import 'package:http/http.dart' as http;

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  
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

 Future<List<Order>> getAllOrderItems() async {
  List<Order> allOrderItemsList = [];

  try {
    var res = await http.post(Uri.parse(API.allOld));
    print("Response status: ${res.statusCode}");
    // print("Response body: ${res.body}"); // Log the response body

    if (res.statusCode == 200) {
      var responseBodyOfAllOrder = jsonDecode(res.body);
      if (responseBodyOfAllOrder["success"] == true) {
        for (var eachRecord in (responseBodyOfAllOrder["allOld"] as List)) {
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


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          children: [
            const SizedBox(height: 18),
            FutureBuilder<List<Order>>(
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
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Order order = snapshot.data![index];
                      return buildOrderCard(order);
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
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
                fontSize: 20,
              ),
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
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
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
                  '\$${order.totalAmount?.toStringAsFixed(2)}',
                ),
                buildOrderDetailRow('Status', order.status!),
                buildOrderDetailRow('Order Date', "${order.dateTime}"),
                buildOrderDetailRow('Shipment Address', order.shipmentAddress!),
                buildOrderDetailRow('Phone Number', order.phoneNumber!),
              ],
            ),

            displayClickedOrderItems(order.selectedItems!),
          ],
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

  Widget buildOrderDetailRow(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        Text(
          value,
          style: const TextStyle(color: Colors.white70),
        ),
      ],
    );
  }
}
