import 'package:flutter/material.dart';
import 'package:ecommerce_flutter/routes.dart';
import 'package:ecommerce_flutter/screens/tabbar/tabbar.dart';
import 'package:ecommerce_flutter/theme.dart';

// Global variables so you can use them anywhere
String? hotelId;
String? tableId;

void main() {
  _extractHotelAndTable();
  runApp(const EcommerceFlutterApp());
}

void _extractHotelAndTable() {
  final uri = Uri.base; // Current page URL
  hotelId = uri.queryParameters['hotelId'];
  tableId = uri.queryParameters['tableId'];

  debugPrint("Hotel ID: $hotelId");
  debugPrint("Table ID: $tableId");
}

class EcommerceFlutterApp extends StatelessWidget {
  const EcommerceFlutterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DhiGrowth',
      theme: appTheme(),
      routes: routes,
      debugShowCheckedModeBanner: false,
      home: const FRTabbarScreen(),
    );
  }
}
