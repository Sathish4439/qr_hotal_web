class OrderModel {
  final int id;
  final int tableId;
  final int? customerId;
  final String tableName;
  final double total;
  final String paymentMethod;
  final String status;
  final DateTime createdAt;
  final List<OrderItemModel> items;

  OrderModel({
    required this.id,
    required this.tableId,
    this.customerId,
    required this.tableName,
    required this.total,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? 0,
      tableId: json['tableId'] ?? 0,
      customerId: json['customerId'],
      tableName: json['table']?['name'] ?? 'Unknown Table',
      total: double.tryParse(json['total']?.toString() ?? '0') ?? 0.0,
      paymentMethod: json['paymentMethod'] ?? 'CASH',
      status: json['status'] ?? 'PENDING',
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => OrderItemModel.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tableId': tableId,
      'customerId': customerId,
      'tableName': tableName,
      'total': total,
      'paymentMethod': paymentMethod,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class OrderItemModel {
  final int id;
  final int menuItemId;
  final String menuItemName;
  final int quantity;
  final double price;
  final String notes;

  OrderItemModel({
    required this.id,
    required this.menuItemId,
    required this.menuItemName,
    required this.quantity,
    required this.price,
    required this.notes,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] ?? 0,
      menuItemId: json['menuItemId'] ?? 0,
      menuItemName: json['menuItem']?['name'] ?? 'Unknown Item',
      quantity: json['quantity'] ?? 1,
      price:
          double.tryParse(json['menuItem']?['price']?.toString() ?? '0') ?? 0.0,
      notes: json['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'menuItemId': menuItemId,
      'menuItemName': menuItemName,
      'quantity': quantity,
      'price': price,
      'notes': notes,
    };
  }
}
