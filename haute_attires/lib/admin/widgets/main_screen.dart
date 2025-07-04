import 'package:haute_attires/admin/widgets/admin_logout.dart';
import 'package:haute_attires/admin/widgets/all_items_widget.dart';
import 'package:haute_attires/admin/widgets/all_orders_widget.dart';
import 'package:haute_attires/admin/widgets/all_users_widget.dart';
import 'package:haute_attires/admin/widgets/dashboard_widget.dart';
import 'package:haute_attires/admin/modelanddata/responsive.dart';
import 'package:haute_attires/admin/widgets/order_cancel.dart';
import 'package:haute_attires/admin/widgets/order_history.dart';
import 'package:haute_attires/admin/widgets/side_menu_widget.dart';
import 'package:haute_attires/admin/widgets/upload_item_widget.dart'; // Import your other widgets
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onMenuTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  AppBar _buildAppBar() {
    String title;
    switch (_selectedIndex) {
      case 0:
        title = "Dashboard";
        break;
      case 1:
        title = "All Items";
        break;
      case 2:
        title = "Upload Item";
        break;
      case 3:
        title = "All Users";
        break;
      case 4:
        title = "All Orders";
        break;
      case 5:
        title = "All Orders History | Deliverd Items";
        break;
      case 6:
        title = "Cancelled Orders";
        break;
      case 7:
        title = "Admin Logout";
        break;
      default:
        title = "Dashboard";
    }

    return AppBar(
      title: Text(title),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      drawer: !isDesktop
          ? SizedBox(
              width: 250,
              child: SideMenuWidget(
                onMenuTap: _onMenuTap,
              ),
            )
          : null,
      appBar: _buildAppBar(), // Use the dynamic app bar
      body: SafeArea(
        child: Row(
          children: [
            if (isDesktop)
              Expanded(
                flex: 3,
                child: SizedBox(
                  child: SideMenuWidget(
                    onMenuTap: _onMenuTap,
                  ),
                ),
              ),
            Expanded(
              flex: 9,
              child: Stack(
                children: [
                  if (_selectedIndex == 0) DashboardWidget(),
                  if (_selectedIndex == 1) AllItemsWidget(),
                  if (_selectedIndex == 2) UploadItemWidget(),
                  if (_selectedIndex == 3) AllUsersWidget(),
                  if (_selectedIndex == 4) AllOrdersWidget(),
                  if (_selectedIndex == 5) OrderHistory(),
                  if (_selectedIndex == 6) OrderCancel(), 
                  if (_selectedIndex == 7) AdminLogout(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
