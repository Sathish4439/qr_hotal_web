import 'package:ecommerce_flutter/model/popular.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {

    var quantity = 0.obs;
  var iscollected = false.obs;
  var totalPrice =0.0.obs;


 String getTotalPrice(List<Product> productList) {
  double total = 0.0;

  for (var product in productList) {
    double price = double.tryParse(product.price) ?? 0.0;
    int quantity = int.tryParse(product.qty) ?? 1;
    total += price * quantity;
  }

  return total.toStringAsFixed(2); // Return with 2 decimal places
}

 void calculatePrice(double unitPrice) {
    totalPrice.value = unitPrice * quantity.value;
  }
}