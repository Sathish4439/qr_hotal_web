import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:ecommerce_flutter/feature/home/controller/order_controller.dart';

class WebPaymentService {
  static void openWebPayment({
    required double amount,
    required String orderId,
    required String customerName,
    required String customerEmail,
    required String customerPhone,
  }) {
    if (kIsWeb) {
      _showWebPaymentDialog(
        amount: amount,
        orderId: orderId,
        customerName: customerName,
        customerEmail: customerEmail,
        customerPhone: customerPhone,
      );
    }
  }

  static void _showWebPaymentDialog({
    required double amount,
    required String orderId,
    required String customerName,
    required String customerEmail,
    required String customerPhone,
  }) {
    Get.dialog(
      AlertDialog(
        title: const Text('Payment Options'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Choose your preferred payment method:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // UPI Payment Option
            ListTile(
              leading: const Icon(Icons.account_balance_wallet,
                  color: Colors.purple),
              title: const Text('UPI Payment'),
              subtitle: const Text('Pay using UPI apps'),
              onTap: () {
                Get.back();
                _showUpiOptions(amount, orderId, customerName, customerEmail,
                    customerPhone);
              },
            ),

            // Card Payment Option
            ListTile(
              leading: const Icon(Icons.credit_card, color: Colors.blue),
              title: const Text('Card Payment'),
              subtitle: const Text('Credit/Debit Card'),
              onTap: () {
                Get.back();
                _showCardPayment(amount, orderId, customerName, customerEmail,
                    customerPhone);
              },
            ),

            // Cash on Delivery
            ListTile(
              leading: const Icon(Icons.local_atm, color: Colors.green),
              title: const Text('Cash on Delivery'),
              subtitle: const Text('Pay when you receive'),
              onTap: () {
                Get.back();
                _processCodPayment(amount, orderId);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  static void _showUpiOptions(double amount, String orderId,
      String customerName, String customerEmail, String customerPhone) {
    Get.dialog(
      AlertDialog(
        title: const Text('UPI Payment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Scan QR code or use UPI ID:'),
            const SizedBox(height: 20),

            // QR Code placeholder
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.qr_code, size: 80, color: Colors.grey),
                    SizedBox(height: 10),
                    Text('QR Code', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Payment details
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Amount: ₹${amount.toStringAsFixed(2)}'),
                  Text('Order ID: $orderId'),
                  Text('Customer: $customerName'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'UPI ID: restaurant@paytm',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _simulatePaymentSuccess(amount, orderId);
            },
            child: const Text('Mark as Paid'),
          ),
        ],
      ),
    );
  }

  static void _showCardPayment(double amount, String orderId,
      String customerName, String customerEmail, String customerPhone) {
    Get.dialog(
      AlertDialog(
        title: const Text('Card Payment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Card payment integration would go here'),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Amount: ₹${amount.toStringAsFixed(2)}'),
                  Text('Order ID: $orderId'),
                  Text('Customer: $customerName'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _simulatePaymentSuccess(amount, orderId);
            },
            child: const Text('Process Payment'),
          ),
        ],
      ),
    );
  }

  static void _processCodPayment(double amount, String orderId) {
    Get.snackbar(
      "Order Placed",
      "Your order has been placed successfully. Pay ₹${amount.toStringAsFixed(2)} on delivery.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );

    // Clear cart after successful order
    final controller = Get.find<OrderController>();
    controller.clearCart();
  }

  static void _simulatePaymentSuccess(double amount, String orderId) {
    Get.snackbar(
      "Payment Successful",
      "Payment of ₹${amount.toStringAsFixed(2)} completed successfully!",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );

    // Clear cart after successful payment
    final controller = Get.find<OrderController>();
    controller.clearCart();
  }
}
