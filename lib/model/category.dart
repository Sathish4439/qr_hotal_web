class Category {
  final String icon;
  final String title;
  final String id;

  const Category({
    required this.icon,
    required this.title,
    required this.id,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      icon: json['icon'] ?? '',
      title: json['title'] ?? '',
      id: json['id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'icon': icon,
      'title': title,
      'id': id,
    };
  }
}


