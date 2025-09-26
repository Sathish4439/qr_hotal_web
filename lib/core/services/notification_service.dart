import 'package:ecommerce_flutter/core/common_wid/widget.dart';
import 'package:ecommerce_flutter/core/services/endpoints.dart';
import 'package:ecommerce_flutter/core/services/local_storage.dart';
import 'package:ecommerce_flutter/feature/home/controller/home_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class PushService {
  var homecontroller = Get.put(HomeController());
  Future<void> initFCM() async {
    // Only initialize after Firebase is ready
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    if (kIsWeb) {
      // Ask user for permission on web
      await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      // Get FCM token (VAPID key required)
      String? token = await messaging.getToken(
        vapidKey: EndPoints.vapKey,
      );

      if (kDebugMode) print("Web FCM Token: $token");

      if (token != null) {
        await SecureStorageHelper.saveValue(
            SecureStorageHelper.fcmToken, token);
        homecontroller.sendTokenToBackend();
      }

      // Foreground listener on web
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message.notification != null) {
          showNotificationDialog(
            message.notification!.title ?? "",
            message.notification!.body ?? "",
          );
        }
        if (kDebugMode) {
          print("Foreground message: ${message.notification?.title}");
        }
      });

      // Background messages require firebase-messaging-sw.js (already in web folder)
      // onMessageOpenedApp works normally
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print("Notification clicked: ${message.notification?.title}");
      });
    } else {
      // Mobile (iOS/Android) FCM
      await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      String? token = await messaging.getToken();

      if (kDebugMode) print("Mobile FCM Token: $token");

      if (token != null) {
        await SecureStorageHelper.saveValue(
            SecureStorageHelper.fcmToken, token);
        homecontroller.sendTokenToBackend();
      }

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message.notification != null) {
          showNotificationDialog(
            message.notification!.title ?? "",
            message.notification!.body ?? "",
          );
        }
        if (kDebugMode)
          print("Foreground message: ${message.notification?.title}");
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print("Notification clicked: ${message.notification?.title}");
      });

      FirebaseMessaging.instance.getInitialMessage().then((message) {
        if (message != null) {
          print("App opened from notification: ${message.notification?.title}");
        }
      });
    }
  }
}
