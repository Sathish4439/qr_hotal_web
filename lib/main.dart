import 'package:ecommerce_flutter/core/services/endpoints.dart';
import 'package:ecommerce_flutter/core/services/notification_service.dart';
import 'package:ecommerce_flutter/core/theme/app_theme.dart';
import 'package:ecommerce_flutter/feature/home/view/tabbar.dart';
import 'package:ecommerce_flutter/firebase_options.dart';
import 'package:ecommerce_flutter/utils/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

// Global variable to use anywhere
String? tableId;

// Background FCM handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _extractHotelAndTable();
  await Firebase.initializeApp(
    options:
        DefaultFirebaseOptions.currentPlatform, // from firebase_options.dart
  );

  await PushService().initFCM();

  runApp(const EcommerceFlutterApp());
}

// Extract tableId from URL query parameter (web)
void _extractHotelAndTable() {
  final uri = Uri.base;
  tableId = uri.queryParameters['tableId'] ?? '';
  debugPrint("Table ID: $tableId");
}

class EcommerceFlutterApp extends StatelessWidget {
  const EcommerceFlutterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: GetMaterialApp(
        title: 'DhiGrowth',
        theme: AppTheme.lightTheme,
        routes: routes,
        debugShowCheckedModeBanner: false,
        home: const FRTabbarScreen(),
      ),
    );
  }
}
