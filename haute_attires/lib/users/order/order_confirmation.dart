import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:haute_attires/api_connection/api_connection.dart';
import 'package:haute_attires/users/fragments/dashboard_of_fragments.dart';
import 'package:haute_attires/users/model/order.dart';
import 'package:haute_attires/users/userPreferences/current_user.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class OrderConfirmationScreen extends StatelessWidget {
  final List<int>? selectedCartIDs;
  final List<Map<String, dynamic>>? selectedCartListItemsInfo;
  final double? totalAmount;
  final String? deliverySystem;
  final String? paymentSystem;
  final String? phoneNumber;
  final String? shipmentAddress;
  final String? note;
  final String? categories;

  OrderConfirmationScreen({
    super.key,
    this.selectedCartIDs,
    this.selectedCartListItemsInfo,
    this.totalAmount,
    this.deliverySystem,
    this.paymentSystem,
    this.phoneNumber,
    this.shipmentAddress,
    this.note,
    this.categories,
  });

  final CurrentUser currentUser = Get.put(CurrentUser());

  saveNewOrderInfo() async {
    List<String> formattedItems = selectedCartListItemsInfo!.map((item) {
      item['color'] =
          item['color'].replaceAll(RegExp(r'[\[\]]'), ''); // Remove brackets
      item['size'] =
          item['size'].replaceAll(RegExp(r'[\[\]]'), ''); // Remove brackets
      return jsonEncode(item);
    }).toList();

    String selectedItemsString = formattedItems.join("||");

    Order order = Order(
      user_id: currentUser.user.user_id,
      selectedItems: selectedItemsString,
      deliverySystem: deliverySystem,
      paymentSystem: paymentSystem,
      note: note,
      totalAmount: totalAmount,
      status: "new",
      dateTime: DateTime.now(),
      shipmentAddress: shipmentAddress,
      phoneNumber: phoneNumber,
    );

    try {
      var res = await http.post(
        Uri.parse(API.addOrder),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(order.toJson()),
      );

      print("Response status: ${res.statusCode}");
      print("Response body: ${res.body}");

      if (res.statusCode == 200) {
        var responseBodyOfAddNewOrder =
            jsonDecode(res.body);

        if (responseBodyOfAddNewOrder["success"] == true) {
          for (int cartID in selectedCartIDs!) {
            await deleteSelectedItemsFromUserCartList(cartID);
          }
          Fluttertoast.showToast(
              msg: "Your new order has been placed successfully.");
          Get.to(DashboardOfFragments());
        } else {
          Fluttertoast.showToast(msg: "Error: Order could not be placed.");
        }
      } else {
        Fluttertoast.showToast(msg: "Error: Server response code not 200.");
      }
    } catch (errorMsg) {
      Fluttertoast.showToast(msg: "Error: $errorMsg");
    }
  }

  deleteSelectedItemsFromUserCartList(int cartID) async {
    try {
      print("Deleting cart item ID: $cartID");
      var res = await http.post(
        Uri.parse(API.deleteSelectedItemsFromCartList),
        body: {
          "cart_id": cartID.toString(),
        },
      );

      if (res.statusCode == 200) {
        var responseBodyFromDeleteCart = jsonDecode(res.body);
        if (responseBodyFromDeleteCart["success"] == true) {
          // Fluttertoast.showToast(
          //     msg: "Your new order has been placed successfully.");
          Get.to(DashboardOfFragments());
        } else {
          Fluttertoast.showToast(msg: "Error: Could not delete cart item.");
        }
      } else {
        Fluttertoast.showToast(msg: "Error: Server response code not 200.");
      }
    } catch (errorMessage) {
      Fluttertoast.showToast(msg: "Error: $errorMessage");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Confirmation"),
        backgroundColor: Colors.deepPurple, // Changed color to deep purple
      ),
      backgroundColor: Colors.grey[900], // Dark background
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 200,),
                const Text(
                  'Order Confirmed!',
                  style: TextStyle(
                    color: Colors.greenAccent, // Changed to a brighter green
                    fontSize: 28, // Increased font size
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Payment Method: $paymentSystem',
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
                Text(
                  'Delivery System: $deliverySystem',
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 20),
                Material(
                  elevation: 10, // Increased elevation for better shadow
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.deepPurpleAccent, // Button background color
                  child: InkWell(
                    onTap: () {
                      print("Button tapped, saving order...");
                      saveNewOrderInfo();
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                      child: Text(
                        "Confirm & Place Order",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18, // Increased font size for button text
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
