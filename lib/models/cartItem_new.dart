class CartItem {
  String id;
  String title;
  String description;
  String price;
  int quantity;

  CartItem({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.quantity,
  });

  // Factory constructor to convert a map to a CartItem instance
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'] as String? ?? '',  // Default empty string if null
      title: map['title'] as String? ?? '',  // Default empty string if null
      description: map['description'] as String? ?? '',  // Default empty string if null
      price: map['price'] as String? ?? '',  // Default empty string if null
      quantity: map['quantity'] != null ? map['quantity'] as int : 0,  // Default to 0 if null
    );
  }

  // Optional: You can also add a toMap method if you want to convert CartItem back to a map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'quantity': quantity,
    };
  }
}
