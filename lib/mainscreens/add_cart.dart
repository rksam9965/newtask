import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddCart extends StatefulWidget {
  @override
  _AddCartState createState() => _AddCartState();
}

class _AddCartState extends State<AddCart> {
  late Future<List<Map<String, dynamic>>> ordersFuture;

  @override
  void initState() {
    super.initState();
    ordersFuture = fetchCartItems();
  }

  Future<List<Map<String, dynamic>>> fetchCartItems() async {
    try {
      String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
      if (currentUserId == null) {
        debugPrint("User not signed in.");
        return [];
      }

      // Reference to the user's cart collection
      CollectionReference userCart = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection('add_cart');

      // Fetch all cart items for the current user
      QuerySnapshot snapshot = await userCart.get();

      if (snapshot.docs.isEmpty) {
        debugPrint('No cart items found.');
      }

      // Map the snapshot data to a list of maps and return it
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': data['id'] ?? '', // Ensure 'id' exists
          'title': data['title'] ?? 'No title', // Ensure 'title' exists
          'description':
              data['description'] ?? '', // Ensure 'description' exists
          'price': data['price'] ?? 0, // Ensure 'price' exists
          'category': data['category'] ?? '', // Ensure 'category' exists
          'addCartQty': data['addCartQty'] ?? 1, // Ensure 'addCartQty' exists
          'created_at': data['created_at'] != null
              ? (data['created_at'] as Timestamp).toDate()
              : DateTime
                  .now(), // Ensure 'created_at' exists and convert Timestamp
        };
      }).toList();
    } catch (e) {
      debugPrint('Error fetching cart items: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Add Cart Details",
            style: TextStyle(fontSize: 18, color: Colors.black)),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No cart items found.'));
          }

          List<Map<String, dynamic>> orders = snapshot.data!;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                color: Colors.white,
                elevation: 5,
                child: ListTile(
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Order Id: ${order['id']}',
                          style: TextStyle(color: Colors.black)),
                      Text('Price: \$${order['price']}',
                          style: TextStyle(color: Colors.black)),
                      Text('Category: ${order['category']}',
                          style: TextStyle(color: Colors.black)),
                      Text('Quantity: ${order['addCartQty']}',
                          style: TextStyle(color: Colors.black)),
                      Text(
                        'Total Price: \$${(double.parse(order['addCartQty'].toString()) * double.parse(order['price'].toString())).toString()}',
                        style: TextStyle(color: Colors.black),
                      ),
                      Text(
                        'Created at: ${DateFormat('dd/MM/yyyy').format(order['created_at'])}',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  isThreeLine: true,
                  onTap: () {
                    // Add navigation or action on tap if needed
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
