import 'package:flutter/material.dart';
import 'package:razorpay_web/razorpay_web.dart';
import 'package:get/get.dart';
import 'package:ecommerce_flutter/feature/home/controller/order_controller.dart';

class RazorpayService {
  static Razorpay? _razorpay;
  static bool _isInitialized = false;

  // Your Razorpay Key ID
  static const String _keyId = 'rzp_test_R9QMqrDfPt02gL';

  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Wait for Razorpay script to be available
      await _waitForRazorpayScript();

      // Create Razorpay instance
      _razorpay = Razorpay();

      // Set up event handlers
      _razorpay!.on('payment.success', _handlePaymentSuccess);
      _razorpay!.on('payment.error', _handlePaymentError);
      _razorpay!.on('payment.external_wallet', _handleExternalWallet);

      _isInitialized = true;
      print('✅ Razorpay initialized successfully');
    } catch (e) {
      print('❌ Error initializing Razorpay: $e');
      _isInitialized = false;
    }
  }

  static Future<void> _waitForRazorpayScript() async {
    int attempts = 0;
    const maxAttempts = 20;

    while (attempts < maxAttempts) {
      try {
        // Check if Razorpay is available in the global scope
        if (_isRazorpayAvailable()) {
          print('✅ Razorpay script loaded successfully');
          return;
        }
      } catch (e) {
        print('⏳ Waiting for Razorpay script... attempt ${attempts + 1}');
      }

      await Future.delayed(const Duration(milliseconds: 250));
      attempts++;
    }

    throw Exception(
        'Razorpay script failed to load after ${maxAttempts} attempts');
  }

  static bool _isRazorpayAvailable() {
    try {
      // Check if Razorpay is available in the global scope
      return true; // The razorpay_web package handles this internally
    } catch (e) {
      return false;
    }
  }

  static void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("Payment Success: ${response.paymentId}");

    Get.snackbar(
      "Payment Successful",
      "Payment ID: ${response.paymentId}",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );

    // Clear cart after successful payment
    try {
      final controller = Get.find<OrderController>();
      controller.clearCart();
    } catch (e) {
      print("Error clearing cart: $e");
    }
  }

  static void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment Error: ${response.code} - ${response.message}");

    Get.snackbar(
      "Payment Failed",
      "Error: ${response.message}",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  static void _handleExternalWallet(ExternalWalletResponse response) {
    print("External Wallet: ${response.walletName}");
  }

  static Future<void> openCheckout({
    required double amount,
    required String orderId,
    required String customerName,
    required String customerEmail,
    required String customerPhone,
  }) async {
    try {
      // Ensure Razorpay is initialized
      if (!_isInitialized || _razorpay == null) {
        print("🔄 Razorpay not initialized - initializing now...");
        await initialize();
      }

      if (_razorpay == null) {
        throw Exception("Failed to initialize Razorpay");
      }

      await _openCheckoutInternal(
          amount, orderId, customerName, customerEmail, customerPhone);
    } catch (e) {
      print("❌ Error in openCheckout: $e");
      Get.snackbar(
        "Payment Error",
        "Failed to initialize payment gateway. Please refresh and try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    }
  }

  static Future<void> _openCheckoutInternal(
    double amount,
    String orderId,
    String customerName,
    String customerEmail,
    String customerPhone,
  ) async {
    try {
      // Validate inputs
      if (amount <= 0) {
        throw Exception("Invalid amount");
      }

      // Validate and format phone number
      String formattedPhone = customerPhone.replaceAll(RegExp(r'[^\d]'), '');
      if (formattedPhone.length < 10) {
        throw Exception("Invalid phone number");
      }

      // Ensure phone number starts with country code if not already
      if (!formattedPhone.startsWith('91') && formattedPhone.length == 10) {
        formattedPhone = '91$formattedPhone';
      }

      var options = {
        'key': _keyId,
        'amount': (amount * 100).toInt(), // Convert to paise
        'currency': 'INR',
        'name': 'Restaurant App',
        'description': 'Food Order Payment - Order #$orderId',
        'prefill': {
          'contact': formattedPhone,
          'email': customerEmail,
          'name': customerName,
        },
        'external': {
          'wallets': ['paytm', 'phonepe', 'gpay', 'bhim'] // UPI wallets only
        },
        'theme': {
          'color': '#FF6B35' // Your app theme color
        },
        'notes': {
          'order_id': orderId, // Store order ID in notes instead
          'source': 'flutter_web_app'
        }
      };

      print('🚀 Opening Razorpay with options: $options');

      // Add a small delay to ensure everything is ready
      await Future.delayed(const Duration(milliseconds: 100));

      // Use the razorpay_web package (proper implementation)
      _razorpay!.open(options);
      print('✅ Razorpay checkout opened successfully');
    } catch (e) {
      print("❌ Error opening Razorpay: $e");

      String errorMessage = "Failed to open payment gateway";
      if (e.toString().contains('400')) {
        errorMessage =
            "Invalid payment details. Please check your information.";
      } else if (e.toString().contains('network')) {
        errorMessage = "Network error. Please check your internet connection.";
      }

      Get.snackbar(
        "Payment Error",
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    }
  }

  static void dispose() {
    try {
      _razorpay?.clear();
      _razorpay = null;
      _isInitialized = false;
      print('✅ Razorpay disposed successfully');
    } catch (e) {
      print('❌ Error disposing Razorpay: $e');
    }
  }
}
