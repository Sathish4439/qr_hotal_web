import 'package:flutter/material.dart';

class MenuItem {
  final int id;
  final String name;
  final String description;
  final String price;
  final String category;
  final String imageUrl;
  final DateTime createdAt;
  final List<MenuOption> options;
  final List<OrderItem> orderItems;
  final String? notes;
  bool? loading = false;
  // nullable is fine

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.createdAt,
    this.options = const [],
    this.orderItems = const [],
    this.notes,
    this.loading,
  });

  /// ✅ Factory constructor to create object from JSON
  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] ?? 0,
      name: json['name'] ?? "NA",
      description: json['description'] ?? "NA",
      price: (json['price'])?.toString() ?? "NA",
      category: json['category'] ?? "NA",
      imageUrl: json['imageUrl'] ?? "assets/images/default.png",
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      options: (json['options'] as List<dynamic>?)
              ?.map((e) => MenuOption.fromJson(e))
              .toList() ??
          [],
      orderItems: (json['orderItems'] as List<dynamic>?)
              ?.map((e) => OrderItem.fromJson(e))
              .toList() ??
          [],
      notes: json['notes'], // nullable allowed
    );
  }

  /// ✅ Convert object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'options': options.map((e) => e.toJson()).toList(),
      'orderItems': orderItems.map((e) => e.toJson()).toList(),
      'notes': notes,
    };
  }

  /// ✅ Null safe fallback
  static final nullMenuItem = MenuItem(
    id: 0,
    name: 'NA',
    description: "NA",
    price: "NA",
    category: "NA",
    imageUrl: "assets/images/default.png",
    createdAt: DateTime.now(),
  );
}

class MenuOption {
  final int id;
  final String name;
  final String extraPrice;

  MenuOption({
    required this.id,
    required this.name,
    required this.extraPrice,
  });

  factory MenuOption.fromJson(Map<String, dynamic> json) {
    return MenuOption(
      id: json['id'] ?? 0,
      name: json['name'] ?? "NA",
      extraPrice: json['extraPrice']?.toString() ?? "0",
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'extraPrice': extraPrice,
      };

  static final nullMenuOption = MenuOption(
    id: 0,
    name: 'NA',
    extraPrice: "0",
  );
}

class OrderItem {
  final int id;
  final int quantity;

  OrderItem({
    required this.id,
    required this.quantity,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] ?? 0,
      quantity: json['quantity'] is int
          ? json['quantity']
          : int.tryParse(json['quantity']?.toString() ?? "0") ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'quantity': quantity,
      };

  static final nullOrderItem = OrderItem(
    id: 0,
    quantity: 0,
  );
}
