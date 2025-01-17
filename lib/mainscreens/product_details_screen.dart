import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../services/firestore_services.dart';
import '../utils/colors.dart';
import '../utils/custom_alert.dart';
import '../../models/product.dart'; // Add this import

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  ProductDetailScreen({required this.product});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isFilled = false;
  int cartQuantity = 0;
  double productRating = 3.0; // Default rating is 3
  final FirestoreService _firestoreService = FirestoreService();
  late Future<List<Map<String, dynamic>>> _entriesFutureCart;
  int update = 0;
  String pro = "";

  @override
  void initState() {
    super.initState();
    pro = widget.product.id.toString();
    getExistingCartQuantity(pro);
    _entriesFutureCart = _firestoreService.fetchCartItems();
  }

  Future<void> getExistingCartQuantity(String productId) async {
    debugPrint("Fetching existing cart quantity for product ID: $productId");

    try {
      String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
      if (currentUserId == null) {
        debugPrint("User not signed in.");
        return;
      }

      CollectionReference userCart = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection('add_cart');

      QuerySnapshot existingCartItemSnapshot =
          await userCart.where('id', isEqualTo: productId).get();

      if (existingCartItemSnapshot.docs.isNotEmpty) {
        int fetchedQuantity =
            existingCartItemSnapshot.docs.first['addCartQty'] ?? 0;
        setState(() {
          update = fetchedQuantity;
          cartQuantity = fetchedQuantity;
        });
        debugPrint("Existing quantity for product $productId: $update");
      } else {
        debugPrint("No existing quantity found for product $productId.");
      }
    } catch (e) {
      debugPrint("Error fetching cart quantity: $e");
    }
  }

  void addToCart(bool increment) async {
    String title = widget.product.title ?? 'Unknown Title';
    String description = widget.product.description ?? 'No Description';
    String id = widget.product.id ?? '';
    String price = widget.product.price.toString() ?? '0';
    String category = widget.product.category ?? 'Uncategorized';

    // Check if title or description is empty before displaying the progress
    if (title.isEmpty || description.isEmpty) {
      _showMessage('Title and description cannot be empty');
      return;
    }

    // Show the progress indicator before starting the async operation
    displayProgress(context);

    try {
      String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
      if (currentUserId == null) {
        hideProgress(context); // Hide progress if user is not signed in
        _showMessage('User not signed in');
        return;
      }

      CollectionReference userCart = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection('add_cart');

      DocumentReference cartItemRef = userCart.doc(id);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(cartItemRef);

        if (snapshot.exists) {
          int currentQuantity = snapshot['addCartQty'] ?? 0;
          int newQuantity =
              increment ? currentQuantity + 1 : currentQuantity - 1;

          if (newQuantity > 0) {
            transaction.update(cartItemRef, {'addCartQty': newQuantity});
            setState(() {
              cartQuantity = newQuantity;
            });
            // _showMessage('Cart updated successfully!');
          } else {
            transaction.delete(cartItemRef);
            setState(() {
              cartQuantity = 0;
            });
            // _showMessage('Item removed from cart.');
          }
        } else {
          if (increment) {
            transaction.set(cartItemRef, {
              'title': title,
              'description': description,
              'id': id,
              'price': price,
              'category': category,
              'addCartQty': 1,
            });
            setState(() {
              cartQuantity = 1;
            });
            // _showMessage('Item added to cart successfully!');
          }
        }
      });
    } catch (e) {
      _showMessage('Error: $e');
    } finally {
      // Hide the progress indicator after the async operation is complete
      hideProgress(context);
    }
  }

  void placeOrder() async {
    try {
      await _firestoreService.placeOrder();
      setState(() {
        // cartQuantity = 0;
        _entriesFutureCart = _firestoreService.fetchCartItems();
      });
      _showMessage('Order placed successfully!');
      Navigator.pop(context);
    } catch (e) {
      _showMessage('Error placing order: $e');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.product.title ?? 'Product Details',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: screenWidth * 0.08, bottom: 40),
            decoration: BoxDecoration(
              color: floatingButtonColor,
              borderRadius: BorderRadius.circular(5),
            ),
            width: screenWidth / 6,
            height: 64,
            child: Stack(
              children: [
                FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      cartQuantity++;
                    });
                    addToCart(true);
                  },
                  backgroundColor: floatingButtonColor,
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    child: Icon(
                      cartQuantity > 0
                          ? Icons.shopping_cart
                          : Icons.shopping_cart_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                if (cartQuantity > 0)
                  Positioned(
                    right: 4,
                    top: 4,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$cartQuantity',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: screenWidth * 0.045, bottom: 40),
            decoration: BoxDecoration(
              color: floatingButtonColor,
              borderRadius: BorderRadius.circular(5),
            ),
            width: screenWidth / 1.45,
            height: 64,
            child: FloatingActionButton.extended(
              onPressed: () {
                placeOrder();
              },
              label: const Text(
                'Place Order',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              backgroundColor: floatingButtonColor,
              elevation: 0,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: widget.product.id.toString(),
              child: widget.product.image != null
                  ? Image.network(
                      widget.product.image!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Container(),
            ),
            Container(
              height: screenHeight * 0.50,
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.title ?? 'No Title',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      widget.product.description ?? 'No Description',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Price: \$${widget.product.price ?? 'N/A'}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RatingBar.builder(
                          initialRating: productRating,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 30,
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            setState(() {
                              productRating = rating;
                            });
                          },
                        ),
                        SizedBox(
                          width: screenWidth * 0.16,
                        ),
                        IconButton(
                          onPressed: () {
                            if (cartQuantity > 0) {
                              addToCart(false);
                            }
                          },
                          icon: Icon(Icons.remove),
                        ),
                        Text(
                          '$cartQuantity',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: () {
                            addToCart(true);
                          },
                          icon: Icon(Icons.add),
                        ),
                      ],
                    ),
                    // Rating Bar

                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
