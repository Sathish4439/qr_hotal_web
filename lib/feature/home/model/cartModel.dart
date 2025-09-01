import 'package:ecommerce_flutter/feature/home/model/menu_item.dart';

class CartItem {
  final int id;
  final int customerId;
  final int menuItemId;
  final int quantity;
  final List<MenuOption> options;
  final double totalPrice;
  final DateTime createdAt;
  final DateTime updatedAt;
  final MenuItem menuItem;

  CartItem({
    required this.id,
    required this.customerId,
    required this.menuItemId,
    required this.quantity,
    required this.options,
    required this.totalPrice,
    required this.createdAt,
    required this.updatedAt,
    required this.menuItem,
  });

  /// Factory for parsing from JSON
factory CartItem.fromJson(Map<String, dynamic> json) {
  List<MenuOption> menuOption = [];

  try {
    if (json['options'] != null && json['options'] is List) {
      menuOption = (json['options'] as List)
          .map((opt) => MenuOption.fromJson(opt))
          .toList();
    }
  } catch (e) {
    print("Error parsing menu options: $e");
  }

  // Debug print all keys with type
 

  return CartItem(
    id: json['id'] ?? 0,
    customerId: json['customerId'] ?? 0,
    menuItemId: json['menuItemId'] ?? 0,
    quantity: json['quantity'] ?? 0,
    options: menuOption,
    totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
    createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    menuItem: json['menuItem'] != null
        ? MenuItem.fromJson(json['menuItem'])
        : MenuItem.nullMenuItem,
  );
}

  /// Convert object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'menuItemId': menuItemId,
      'quantity': quantity,
      'options': options.map((e) => e.toJson()).toList(),
      'totalPrice': totalPrice,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'menuItem': menuItem.toJson(),
    };
  }

  /// Default empty instance
  static final nullcartItem = CartItem(
    id: 0,
    customerId: 0,
    menuItemId: 0,
    quantity: 0,
    options: [],
    totalPrice: 0.0,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    menuItem: MenuItem.nullMenuItem,
  );

  /// CopyWith method
  CartItem copyWith({
    int? id,
    int? customerId,
    int? menuItemId,
    int? quantity,
    List<MenuOption>? options,
    double? totalPrice,
    DateTime? createdAt,
    DateTime? updatedAt,
    MenuItem? menuItem,
  }) {
    return CartItem(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      menuItemId: menuItemId ?? this.menuItemId,
      quantity: quantity ?? this.quantity,
      options: options ?? this.options,
      totalPrice: totalPrice ?? this.totalPrice,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      menuItem: menuItem ?? this.menuItem,
    );
  }
}
