import 'package:ecommerce_flutter/core/common_wid/widget.dart';
import 'package:ecommerce_flutter/core/theme/app_color.dart';
import 'package:ecommerce_flutter/feature/home/controller/order_controller.dart';
import 'package:ecommerce_flutter/feature/home/model/cartModel.dart';
import 'package:ecommerce_flutter/feature/home/model/menu_item.dart';
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
      final total =
          controller.cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
      final discount = total * 1; // 10% discount example
      final grandTotal = total;

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Total Amount",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text("₹${controller.totalPrice.toStringAsFixed(2)}",
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue)),
        ],
      );
    });
  }

  Widget _buildCheckoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          _showPaymentOptions();
        },
        child: const Text(
          "Proceed to Checkout",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
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
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Choose Payment Method",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // UPI Payment Option
              ListTile(
                leading: const Icon(Icons.account_balance_wallet,
                    color: Colors.purple),
                title: const Text("UPI Payment"),
                subtitle: const Text("Pay using UPI apps"),
                onTap: () {
                  Navigator.pop(context);
                  //   _initiateUpiPayment();
                },
              ),

              // Credit/Debit Card
              ListTile(
                leading: const Icon(Icons.credit_card, color: Colors.blue),
                title: const Text("Credit/Debit Card"),
                subtitle: const Text("Pay using card"),
                onTap: () {
                  // Implement card payment
                },
              ),

              // Cash on Delivery
              ListTile(
                leading: const Icon(Icons.local_atm, color: Colors.green),
                title: const Text("Cash on Delivery"),
                subtitle: const Text("Pay when you receive"),
                onTap: () {
                  // Implement COD
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
}
