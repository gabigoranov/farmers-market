class ShoppingListItem {
  String title;
  String category;
  String type;
  double quantity;

  ShoppingListItem({required this.title, required this.category, required this.type, required this.quantity});

  factory ShoppingListItem.fromJson(Map<String, dynamic> json) {
    ShoppingListItem res = ShoppingListItem(
      title: json['title'] as String,
      category: json['category'] as String,
      type: json['type'] as String,
      quantity: json['quantity']+.0,
    );
    return res;
  }

  // Method to convert User instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'type': type,
      'category': category,
      'quantity': quantity,
    };
  }
}