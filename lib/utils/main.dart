import 'package:ecommerce_flutter/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_flutter/utils/routes.dart';
import 'package:ecommerce_flutter/feature/home/view/tabbar.dart';
import 'package:get/get.dart';

// Global variables so you can use them anywhere

String? tableId;

void main() {
  _extractHotelAndTable();
  runApp(const EcommerceFlutterApp());
}

void _extractHotelAndTable() {
  final uri = Uri.base; // Current page URL
 
  tableId = uri.queryParameters['tableId'];

  
  debugPrint("Table ID: $tableId");
}

class EcommerceFlutterApp extends StatelessWidget {
  const EcommerceFlutterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'DhiGrowth',
    theme: AppTheme.lightTheme,
      routes: routes,
      debugShowCheckedModeBanner: false,
      home: const FRTabbarScreen(),
    );
  }
}
