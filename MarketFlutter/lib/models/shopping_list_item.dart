class ShoppingListItem {
  String title;
  String category;
  String type;
  ShoppingListItem({required this.title, required this.category, required this.type});

  factory ShoppingListItem.fromJson(Map<String, dynamic> json) {
    ShoppingListItem res = ShoppingListItem(
      title: json['title'] as String,
      category: json['category'] as String,
      type: json['type'] as String,
    );
    return res;
  }

  // Method to convert User instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'type': type,
      'category': category,
    };
  }
}