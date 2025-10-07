import 'package:ecommerce_flutter/core/common_wid/widget.dart';
import 'package:ecommerce_flutter/core/services/razorpay_service.dart';
import 'package:ecommerce_flutter/core/theme/app_color.dart';
import 'package:ecommerce_flutter/feature/home/controller/order_controller.dart';
import 'package:ecommerce_flutter/feature/home/model/cartModel.dart';
import 'package:ecommerce_flutter/feature/home/view/tabbar.dart';
import 'package:ecommerce_flutter/feature/home/view/widgets/app_bar.dart';
import 'package:ecommerce_flutter/feature/home/view/widgets/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final controller = Get.put(OrderController());

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Add Your Code here.
      controller.reset();
      controller.fetchCartItem();
      // Ensure total is calculated after fetching cart items
      Future.delayed(const Duration(milliseconds: 500), () {
        controller.calculateTotalCartPrice();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FRAppBar.defaultAppBar(
        title: "My Cart",
        showBackButton: false,
        context,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              _showClearCartDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (controller.cartItems.isEmpty) {
                return _buildEmptyCart();
              }

              return _buildCartItems();
            }),
          ),
          _buildCheckoutSection(),
        ],
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/logo.png',
            height: 200,
            width: 200,
          ),
          const SizedBox(height: 20),
          const Text(
            "Your cart is empty",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            "Looks like you haven't added anything to your cart yet",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          CustomeButton(
              width: getWidth(0.30),
              text: "Start Shoping",
              onTap: () => Get.to(() => FRTabbarScreen()))
        ],
      ),
    );
  }

  Widget _buildCartItems() {
    return ListView.builder(
      itemCount: controller.cartItems.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        var cartItem = controller.cartItems[index];
        return Dismissible(
          key: Key(cartItem.id.toString()),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white, size: 30),
          ),
          confirmDismiss: (direction) async {
            return await _showDeleteDialog(cartItem);
          },
          onDismissed: (direction) {
            controller.removeFromCart(cartItem.id);
          },
          child: CartItemWid(
            cartItem: cartItem,
            onQuantityChanged: (newQuantity) {
              controller.updateQuantity(cartItem.id, newQuantity);
              controller.fetchCartItem();

              controller.calculateTotalCartPrice();
            },
          ),
        );
      },
    );
  }

  Widget _buildCheckoutSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Order Summary
          _buildOrderSummary(),
          const SizedBox(height: 16),
          // Checkout Button
          _buildCheckoutButton(),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Obx(() {
      // Calculate total manually to ensure it's always up to date
      double calculatedTotal = 0.0;
      print("🛒 Calculating total for ${controller.cartItems.length} items");

      for (var item in controller.cartItems) {
        // Calculate options price for this item
        double optionsPrice = item.options.fold(
          0.0,
          (total, option) =>
              total + (double.tryParse(option.extraPrice) ?? 0.0),
        );

        // Item total = (base price + options price) * quantity
        double itemTotal =
            ((double.tryParse(item.menuItem.price) ?? 0.0) + optionsPrice) *
                item.quantity;
        calculatedTotal += itemTotal;

        print(
            "📦 Item: ${item.menuItem.name}, Price: ${item.menuItem.price}, Options: $optionsPrice, Qty: ${item.quantity}, Total: $itemTotal");
      }

      print("💰 Final calculated total: $calculatedTotal");

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Total Amount",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text("₹${calculatedTotal.toStringAsFixed(2)}",
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue)),
        ],
      );
    });
  }

  Widget _buildCheckoutButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF45A049)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          _showPaymentOptions();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shopping_cart_checkout,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              "Proceed to Checkout",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _showDeleteDialog(CartItem cartItem) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Remove Item"),
          content: Text(
              "Are you sure you want to remove ${cartItem.menuItem.name} from your cart?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Remove", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showClearCartDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Clear Cart"),
          content: const Text(
              "Are you sure you want to remove all items from your cart?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                controller.clearCart();
                Navigator.of(context).pop();
              },
              child:
                  const Text("Clear All", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showPaymentOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                "Choose Payment Method",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),

              // UPI Payment Option
              _buildPaymentOption(
                icon: Icons.account_balance_wallet,
                iconColor: Colors.purple,
                title: "UPI Payment",
                subtitle: "Pay using UPI apps",
                onTap: () {
                  Navigator.pop(context);
                  _initiateUpiPayment();
                },
              ),

              const SizedBox(height: 12),

              // Credit/Debit Card
              _buildPaymentOption(
                icon: Icons.credit_card,
                iconColor: Colors.blue,
                title: "Credit/Debit Card",
                subtitle: "Pay using card",
                onTap: () {
                  Navigator.pop(context);
                  _initiateCardPayment();
                },
              ),

              const SizedBox(height: 12),

              // Cash on Delivery
              _buildPaymentOption(
                icon: Icons.local_atm,
                iconColor: Colors.green,
                title: "Cash on Delivery",
                subtitle: "Pay when you receive",
                onTap: () {
                  Navigator.pop(context);
                  _initiateCodPayment();
                },
              ),

              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
            ],
          ),
        );
      },
    );
  }

  void _initiateUpiPayment() async {
    final controller = Get.find<OrderController>();

    if (controller.cartItems.isEmpty) {
      Get.snackbar(
        "Empty Cart",
        "Please add items to cart before proceeding",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    // Generate order ID (you can use your backend API for this)
    final orderId = "order_${DateTime.now().millisecondsSinceEpoch}";

    // Get customer details (you might want to get these from user profile)
    final customerName =
        "Restaurant Customer"; // Replace with actual customer name
    final customerEmail =
        "customer@restaurant.com"; // Replace with actual email
    final customerPhone = "9876543210"; // Replace with actual phone (10 digits)

    // Show loading indicator
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );

    try {
      // Use Razorpay service for web payment
      await RazorpayService.openCheckout(
        amount: controller.totalPrice.value,
        orderId: orderId,
        customerName: customerName,
        customerEmail: customerEmail,
        customerPhone: customerPhone,
      );
    } catch (e) {
      print("Error initiating payment: $e");
      Get.snackbar(
        "Payment Error",
        "Failed to initiate payment. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      // Close loading dialog
      if (Get.isDialogOpen == true) {
        Get.back();
      }
    }
  }

  void _initiateCodPayment() async {
    final controller = Get.find<OrderController>();

    if (controller.cartItems.isEmpty) {
      Get.snackbar(
        "Empty Cart",
        "Please add items to cart before proceeding",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    // Get table ID from global variable (extracted from URL)
    final currentTableId = "1";
    if (currentTableId.isEmpty) {
      Get.snackbar(
        "Table Not Found",
        "Unable to identify table. Please scan QR code again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Show confirmation dialog
    Get.dialog(
      AlertDialog(
        title: const Text("Confirm Order"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Table: $currentTableId"),
            const SizedBox(height: 8),
            Text(
                "Total Amount: ₹${controller.totalPrice.value.toStringAsFixed(2)}"),
            const SizedBox(height: 8),
            Text("Items: ${controller.cartItems.length}"),
            const SizedBox(height: 16),
            Text(
              "You will pay ₹${controller.totalPrice.value.toStringAsFixed(2)} when your order is delivered.",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back(); // Close dialog

              // Show loading indicator
              Get.dialog(
                const Center(
                  child: CircularProgressIndicator(),
                ),
                barrierDismissible: false,
              );

              try {
                // Create order with Cash on Delivery
                await controller.createOrder(
                  tableId: int.parse(currentTableId),
                  paymentMethod: "CASH",
                );
              } catch (e) {
                print("Error in COD payment: $e");
                Get.back(); // Close loading dialog
                Get.snackbar(
                  "Order Failed",
                  "Failed to create order. Please try again.",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text(
              "Place Order",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColors.textSecondary,
        ),
        onTap: onTap,
      ),
    );
  }

  void _initiateCardPayment() async {
    final controller = Get.find<OrderController>();

    if (controller.cartItems.isEmpty) {
      Get.snackbar(
        "Empty Cart",
        "Please add items to cart before proceeding",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    // Generate order ID
    final orderId = "order_${DateTime.now().millisecondsSinceEpoch}";

    // Get customer details
    final customerName = "Restaurant Customer";
    final customerEmail = "customer@restaurant.com";
    final customerPhone = "9876543210";

    // Show loading indicator
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );

    try {
      // Use Razorpay service for card payment
      await RazorpayService.openCheckout(
        amount: controller.totalPrice.value,
        orderId: orderId,
        customerName: customerName,
        customerEmail: customerEmail,
        customerPhone: customerPhone,
      );
    } catch (e) {
      print("Error initiating card payment: $e");
      Get.snackbar(
        "Payment Error",
        "Failed to initiate payment. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      // Close loading dialog
      if (Get.isDialogOpen == true) {
        Get.back();
      }
    }
  }
}
