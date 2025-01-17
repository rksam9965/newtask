import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? currentUserId2 = FirebaseAuth.instance.currentUser?.uid;

  String get currentUserId {
    return _auth.currentUser?.uid ??
        ''; // Get the UID of the current authenticated user
  }

  // Add or update item in the cart
  Future<void> addOrUpdateCart(String title, String description, String id,
      String price, String category, int cartQuantity) async {
    try {
      CollectionReference userEntries = _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('add_cart');

      // Check if the product already exists in the cart
      QuerySnapshot existingCartItem =
          await userEntries.where('id', isEqualTo: id).get();

      if (existingCartItem.docs.isNotEmpty) {
        // If item exists, update the quantity
        String cartItemId = existingCartItem.docs.first.id;
        int existingQuantity = existingCartItem.docs.first['addCartQty'] ?? 0;
        await updateCartQuantity(cartItemId, existingQuantity + 1);
      } else {
        // If item doesn't exist, add a new cart entry
        await userEntries.add({
          'title': title,
          'description': description,
          'id': id,
          'addCartQty': cartQuantity,
          'price': price,
          'category': category,
          'created_at': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error adding or updating cart item: $e');
    }
  }

  Future<void> placedOrder(String title, String description, String id,
      String price, String category, int cartQuantity) async {
    try {
      CollectionReference userEntries = _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('add_cart');

      // Check if the product already exists in the cart
      QuerySnapshot existingCartItem =
          await userEntries.where('id', isEqualTo: id).get();

      if (existingCartItem.docs.isNotEmpty) {
        // If item exists, update the quantity
        String cartItemId = existingCartItem.docs.first.id;
        int existingQuantity = existingCartItem.docs.first['addCartQty'] ?? 0;
        await updateCartQuantity(cartItemId, existingQuantity + cartQuantity);
      } else {
        await userEntries.add({
          'title': title,
          'description': description,
          'id': id,
          'addCartQty': cartQuantity,
          'price': price,
          'category': category,
          'created_at': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error adding or updating cart item: $e');
    }
  }

  // Update cart item quantity
  Future<void> updateCartQuantity(String cartItemId, int quantity) async {
    try {
      CollectionReference userEntries = _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('add_cart');

      // Update quantity for the specific cart item
      await userEntries.doc(cartItemId).update({
        'addCartQty': quantity,
      });
    } catch (e) {
      print('Error updating cart quantity: $e');
    }
  }

  // Place the order (after checking out)
  Future<void> placeOrder() async {
    try {
      CollectionReference orders = _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('orders');

      // Get the current cart items
      List<Map<String, dynamic>> cartItems = await fetchCartItems();

      if (cartItems.isEmpty) {
        print('Cart is empty, cannot place an order');
        return;
      }

      // Create a new order document with cart items
      await orders.add({
        'items': cartItems,
        'order_date': FieldValue.serverTimestamp(),
        'status': 'Placed',
      });

      // Optionally, clear the cart after placing the order
      await clearCart();
    } catch (e) {
      print('Error placing the order: $e');
    }
  }

  // Clear the cart after placing the order
  Future<void> clearCart() async {
    try {
      CollectionReference userEntries = _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('add_cart');

      // Delete all items in the cart
      QuerySnapshot cartSnapshot = await userEntries.get();
      for (var doc in cartSnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print('Error clearing cart: $e');
    }
  }

  // Fetch placed orders
  Future<List<Map<String, dynamic>>> fetchPlacedOrders() async {
    try {
      // Get the orders collection for the current user
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('orders')
          .get();

      // Map the snapshot data to a list of maps and return
      return snapshot.docs.map((doc) {
        return {
          'order_id': doc.id,
          'items': List<Map<String, dynamic>>.from(doc['items']),
          'order_date': doc['order_date'],
          'status': doc['status'],
        };
      }).toList();
    } catch (e) {
      print('Error fetching placed orders: $e');
      return [];
    }
  }

  // Fetch cart items
  Future<List<Map<String, dynamic>>> fetchCartItems() async {
    try {
      String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
      if (currentUserId == null) {
        print("User not signed in.");
        return [];
      }

      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('add_cart')
          .get();

      if (snapshot.docs.isEmpty) {
        print('No cart items found.');
        return [];
      } else {
        snapshot.docs.forEach((doc) {
          print(doc.data());
        });
      }

      return snapshot.docs.map((doc) {
        return {
          'id': doc['id'] ??
              '', // Ensure the field exists, default to empty string
          'title': doc['title'] ??
              'No title', // Ensure the field exists, default to 'No title'
          'description': doc['description'] ??
              '', // Ensure the field exists, default to empty string
          'price': doc['price'] ?? 0, // Ensure the field exists, default to 0
          'category': doc['category'] ??
              '', // Ensure the field exists, default to empty string
          'addCartQty':
              doc['addCartQty'] ?? 1, // Ensure the field exists, default to 1
        };
      }).toList();
    } catch (e) {
      print('Error fetching cart items: $e');
      return [];
    }
  }

// Fetch cart items
}
