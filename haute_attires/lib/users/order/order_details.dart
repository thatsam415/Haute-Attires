import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:haute_attires/api_connection/api_connection.dart';
import 'package:intl/intl.dart';
import 'package:haute_attires/users/model/app_colors.dart'; // Import your custom colors
import 'package:haute_attires/users/model/order.dart';
import 'package:screenshot/screenshot.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:http/http.dart' as http;

// Add this import for Flutter web
import 'dart:html' as html;

class OrderDetailsScreen extends StatefulWidget {
  final Order? clickedOrderInfo;

  const OrderDetailsScreen({
    super.key,
    this.clickedOrderInfo,
  });

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();
  final TextEditingController reasonController = TextEditingController();

  void updateStatusValueInDatabase(int order_id) async {
    try {
      var response = await http.post(Uri.parse(API.updateStatusCancel), body: {
        "order_id": order_id.toString(),
      });

      if (response.statusCode == 200) {
        var responseBodyOfUpdateStatus = jsonDecode(response.body);

        if (responseBodyOfUpdateStatus["success"] == true) {
          // Fluttertoast.showToast(msg: "Item Delivered Successfully!");
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

  void cancelItemDatabase(int order_id) async {
    String cancel_by = "User";
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
                updateStatusValueInDatabase(order_id);
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
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: AppColors.goldenSand,
        title: Text(
          DateFormat("dd MMMM, yyyy - hh:mm a")
              .format(widget.clickedOrderInfo!.dateTime!),
          style: const TextStyle(fontSize: 20, color: Colors.black),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              cancelOrder(widget.clickedOrderInfo!.order_id!);
            },
            child: const Text(
              "Cancel Order",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _downloadOrderDetails,
          ),
        ],
      ),
      body: Screenshot(
        controller: _screenshotController,
        child: Container(
          color: Colors
              .white, // Set background color to white to avoid transparency
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: Order Summary
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
                  displayClickedOrderItems(),

                  const SizedBox(height: 10),
                  const Divider(
                    thickness: 2,
                    color: Colors.grey,
                  ),

                  // Payment & Delivery Information
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Payment & Delivery Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.deepSeaBlue,
                      ),
                    ),
                  ),

                  // Payment and delivery rows
                  buildDetailsRows(),
                ],
              ),
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
              // Phone Number
              showTitleText("Phone Number:"),
              showContentText(widget.clickedOrderInfo!.phoneNumber!),
              const SizedBox(height: 16),

              // Shipment Address
              showTitleText("Shipment Address:"),
              showContentText(widget.clickedOrderInfo!.shipmentAddress!),
              const SizedBox(height: 16),

              // Payment System
              showTitleText("Payment System:"),
              showContentText(widget.clickedOrderInfo!.paymentSystem!),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Total Amount
              showTitleText("Total Amount:"),
              showContentText("₹ ${widget.clickedOrderInfo!.totalAmount}"),
              const SizedBox(height: 16),

              // Delivery System
              showTitleText("Delivery System:"),
              showContentText(widget.clickedOrderInfo!.deliverySystem!),
              const SizedBox(height: 16),

              // Note to Seller
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
    List<String> clickedOrderItemsInfo =
        widget.clickedOrderInfo!.selectedItems!.split("||");

    return Column(
      children: List.generate(clickedOrderItemsInfo.length, (index) {
        Map<String, dynamic> itemInfo =
            jsonDecode(clickedOrderItemsInfo[index]);

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
                  // Image
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

                  // Item Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Item Name
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

                        // Size and Color
                        Row(
                          children: [
                            Text(
                              "${itemInfo["size"]} | ${itemInfo["color"]}",
                              style: const TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Price and Quantity
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

                  // Quantity
                  Column(
                    children: [
                      Text(
                        "Qty: ${itemInfo["quantity"]}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
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

  Future<void> _downloadOrderDetails() async {
    if (kIsWeb) {
      // Capture screenshot for the web and create a downloadable link
      Uint8List? screenshot = await _screenshotController.capture();
      if (screenshot != null) {
        final blob = html.Blob([screenshot]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download", "order_details.png")
          ..click();
        html.Url.revokeObjectUrl(url);
      }
    } else {
      // Native app logic for downloading or printing
      try {
        Uint8List? screenshot = await _screenshotController.capture();

        if (screenshot != null) {
          // Save or print the screenshot as PDF
          await Printing.layoutPdf(
            onLayout: (PdfPageFormat format) async =>
                await Printing.convertHtml(
              format: format,
              html: '''
                <img src="data:image/png;base64,${base64Encode(screenshot)}" />
              ''',
            ),
          );
        }
      } catch (e) {
        print('Error capturing the screen: $e');
      }
    }
  }
}
