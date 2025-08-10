// ignore_for_file: public_member_api_docs, sort_constructors_first
class PopularCategory {
  final String category;
  final int id;

  PopularCategory({
    required this.category,
    required this.id,
  });

  factory PopularCategory.fromJson(Map<String, dynamic> json) {
    return PopularCategory(
      category: json['category'] ?? '',
      id: json['id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'id': id,
    };
  }

  static final nullPopularCategory = PopularCategory(category: "NA", id: 0);
}
class Product {
  final String title;
  final String star;       // Stored as String
  final String sold;       // Stored as String
  final String price;      // Stored as String
  final String icon;
  final String qty;        // Quantity also as String
  final int id;
  final String description;

  Product({
    required this.title,
    required this.description,
    required this.star,
    required this.sold,
    required this.price,
    required this.icon,
    required this.id,
    this.qty = "0", // Default value
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      star: json['star']?.toString() ?? '0',
      sold: json['sold']?.toString() ?? '0',
      price: json['price']?.toString() ?? '0',
      icon: json['icon']?.toString() ?? '',
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      qty: json['qty']?.toString() ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'star': star,
      'sold': sold,
      'price': price,
      'icon': icon,
      'id': id,
      'qty': qty,
    };
  }

  static final nullProduct = Product(
    title: 'NA',
    description: 'NA',
    star: 'NA',
    sold: 'NA',
    price: 'NA',
    icon: 'NA',
    id: 0,
    qty: '0',
  );
}
