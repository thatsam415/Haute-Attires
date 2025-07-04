import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:haute_attires/users/model/app_colors.dart'; 
import 'package:haute_attires/users/model/order.dart';
import 'package:screenshot/screenshot.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb

// Add this import for Flutter web
import 'dart:html' as html;

class OrderDetailsHis extends StatefulWidget {
  final Order? clickedOrderInfo;

  const OrderDetailsHis({
    super.key,
    this.clickedOrderInfo,
  });

  @override
  State<OrderDetailsHis> createState() => _OrderDetailsHisState();
}

class _OrderDetailsHisState extends State<OrderDetailsHis> {
  final ScreenshotController _screenshotController = ScreenshotController();

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
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _downloadOrderDetails,
          ),
        ],
      ),
      body: Screenshot(
        controller: _screenshotController,
        child: Center(
          child: Container(
            width: 900,
            color: Colors.white, // Set background color to white to avoid transparency
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
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Header Row
      const Row(
        children: [
          Expanded(flex: 4, child: Text('Item', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: Text('Size', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: Text('Color', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 1, child: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: Text('Price', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
      const Divider(thickness: 1.5),

      // Items List
      ...clickedOrderItemsInfo.map((itemInfoStr) {
        Map<String, dynamic> itemInfo = jsonDecode(itemInfoStr);

        return Row(
          children: [
            Expanded(
              flex: 4,
              child: Text(itemInfo["name"], maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
            Expanded(flex: 2, child: Text(itemInfo["size"] ?? "N/A")),
            Expanded(flex: 2, child: Text(itemInfo["color"] ?? "N/A")),
            Expanded(flex: 1, child: Text(itemInfo["quantity"].toString())),
            Expanded(flex: 2, child: Text("₹ ${itemInfo["price"]}")),
            Expanded(flex: 2, child: Text("₹ ${itemInfo["totalAmount"]}")),
          ],
        );
      }).toList(),

      const Divider(thickness: 1.5),
    ],
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
            onLayout: (PdfPageFormat format) async => await Printing.convertHtml(
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
