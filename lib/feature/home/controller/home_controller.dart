import 'package:ecommerce_flutter/core/services/api_service.dart';
import 'package:ecommerce_flutter/core/services/endpoints.dart';
import 'package:ecommerce_flutter/core/services/local_storage.dart';
import 'package:ecommerce_flutter/feature/home/model/menu_item.dart';
import 'package:ecommerce_flutter/feature/home/model/special_offer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final api = ApiService();

  var selectIndex = 0.obs;
  var selectOfferIndex = 0.obs;

  var loadMenu = false.obs;
  var menuList = <MenuItem>[].obs;

  var categories = <String>[].obs;
  var selectedCategory = ''.obs;

  var filteredList = <MenuItem>[].obs;

  Future<void> fetchMenu() async {
    debugPrint("fetchMenu called");
    try {
      loadMenu(true);
      menuList.clear();

      var res = await api.get(EndPoints.getMenu);
      print("Menu API Response: ${res.data}");

      if (res.data is Map<String, dynamic> && res.data['success'] == true) {
        var data = res.data['data'];
        if (data is List) {
          var li = data
              .map((e) {
                try {
                  return MenuItem.fromJson(e);
                } catch (parseError) {
                  print("Error parsing menu item: $parseError");
                  print("Problematic data: $e");
                  return null;
                }
              })
              .where((item) => item != null)
              .cast<MenuItem>()
              .toList();

          if (li.isNotEmpty) {
            menuList.value = li;

            // ✅ Get unique categories (ignores nulls)
            categories.value = menuList
                .map((p0) => p0.category)
                .whereType<String>() // removes nulls
                .toSet()
                .toList();

            print("menuList length ${menuList.length}");
          } else {
            print("No valid menu items found");
          }
        } else {
          print("Menu data is not a list: ${data.runtimeType}");
        }
      } else {
        print("Menu API failed: ${res.data}");
      }
    } catch (e) {
      debugPrint("Error fetching menu: $e");
    } finally {
      loadMenu(false);
      sendTokenToBackend();
    }
  }

  Future<void> sendTokenToBackend() async {
    try {
      var token =
          await SecureStorageHelper.readValue(SecureStorageHelper.fcmToken);

      var data = {"fcmToken": token};

      var res = await api.post(EndPoints.createCustomer, data: data);

      if (res.statusCode == 200 && res.data['success'] == true) {
        var customerId = res.data['data']['id'].toString();

        if (customerId.isNotEmpty) {
          await SecureStorageHelper.saveValue(
              SecureStorageHelper.keyUserId, customerId);
        }
      } else {}
    } catch (e) {
      print(e);
    }
  }

  final homeSpecialOffers = <SpecialOffer>[
    const SpecialOffer(
      discount: '25%',
      title: "Today’s Special!",
      detail: 'Get a discount on every order — valid only for today.',
      icon: 'assets/icons/products/sofa.png',
    ),
    const SpecialOffer(
      discount: '35%',
      title: "Tomorrow Will Be Better!",
      detail: 'Please support us with a star!',
      icon: 'assets/icons/products/shiny_chair.png',
    ),
    const SpecialOffer(
      discount: '100%',
      title: "Free for You Today!",
      detail: 'If you have any problem, contact us.',
      icon: 'assets/icons/products/lamp.png',
    ),
    const SpecialOffer(
      discount: '75%',
      title: "It’s for You!",
      detail: 'Wishing you a fun and joyful time.',
      icon: 'assets/icons/products/plastic_chair@2x.png',
    ),
    const SpecialOffer(
      discount: '65%',
      title: "Make Yourself at Home!",
      detail: 'If you have any confusion, let us know.',
      icon: 'assets/icons/products/book_case@2x.png',
    ),
  ];
}
