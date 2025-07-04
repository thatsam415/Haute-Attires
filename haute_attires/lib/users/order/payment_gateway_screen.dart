import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class PaymentGatewayScreen extends StatefulWidget {
  final String paymentSystem;
  final double totalAmount;

  const PaymentGatewayScreen({
    super.key,
    required this.paymentSystem,
    required this.totalAmount,
  });

  @override
  _PaymentGatewayScreenState createState() => _PaymentGatewayScreenState();
}

class _PaymentGatewayScreenState extends State<PaymentGatewayScreen> {
  int? _selectedMonth; // For selected month
  int? _selectedYear; // For selected year

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cardHolderNameController =
      TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _upiIdController = TextEditingController();
  final TextEditingController _transactionNoteController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    _selectedMonth = null; // Default value for month
    _selectedYear = null; // Default value for year
  }

  @override
  void dispose() {
    _cardHolderNameController.dispose();
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _upiIdController.dispose();
    _transactionNoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Gateway - ${widget.paymentSystem}'),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Total Amount: ₹${widget.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                if (widget.paymentSystem == 'Card Payment') ...[
                  _buildCardPaymentForm(),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _processCardPayment();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      textStyle: const TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    child: const Text('Pay Now'),
                  ),
                ] else if (widget.paymentSystem == 'Google Pay') ...[
                  _googlePayScreen(),
                ] else if (widget.paymentSystem == 'Cash on Delivery') ...[
                  ElevatedButton(
                    onPressed: () {
                      _confirmCOD();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text('Confirm COD'),
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardPaymentForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Account Holder Name Field
          TextFormField(
            controller: _cardHolderNameController,
            keyboardType: TextInputType.text,
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(
              labelText: 'Account Holder Name',
              labelStyle: TextStyle(color: Colors.black),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepOrange),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter account holder name';
              } else if (value.length < 2) {
                return 'Account holder name must be at least 2 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),

          // Card Number Field
          TextFormField(
            controller: _cardNumberController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(
              labelText: 'Card Number',
              labelStyle: TextStyle(color: Colors.black),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepOrange),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your card number';
              } else if (value.length != 16) {
                return 'Card number must be 16 digits';
              } else if (!RegExp(r'^\d+$').hasMatch(value)) {
                return 'Card number must only contain digits';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: _selectedMonth, // Variable to hold the selected month
                  onChanged: (newValue) {
                    setState(() {
                      _selectedMonth = newValue; // Update the selected month
                    });
                  },
                  items: List.generate(12, (index) {
                    return DropdownMenuItem(
                      value: index + 1,
                      child: Text('${index + 1}'), // Months from 1 to 12
                    );
                  }),
                  decoration: const InputDecoration(
                    labelText: 'Month',
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepOrange),
                    ),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a month';
                    }

                    return null;
                  },
                ),
              ),
              const SizedBox(
                  width: 20), // Spacing between month and year fields
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: _selectedYear, // Variable to hold the selected year
                  onChanged: (newValue) {
                    setState(() {
                      _selectedYear = newValue; // Update the selected year
                    });
                  },
                  items: List.generate(7, (index) {
                    int year =
                        2024 + index; // Generating years from 2024 to 2030
                    return DropdownMenuItem(
                      value: year,
                      child: Text('$year'), // Displaying the year
                    );
                  }),
                  decoration: const InputDecoration(
                    labelText: 'Year',
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepOrange),
                    ),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a year';
                    }
                    // Expiry validation logic
                    if (_selectedMonth != null && value != null) {
                      int currentYear = DateTime.now().year;
                      int currentMonth = DateTime.now().month;

                      // Check if the selected year is less than the current year
                      if (value < currentYear) {
                        return 'Card has expired';
                      }
                      // Check if the selected year is the current year and selected month is less than the current month
                      if (value == currentYear &&
                          _selectedMonth! < currentMonth) {
                        return 'Card has expired';
                      }
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          const SizedBox(height: 10), // Spacing after the dropdowns

          // CVV Field
          TextFormField(
            controller: _cvvController,
            keyboardType: TextInputType.number,
            obscureText: true,
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(
              labelText: 'CVV',
              labelStyle: TextStyle(color: Colors.black),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepOrange),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your CVV';
              } else if (value.length != 3) {
                return 'CVV must be 3 digits';
              } else if (!RegExp(r'^\d+$').hasMatch(value)) {
                return 'CVV must only contain digits';
              }
              return null;
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _processCardPayment() {
    // Logic for card payment
    Fluttertoast.showToast(
      msg: "Card payment successful!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );

    // Navigate back to order confirmation or previous screen
    Get.back(result: 'Payment Successful');
  }

  Widget _googlePayScreen() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image
          SizedBox(
            width: 400,
            height: 200,
            child: Image.asset('images/googlepay.png'),
          ),
          const SizedBox(height: 20),

          TextFormField(
            controller: _upiIdController,
            decoration: const InputDecoration(labelText: 'Enter UPI ID'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a valid UPI ID';
              }
              // UPI ID format validation regex
              String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+$';
              RegExp regExp = RegExp(pattern);
              if (!regExp.hasMatch(value)) {
                return 'Please enter a valid UPI ID format (e.g., username@bank)';
              }
              return null;
            },
          ),

          const SizedBox(height: 20),

          // Transaction Note (Optional)
          TextFormField(
            controller: _transactionNoteController,
            decoration:
                const InputDecoration(labelText: 'Add a Note (Optional)'),
          ),
          const SizedBox(height: 20),

          // // Pay Button
          ElevatedButton(
            onPressed: () {
              if (_upiIdController.text.isNotEmpty) {
                _processGooglePay(context);
              } else {
                Fluttertoast.showToast(
                  msg: "Please enter UPI ID",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            ),
            child: const Text('Pay Now', style: TextStyle(color: Colors.black),),
          ),
        ],
      ),
    );
  }

  

  void _processGooglePay(BuildContext context) {
    // Logic for Google Pay payment
    Fluttertoast.showToast(
      msg: "Google Pay payment successful!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );

    // Navigate back to order confirmation or previous screen
    Get.back(result: 'Payment Successful');
  }

  void _confirmCOD() {
    // Logic for Cash on Delivery
    Fluttertoast.showToast(
      msg: "Cash on Delivery confirmed!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );

    // Navigate back to order confirmation or previous screen
    Get.back(result: 'Payment Successful');
  }
}
