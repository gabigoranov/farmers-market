


class OfferType {
  int id;
  String name;
  String category;
  OfferType({required this.id, required this.name, required this.category});

  factory OfferType.fromJson(Map<String, dynamic> json) {
    OfferType res = OfferType(
      id: json['id'] as int,
      name: json['name'] as String,
      category: json['category'] as String,
    );
    return res;
  }

  // Method to convert User instance to a JSON map
  Map<String, dynamic> toJson() {
    //TODO: Add all types when fix api
    return {
      'id': id,
      'name': name,
      'category': category,
    };
  }
}