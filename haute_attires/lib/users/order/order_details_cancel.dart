import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:haute_attires/api_connection/api_connection.dart';
import 'package:haute_attires/users/model/cancel.dart';
import 'package:intl/intl.dart';
import 'package:haute_attires/users/model/app_colors.dart'; 
import 'package:haute_attires/users/model/order.dart';
import 'package:http/http.dart' as http;

class OrderDetailsCancel extends StatefulWidget {
  final Order? clickedOrderInfo;

  const OrderDetailsCancel({
    super.key,
    this.clickedOrderInfo,
  });

  @override
  State<OrderDetailsCancel> createState() => _OrderDetailsCancelState();
}

class _OrderDetailsCancelState extends State<OrderDetailsCancel> {
  List<Cancel> cancelDetails = [];

  @override
  void initState() {
    super.initState();
    // Fetch cancellation data when the widget is initialized
    getCancelData(widget.clickedOrderInfo!.order_id!).then((data) {
      setState(() {
        cancelDetails = data;
      });
    });
  }

  Future<List<Cancel>> getCancelData(int order_id) async {
    List<Cancel> cancelDetails = [];

    try {
      var res = await http.post(Uri.parse(API.readCancelTable), body: {
        "order_id": order_id.toString(),
      });

      if (res.statusCode == 200) {
        var responseBodyOfAllUsers = jsonDecode(res.body);
        if (responseBodyOfAllUsers["success"] == true) {
          for (var eachRecord in (responseBodyOfAllUsers["cancelData"] as List)) {
            cancelDetails.add(Cancel.fromJson(eachRecord));
          }
        }
      } else {
        Fluttertoast.showToast(msg: "Error, status code is not 200");
      }
    } catch (errorMsg) {
      print("Error:: $errorMsg");
    }

    return cancelDetails;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: AppColors.goldenSand,
        title: Text(
          DateFormat("dd MMMM, yyyy - hh:mm a")
              .format(widget.clickedOrderInfo!.dateTime!),
          style: const TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Order Summary',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.deepSeaBlue,
                  ),
                ),
                const Divider(
                  thickness: 2,
                  color: Colors.grey,
                ),
                const SizedBox(height: 10),

                // Display Items in the Order
                Center(child: displayClickedOrderItems()),

                const SizedBox(height: 10),
                const Divider(
                  thickness: 2,
                  color: Colors.grey,
                ),

                // Payment & Delivery Information
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Cancellation Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.deepSeaBlue,
                    ),
                  ),
                ),
                displayCancellationDetails(),
                const Divider(
                  thickness: 2,
                  color: Colors.grey,
                ),

                // Display Cancellation Details
                const SizedBox(height: 10),
                const Text(
                  'Payment & Delivery Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.deepSeaBlue,
                  ),
                ),
                const SizedBox(height: 10),
                buildDetailsRows(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDetailsRows() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              showTitleText("Phone Number:"),
              showContentText(widget.clickedOrderInfo!.phoneNumber!),
              const SizedBox(height: 16),

              showTitleText("Shipment Address:"),
              showContentText(widget.clickedOrderInfo!.shipmentAddress!),
              const SizedBox(height: 16),

              showTitleText("Payment System:"),
              showContentText(widget.clickedOrderInfo!.paymentSystem!),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              showTitleText("Total Amount:"),
              showContentText("₹ ${widget.clickedOrderInfo!.totalAmount}"),
              const SizedBox(height: 16),

              showTitleText("Delivery System:"),
              showContentText(widget.clickedOrderInfo!.deliverySystem!),
              const SizedBox(height: 16),

              showTitleText("Note to Seller:"),
              showContentText(widget.clickedOrderInfo!.note!),
            ],
          ),
        ),
      ],
    );
  }

  Widget showTitleText(String titleText) {
    return Text(
      titleText,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: Colors.black,
      ),
    );
  }

  Widget showContentText(String contentText) {
    return Text(
      contentText,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.black54,
      ),
    );
  }

  Widget displayClickedOrderItems() {
    List<String> clickedOrderItemsInfo = widget.clickedOrderInfo!.selectedItems!.split("||");

    return Column(
      children: List.generate(clickedOrderItemsInfo.length, (index) {
        Map<String, dynamic> itemInfo = jsonDecode(clickedOrderItemsInfo[index]);

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
          child: FractionallySizedBox(
            widthFactor: 1,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'image_upload/${itemInfo["image"]}',
                      height: 50,
                      width: 50,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTraceError) {
                        return const Icon(
                          Icons.broken_image_outlined,
                          size: 50,
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
                        Text(
                          itemInfo["name"],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              "${itemInfo["size"]} | ${itemInfo["color"]}",
                              style: const TextStyle(color: Colors.black54),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "₹ ${itemInfo["price"]} x ${itemInfo["quantity"]} = ₹ ${itemInfo["totalAmount"]}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        "Qty: ${itemInfo["quantity"]}",
                        style: const TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget displayCancellationDetails() {
  return FutureBuilder<List<Cancel>>(
    future: getCancelData(widget.clickedOrderInfo!.order_id!),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return const Text('Error loading cancellation details');
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Text('No cancellation details available');
      } else {
        // Display cancellation details in a simple layout without cards
        Cancel cancelInfo = snapshot.data!.first;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            showTitleText("Cancelled By:"),
            showContentText(cancelInfo.cancel_by),
            const SizedBox(height: 8),

            showTitleText("Reason:"),
            showContentText(cancelInfo.reason),
          ],
        );
      }
    },
  );
}
}
