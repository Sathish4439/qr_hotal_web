import 'dart:html' as html;
import 'dart:convert';

class CustomHttpClient {
  static Future<Map<String, dynamic>> get(String url) async {
    try {
      // Create a new request
      final request = html.HttpRequest();

      // Open the request
      request.open('GET', url);

      // Add headers to bypass ngrok warning
      request.setRequestHeader('ngrok-skip-browser-warning', 'true');
      request.setRequestHeader('ngrok-skip-browser-warning', 'any');
      request.setRequestHeader(
          'User-Agent', 'Mozilla/5.0 (compatible; API-Client/1.0)');
      request.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
      request.setRequestHeader('Accept', 'application/json');
      request.setRequestHeader('Content-Type', 'application/json');

      // Send the request
      request.send();

      // Wait for the response
      await request.onLoad.first;

      if (request.status == 200) {
        final responseText = request.responseText;
        print('✅ Custom HTTP Response: $responseText');

        // Check if response is ngrok warning page
        if (responseText.contains('ngrok') &&
            responseText.contains('<!DOCTYPE html>')) {
          print('⚠️ Still getting ngrok warning page');
          throw Exception('ngrok warning page received');
        }

        return json.decode(responseText);
      } else {
        throw Exception('HTTP ${request.status}: ${request.statusText}');
      }
    } catch (e) {
      print('❌ Custom HTTP Error: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> post(String url,
      {Map<String, dynamic>? data}) async {
    try {
      final request = html.HttpRequest();

      request.open('POST', url);

      // Add headers
      request.setRequestHeader('ngrok-skip-browser-warning', 'true');
      request.setRequestHeader('ngrok-skip-browser-warning', 'any');
      request.setRequestHeader(
          'User-Agent', 'Mozilla/5.0 (compatible; API-Client/1.0)');
      request.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
      request.setRequestHeader('Accept', 'application/json');
      request.setRequestHeader('Content-Type', 'application/json');

      // Send data if provided
      if (data != null) {
        request.send(json.encode(data));
      } else {
        request.send();
      }

      await request.onLoad.first;

      if (request.status == 200) {
        final responseText = request.responseText;
        print('✅ Custom HTTP POST Response: $responseText');

        if (responseText.contains('ngrok') &&
            responseText.contains('<!DOCTYPE html>')) {
          print('⚠️ Still getting ngrok warning page');
          throw Exception('ngrok warning page received');
        }

        return json.decode(responseText);
      } else {
        throw Exception('HTTP ${request.status}: ${request.statusText}');
      }
    } catch (e) {
      print('❌ Custom HTTP POST Error: $e');
      rethrow;
    }
  }
}
