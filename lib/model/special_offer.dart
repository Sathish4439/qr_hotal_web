class SpecialOffer {
  final String discount;
  final String title;
  final String detail;
  final String icon;

  const SpecialOffer({
    required this.discount,
    required this.title,
    required this.detail,
    required this.icon,
  });

  factory SpecialOffer.fromJson(Map<String, dynamic> json) {
    return SpecialOffer(
      discount: json['discount'] ?? '',
      title: json['title'] ?? '',
      detail: json['detail'] ?? '',
      icon: json['icon'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'discount': discount,
      'title': title,
      'detail': detail,
      'icon': icon,
    };
  }
}

