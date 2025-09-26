import 'package:ecommerce_flutter/core/common_wid/widget.dart';
import 'package:ecommerce_flutter/core/services/api_service.dart';
import 'package:ecommerce_flutter/core/services/endpoints.dart';
import 'package:ecommerce_flutter/core/services/local_storage.dart';
import 'package:ecommerce_flutter/feature/home/model/cartModel.dart';
import 'package:get/get.dart';
import 'package:ecommerce_flutter/feature/home/model/menu_item.dart';

class OrderController extends GetxController {
  final api = ApiService();

  var quantity = 1.obs;
  var totalPrice = 0.0.obs;

  // Store selected options
  var selectedOptions = <MenuOption>[].obs;

  var isLoading = false.obs;
  var cartItems = <CartItem>[].obs;

  // ✅ Calculate total price with options
  void calculatePrice(double basePrice) {
    double optionsPrice = selectedOptions.fold(
      0.0,
      (sum, option) => sum + (double.tryParse(option.extraPrice) ?? 0.0),
    );
    totalPrice.value = (basePrice + optionsPrice) * quantity.value;
  }

  void calculateTotalCartPrice() {
    double sum = 0.0;

    for (var item in cartItems) {
      // Calculate options price for this item
      double optionsPrice = item.options.fold(
        0.0,
        (total, option) => total + (double.tryParse(option.extraPrice) ?? 0.0),
      );

      // Item total = (base price + options price) * quantity
      double itemTotal =
          ((double.tryParse(item.menuItem.price) ?? 0.0) + optionsPrice) *
              item.quantity;
      sum += itemTotal;
    }

    totalPrice.value = sum;
    totalPrice.refresh();
    cartItems.refresh(); // Force refresh cart items observable
  }

  // ✅ Add/Remove options
  void toggleOption(MenuOption option, double basePrice) {
    if (selectedOptions.contains(option)) {
      selectedOptions.remove(option);
    } else {
      selectedOptions.add(option);
    }
    calculatePrice(basePrice);
  }

  // ✅ Fetch cart items from API
  Future<void> fetchCartItem() async {
    try {
      isLoading(true);

      var customerId =
          await SecureStorageHelper.readValue(SecureStorageHelper.keyUserId);

      if (customerId == null) return;

      var res = await api.get("${EndPoints.getCart}/$customerId");

      if (res.data['success'] == true) {
        var data = res.data['data'] as List;
        cartItems.value = data.map((e) => CartItem.fromJson(e)).toList();
      }
    } catch (e) {
      print("Error fetching cart: $e");
    } finally {
      isLoading(false);
      calculateTotalCartPrice();
    }
  }

  // ✅ Add to cart API
  Future<void> addToCart(MenuItem product, int qty,
      List<MenuOption> selectedOptions, double totalPrice) async {
    print("addToCart method called ");
    try {
      isLoading.value = true;

      var customerId =
          await SecureStorageHelper.readValue(SecureStorageHelper.keyUserId);

      if (customerId == null) {
        errorToastWidget("Please login to add items to cart");
        return;
      }

      var body = {
        "customerId": int.parse(customerId),
        "menu_id": product.id,
        "price": product.price,
        "quantity": qty,
        "options": selectedOptions.map((o) => o.toJson()).toList(),
        "total_price": totalPrice,
      };

      print("Adding to cart: $body");

      var res = await api.post(EndPoints.createCart, data: body);

      if (res.data['success'] == true) {
        // Show appropriate message based on whether item was added or updated
        String message =
            res.data['message'] ?? 'Item added to cart successfully';
        successToastWidget(message);
        await fetchCartItem(); // Refresh cart items
      } else {
        errorToastWidget(res.data['message'] ?? 'Failed to add item to cart');
      }
    } catch (e) {
      print("Error adding to cart: $e");
      errorToastWidget("Failed to add item to cart. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ Reset values after adding
  void reset() {
    quantity.value = 1;
    totalPrice.value = 0.0;
    selectedOptions.clear();
  }

  // ✅ Remove from cart
  Future<void> removeFromCart(int cartItemId) async {
    try {
      var res = await api.delete("${EndPoints.deleteCart}/$cartItemId");

      if (res.data['success'] == true) {
        cartItems.removeWhere((item) => item.id == cartItemId);
        calculateTotalCartPrice(); // Recalculate total after removal
      }
    } catch (e) {
      print("Error removing from cart: $e");
    }
  }

  // ✅ Update cart item quantity
  Future<void> updateQuantity(int cartItemId, int newQuantity) async {
    try {
      var customerId =
          await SecureStorageHelper.readValue(SecureStorageHelper.keyUserId);

      if (customerId == null) return;

      // Find the cart item to get its options
      var cartItem = cartItems.firstWhere((item) => item.id == cartItemId);

      // Calculate options price for this item
      double optionsPrice = cartItem.options.fold(
        0.0,
        (total, option) => total + (double.tryParse(option.extraPrice) ?? 0.0),
      );

      // Calculate new total price for this item
      double newTotalPrice =
          ((double.tryParse(cartItem.menuItem.price) ?? 0.0) + optionsPrice) *
              newQuantity;

      var body = {
        "cartId": cartItemId,
        "quantity": newQuantity,
        "options": cartItem.options.map((o) => o.toJson()).toList(),
        "total_price": newTotalPrice,
      };

      var res = await api.put(
        "${EndPoints.updateCart}/$customerId",
        data: body,
      );

      if (res.data['success'] == true) {
        var index = cartItems.indexWhere((item) => item.id == cartItemId);
        if (index != -1) {
          cartItems[index] = cartItems[index].copyWith(
            quantity: newQuantity,
            totalPrice: newTotalPrice,
          );
          calculateTotalCartPrice(); // Recalculate total cart price
        }
      }
    } catch (e) {
      print("Error updating cart: $e");
    }
  }

  // ✅ Clear all cart items
  Future<void> clearCart() async {
    try {
      var customerId =
          await SecureStorageHelper.readValue(SecureStorageHelper.keyUserId);

      if (customerId == null) return;

      var data = {
        "customerId": customerId,
      };

      var res = await api.post("${EndPoints.clearCart}", data: data);

      if (res.data['success'] == true) {
        cartItems.clear();
        totalPrice.value = 0.0; // Reset total price
      }
    } catch (e) {
      print("Error clearing cart: $e");
    }
  }

  // ✅ Create order (for Cash on Delivery)
  Future<void> createOrder({
    required int tableId,
    required String paymentMethod,
  }) async {
    try {
      isLoading.value = true;

      if (cartItems.isEmpty) {
        errorToastWidget("Cart is empty. Please add items to cart.");
        return;
      }

      // Prepare order items from cart
      List<Map<String, dynamic>> orderItems = cartItems.map((cartItem) {
        return {
          "menuItemId": cartItem.menuItem.id,
          "quantity": cartItem.quantity,
          "notes": "",
        };
      }).toList();

      var body = {
        "tableId": tableId,
        "items": orderItems,
        "paymentMethod": paymentMethod,
      };

      print("Creating order: $body");

      var res = await api.post(EndPoints.createOrder, data: body);

      if (res.data['success'] == true) {
        String message = res.data['message'] ?? 'Order created successfully';
        successToastWidget(message);

        // Clear cart after successful order creation
        await clearCart();

        // Navigate to order confirmation or home
        Get.offAllNamed('/home');
      } else {
        errorToastWidget(res.data['message'] ?? 'Failed to create order');
      }
    } catch (e) {
      print("Error creating order: $e");
      errorToastWidget("Failed to create order. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }
}
