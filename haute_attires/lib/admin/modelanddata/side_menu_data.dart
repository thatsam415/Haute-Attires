import 'package:haute_attires/admin/modelanddata/menu_model.dart';
import 'package:flutter/material.dart';

class SideMenuData {
  final menu = const <MenuModel>[
    MenuModel(icon: Icons.home, title: 'Dashboard'),
    MenuModel(icon: Icons.checkroom, title: 'All Items'),
    MenuModel(icon: Icons.upload, title: 'Upload Items'),
    MenuModel(icon: Icons.person, title: "All Users"),
    MenuModel(icon: Icons.shopping_cart, title: 'All Orders'),
    MenuModel(icon: Icons.history, title: 'All Orders History'),
    MenuModel(icon: Icons.cancel, title: 'Cancelled Orders'),
    MenuModel(icon: Icons.logout, title: 'Logout'),
  ];
}
