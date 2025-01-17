class CartItems {
  static final CartItems instance = CartItems.privateConstructor();
  static List<Map<String, dynamic>> cartItemsList = [];

  CartItems.privateConstructor();

  factory CartItems() {
    return instance;
  }

  List<Map<String, dynamic>> get cartItems => cartItemsList;

  void addItem(Map<String, dynamic> item) {
    cartItemsList.add(item);
  }

  void removeItem(int index) {
    if (index >= 0 && index < cartItemsList.length) {
      cartItemsList.removeAt(index);
    }
  }

  void increaseQuantity(int index) {
    if (index >= 0 && index < cartItemsList.length) {
      cartItemsList[index]['quantity']++;
    }
  }

  void decreaseQuantity(int index) {
    if (index >= 0 && index < cartItemsList.length && cartItemsList[index]['quantity'] > 0) {
      cartItemsList[index]['quantity']--;
      if (cartItemsList[index]['quantity'] == 0) {
        removeItem(index);
      }
    }
  }
}
