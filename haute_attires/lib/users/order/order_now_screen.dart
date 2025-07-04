import 'package:haute_attires/users/model/app_colors.dart';
import 'package:haute_attires/users/controllers/order_now_controller.dart';
import 'package:haute_attires/users/order/order_confirmation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:haute_attires/users/order/payment_gateway_screen.dart';

// ignore: must_be_immutable
class OrderNowScreen extends StatelessWidget {
  final List<Map<String, dynamic>>? selectedCartListItemsInfo;
  final double? totalAmount;
  final List<int>? selectedCartIDs;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  OrderNowController orderNowController = Get.put(OrderNowController());
  List<String> deliverySystemNamesList = ["Shipping"];
  List<String> paymentSystemNamesList = [
    "Google Pay",
    "Card Payment",
    "Cash on Delivery"
  ];

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController shipmentAddressController = TextEditingController();
  TextEditingController noteToSellerController = TextEditingController();

  OrderNowScreen({
    super.key,
    this.selectedCartListItemsInfo,
    this.totalAmount,
    this.selectedCartIDs,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.sunsetOrange,
        title: const Text("Order Now"),
        titleSpacing: 0,
      ),
      body: Center(
        child: SizedBox(
          width: 1200,
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                //display selected items from cart list
                displaySelectedItemsFromUserCart(),
            
                const SizedBox(height: 30),
            
                //delivery system
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Delivery System:',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: deliverySystemNamesList.map((deliverySystemName) {
                      return Obx(() => RadioListTile<String>(
                            tileColor: Colors.black12,
                            dense: true,
                            activeColor: Color.fromRGBO(224, 145, 69, 1.0),
                            title: Text(
                              deliverySystemName,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                            ),
                            value: deliverySystemName,
                            groupValue: orderNowController.deliverySys,
                            onChanged: (newDeliverySystemValue) {
                              orderNowController
                                  .setDeliverySystem(newDeliverySystemValue!);
                            },
                          ));
                    }).toList(),
                  ),
                ),
            
                const SizedBox(height: 16),
            
                //payment system
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment System:',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: paymentSystemNamesList.map((paymentSystemName) {
                      return Obx(() => RadioListTile<String>(
                            tileColor: Colors.black12,
                            dense: true,
                            activeColor: Color.fromRGBO(224, 145, 69, 1.0),
                            title: Text(
                              paymentSystemName,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                            ),
                            value: paymentSystemName,
                            groupValue: orderNowController.paymentSys,
                            onChanged: (newPaymentSystemValue) {
                              orderNowController
                                  .setPaymentSystem(newPaymentSystemValue!);
                            },
                          ));
                    }).toList(),
                  ),
                ),
            
                const SizedBox(height: 16),
            
                //phone number
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Phone Number:',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: TextFormField(
                    style: const TextStyle(color: Colors.black),
                    controller: phoneNumberController,
                    decoration: InputDecoration(
                      hintText: 'Your Contact Number..',
                      hintStyle: const TextStyle(
                        color: Colors.black87,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                    ),
                    // Validation logic
                    validator: (value) {
                      // Trim whitespace
                      String trimmedValue = value?.trim() ?? '';
            
                      if (trimmedValue.isEmpty) {
                        return 'Please enter your contact number.';
                      }
            
                      // Check if the input is numeric
                      if (!RegExp(r'^[0-9]+$').hasMatch(trimmedValue)) {
                        return 'Phone number must contain only digits.';
                      }
            
                      // Check if the phone number is exactly 10 digits and starts with 7, 8, or 9
                      if (trimmedValue.length != 10) {
                        return 'Phone number must be exactly 10 digits long.';
                      }
            
                      final RegExp regex = RegExp(r'^[789]\d{9}$');
                      if (!regex.hasMatch(trimmedValue)) {
                        return 'Please enter a valid 10-digit phone number starting with 7, 8, or 9.';
                      }
            
                      return null; // Return null if validation passes
                    },
                  ),
                ),

                const SizedBox(height: 16),
            
                //shipment address
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Shipment Address:',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: TextFormField(
                    style: const TextStyle(color: Colors.black),
                    controller: shipmentAddressController,
                    decoration: InputDecoration(
                      hintText: 'Your Shipment Address..',
                      hintStyle: const TextStyle(
                        color: Colors.black87,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                    ),
                    // Validation logic
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your shipment address.';
                      }
                      if (value.length < 10) {
                        return 'Address must be at least 10 characters long.';
                      }
                      if (value.length > 100) {
                        // Optional max length check
                        return 'Address must not exceed 100 characters.';
                      }
                      return null; // Return null if validation passes
                    },
                  ),
                ),
            
                const SizedBox(height: 16),
            
                //note to seller
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Note to Seller:',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: TextField(
                    style: const TextStyle(color: Colors.black),
                    controller: noteToSellerController,
                    decoration: InputDecoration(
                      hintText:
                          'Any note you would like to write to the seller (Optional)...',
                      hintStyle: const TextStyle(
                        color: Colors.black87,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
            
                const SizedBox(height: 30),
            
                //pay amount now btn
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: SizedBox(
                      width: 500,
                      child: Material(
                        color: Color.fromRGBO(224, 145, 69, 1.0),
                        borderRadius: BorderRadius.circular(30),
                        child: InkWell(
                          onTap: () {
                            if (_formKey.currentState?.validate() == true) {
                              Get.to(
                                PaymentGatewayScreen(
                                  paymentSystem: orderNowController
                                      .paymentSys, // Selected payment method
                                  totalAmount: totalAmount!,
                                ),
                              )?.then((result) {
                                if (result == 'Payment Successful') {
                                  // Navigate to order confirmation after successful payment
                                  Get.to(OrderConfirmationScreen(
                                    selectedCartIDs: selectedCartIDs,
                                    selectedCartListItemsInfo:
                                        selectedCartListItemsInfo,
                                    totalAmount: totalAmount,
                                    deliverySystem:
                                        orderNowController.deliverySys,
                                    paymentSystem: orderNowController.paymentSys,
                                    phoneNumber: phoneNumberController.text,
                                    shipmentAddress:
                                        shipmentAddressController.text,
                                    note: noteToSellerController.text,
                                  ));
                                }
                              }
                            );
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Please complete the form.");
                            }
                          },
                          borderRadius: BorderRadius.circular(30),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "₹ ${totalAmount!.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                const Text(
                                  "Pay Amount Now",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  displaySelectedItemsFromUserCart() {
    return Column(
      children: List.generate(selectedCartListItemsInfo!.length, (index) {
        Map<String, dynamic> eachSelectedItem =
            selectedCartListItemsInfo![index];

        return Container(
          width: 900,
          margin: EdgeInsets.fromLTRB(
            16,
            index == 0 ? 16 : 8,
            16,
            index == selectedCartListItemsInfo!.length - 1 ? 16 : 8,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                offset: Offset(0, 0),
                blurRadius: 6,
                color: Colors.black,
              ),
            ],
          ),
          child: Row(
            children: [
              //image
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                child: Image.asset(
                  'image_upload/${eachSelectedItem["image"]}', // Asset image path
                  height: 150,
                  width: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTraceError) {
                    return const Center(
                      child: Icon(
                        Icons.broken_image_outlined,
                      ),
                    );
                  },
                ),
              ),

              //name
              //size
              //price
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //name
                      Text(
                        eachSelectedItem["name"],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 16),

                      //size + color
                      Text(
                        eachSelectedItem["size"]
                                .replaceAll("[", "")
                                .replaceAll("]", "") +
                            "\n" +
                            eachSelectedItem["color"]
                                .replaceAll("[", "")
                                .replaceAll("]", ""),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.redAccent,
                        ),
                      ),

                      const SizedBox(height: 16),

                      //price
                      Text(
                        "₹  ${eachSelectedItem["price"]}",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        "₹ ${eachSelectedItem["price"]} x ₹ ${eachSelectedItem["quantity"]} = ₹ ${eachSelectedItem["totalAmount"]}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //quantity
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Q: ${eachSelectedItem["quantity"]}",
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.pink,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
