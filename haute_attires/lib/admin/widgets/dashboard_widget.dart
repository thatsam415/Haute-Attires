import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:haute_attires/api_connection/api_connection.dart';
import 'package:haute_attires/users/model/order.dart';
import 'package:http/http.dart' as http;

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({super.key});

  @override
  _DashboardWidgetState createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  int pendingOrdersCount = 0;
  int deliveredOrdersCount = 0;
  int pendingOrdersLength = 0;
  int orderTableLength = 0;
  int cancelOrdersLength = 0;
  int historyOrdersLength = 0;

  @override
  void initState() {
    super.initState();
    fetchOrderData();
    fetchOrdersForChart();
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
      print("Error:::: $errorMsg");
    }
    return allOrderItemsList;
  }

  Future<void> fetchOrderData() async {
    List<Order> pendingOrders = await getAllOrderItems();
    List<Order> deliveredOrders = await getAllOrderHisItems();
    
    DateTime now = DateTime.now();
    DateTime startOfLastMonth;
    DateTime endOfLastMonth;

    if (now.month == 1) {
      startOfLastMonth = DateTime(now.year - 1, 12, 1);
      endOfLastMonth = DateTime(now.year - 1, 12, 31, 23, 59, 59);
    } else {
      startOfLastMonth = DateTime(now.year, now.month - 1, 1);
      endOfLastMonth =
          DateTime(now.year, now.month, 1).subtract(Duration(seconds: 1));
    }

    List<Order> recentDeliveredOrders = deliveredOrders.where((order) {
      return order.dateTime != null &&
          order.dateTime!.isAfter(startOfLastMonth) &&
          order.dateTime!.isBefore(endOfLastMonth);
    }).toList();

    setState(() {
      pendingOrdersCount = pendingOrders.length;
      deliveredOrdersCount = recentDeliveredOrders.length;
    });
  }

    Future<List<Order>> getAllOrderTableItems() async {
    List<Order> allOrderItemsList = [];

    try {
      var res = await http.post(Uri.parse(API.allOrderTable));
      if (res.statusCode == 200) {
        var responseBodyOfAllOrder = jsonDecode(res.body);
        if (responseBodyOfAllOrder["success"] == true) {
          print(res.body);
          for (var eachRecord
              in (responseBodyOfAllOrder["allOrderTable"] as List)) {
            allOrderItemsList.add(Order.fromJson(eachRecord));
          }
        }
      } else {
        Fluttertoast.showToast(msg: "Error, status code is not 200");
      }
    } catch (errorMsg) {
      print("Error::: $errorMsg");
    }

    return allOrderItemsList;
  }

  Future<List<Order>> getAllOrderCanItems() async {
    List<Order> allOrderItemsList = [];

    try {
      var res = await http.post(Uri.parse(API.allCancel));
      if (res.statusCode == 200) {
        var responseBodyOfAllOrder = jsonDecode(res.body);
        if (responseBodyOfAllOrder["success"] == true) {
          for (var eachRecord in (responseBodyOfAllOrder["allCancel"] as List)) {
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

  Future<List<Order>> getAllOrderHisItems() async {
    List<Order> allOrderItemsList = [];

    try {
      var res = await http.post(Uri.parse(API.allOld));
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

  Future<void> fetchOrdersForChart() async {
    pendingOrdersLength = (await getAllOrderItems()).length;
    orderTableLength = (await getAllOrderTableItems()).length;
    cancelOrdersLength = (await getAllOrderCanItems()).length;
    historyOrdersLength = (await getAllOrderHisItems()).length;

    setState(() {}); // Trigger re-render to show chart data
  }

 @override
  Widget build(BuildContext context) {
    // Example admin dashboard colors
    const Color backgroundColor = Color(0xFFf5f5f5); // Light grey
    const Color cardColor = Color(0xFFffffff); // White card
    const Color headerColor = Color(0xFF333333); // Dark text for header
    const Color textColor = Color(0xFF666666); // Light text for content
    const Color highlightColor = Color(0xFFff5252); // Highlight color for numbers

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dashboard heading
              const Text(
                "Admin Dashboard",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: headerColor,
                ),
              ),
              const SizedBox(height: 16),

              // First Row: Pending Items and Last Month Orders Delivered
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Pending Orders
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Pending Orders",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: headerColor,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            pendingOrdersCount.toString(), // Updated Value
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: highlightColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Last Month Delivered
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Orders Delivered (Last Month)",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: headerColor,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            deliveredOrdersCount.toString(), // Updated Value
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: highlightColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Container(
  height: 300, // Graph height
  padding: const EdgeInsets.all(20),
  decoration: BoxDecoration(
    color: cardColor,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.2),
        spreadRadius: 2,
        blurRadius: 5,
      ),
    ],
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Sales Overview",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: headerColor,
        ),
      ),
      const SizedBox(height: 8),
      Expanded(
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 20, // Set the maximum value for the chart
            barGroups: [
              BarChartGroupData(
                x: 1,
                barRods: [
                  BarChartRodData(
                    toY: orderTableLength.toDouble(), 
                    width: 15,
                    borderRadius: BorderRadius.circular(6),
                    gradient: const LinearGradient(
                      colors: [Colors.blue, Colors.lightBlueAccent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ],
              ),
              BarChartGroupData(
                x: 2,
                barRods: [
                  BarChartRodData(
                    toY: pendingOrdersLength.toDouble(),
                    width: 15,
                    borderRadius: BorderRadius.circular(6),
                    gradient: const LinearGradient(
                      colors: [Colors.green, Colors.lightGreenAccent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ],
              ),
              BarChartGroupData(
                x: 3,
                barRods: [
                  BarChartRodData(
                    toY: historyOrdersLength.toDouble(),
                    width: 15,
                    borderRadius: BorderRadius.circular(6),
                    gradient: const LinearGradient(
                      colors: [Colors.orange, Colors.deepOrangeAccent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ],
              ),
              BarChartGroupData(
                x: 4,
                barRods: [
                  BarChartRodData(
                    toY: cancelOrdersLength.toDouble(),
                    width: 15,
                    borderRadius: BorderRadius.circular(6),
                    gradient: const LinearGradient(
                      colors: [Colors.purple, Colors.purpleAccent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ],
              ),
            ],
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40, // Space for the titles on the left
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toString(),
                      style: const TextStyle(fontSize: 12),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 32, // Space for the titles on the bottom
                  getTitlesWidget: (value, meta) {
                    switch (value.toInt()) {
                      case 1:
                        return const Text('Total Orders');
                      case 2:
                        return const Text('Pending');
                      case 3:
                        return const Text('Delivered');
                      case 4:
                        return const Text('Cancelled');
                      default:
                        return const Text('');
                    }
                  },
                ),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawHorizontalLine: true,
              horizontalInterval: 5,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.grey.withOpacity(0.3),
                  strokeWidth: 1,
                );
              },
            ),
          ),
        ),
      ),
    ],
  ),
)

            ],
          ),
        ),
      ),
    );
  }
}
