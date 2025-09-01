
import 'package:shared_preferences/shared_preferences.dart';

class SecureStorageHelper {
  // Keys for all stored values
  static const String keyAccessToken = "ACCESS_TOKEN";
  static const String keyRefreshToken = "REFRESH_TOKEN";
  static const String keyUserId = "CUSTOMER_ID";
  static const String fcmToken = "FCM_TOKEN";

  // Save a value
  static Future<void> saveValue(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  // Read a value
  static Future<String?> readValue(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  // Delete a value
  static Future<void> deleteValue(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  // Delete all values
  static Future<void> deleteAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
