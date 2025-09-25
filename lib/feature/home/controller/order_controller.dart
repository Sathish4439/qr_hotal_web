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
      (sum, option) => sum + int.parse(option.extraPrice) ?? 0.0,
    );
    totalPrice.value = (basePrice + optionsPrice) * quantity.value;
  }

  void calculateTotalCartPrice() {
    double sum = 0.0;
    print("🛒 Starting calculation of total cart price...");

    print("📦 Cart contains ${cartItems.length} items");

    for (var item in cartItems) {
      print(
          "➡️ Processing item: ${item.menuItem.name}, Quantity: ${item.quantity}");

      // Each item's options price
      double optionsPrice = item.options.fold(
        0.0,
        (total, option) {
          double parsed = double.tryParse(option.extraPrice) ?? 0.0;
          print(
              "   🔹 Option: ${option.name}, Extra Price: ${option.extraPrice}, Parsed: $parsed");
          return total + parsed;
        },
      );

      print("   ✅ Total options price for item: $optionsPrice");
      print("   ✅ Total options price for item: ${item.totalPrice}");

      // Item total = (base price + options price) * quantity
      double itemTotal = (item.totalPrice + optionsPrice) * item.quantity;
      print(
          "   🧮 Item total = (Base: ${item.totalPrice} + Options: $optionsPrice) × Quantity: ${item.quantity} = $itemTotal");

      sum += itemTotal;
      print("   💰 Running sum: $sum");
    }

    totalPrice.value = sum;
    print("✅ Final total cart price: ${totalPrice.value}");

    totalPrice.refresh();
    print("🔄 totalPrice refreshed");
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

      if (res.data['success']) {
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
      var customerId =
          await SecureStorageHelper.readValue(SecureStorageHelper.keyUserId);

      if (customerId == null) return;

      var body = {
        "customerId": int.parse(customerId),
        "menu_id": product.id,
        "price": product.price,
        "quantity": qty,
        "options": selectedOptions.map((o) => o.toJson()).toList(),
        "total_price": totalPrice,
      };

      print(body);

      var res = await api.post(EndPoints.createCart, data: body);

      if (res.data['success']) {
        successToastWidget(res.data['message']);
        fetchCartItem();
      } else {
        errorToastWidget(res.data['message']);
      }
    } catch (e) {
      print("Error adding to cart: $e");
    } finally {
      // calculateTotalCartPrice();
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

      if (res.data['success']) {
        cartItems.removeWhere((item) => item.id == cartItemId);
      }
    } catch (e) {
      print("Error removing from cart: $e");
    }
  }

  // ✅ Update cart item quantity
  Future<void> updateQuantity(int cartItemId, int newQuantity) async {
    var customerId =
        await SecureStorageHelper.readValue(SecureStorageHelper.keyUserId);
    try {
      var body = {
        "cartId": cartItemId,
        "quantity": newQuantity,
        "options": selectedOptions.map((o) => o.toJson()).toList(),
        "total_price": totalPrice.value,
      };
      var res = await api.put(
        "${EndPoints.updateCart}/$customerId",
        data: body,
      );

      if (res.data['success']) {
        var index = cartItems.indexWhere((item) => item.id == cartItemId);
        if (index != -1) {
          cartItems[index] = cartItems[index].copyWith(quantity: newQuantity);
        }
      }
    } catch (e) {
      print("Error updating cart: $e");
    } finally {
      //  calculateTotalCartPrice();
    }
  }

  // ✅ Clear all cart items
  Future<void> clearCart() async {
    try {
      var customerId =
          await SecureStorageHelper.readValue(SecureStorageHelper.keyUserId);

      if (customerId == null) return;

      var res = await api.delete("${EndPoints.clearCart}/$customerId");

      if (res.data['success']) {
        cartItems.clear();
      }
    } catch (e) {
      print("Error clearing cart: $e");
    }
  }
}
