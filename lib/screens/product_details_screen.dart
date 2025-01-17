import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'singletone.dart';
import '../utils/colors.dart';
import '../utils/custom_alert.dart';
import '../../models/product.dart';
import 'cart_page.dart'; // Ensure you import the Product model

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  bool? buy;
  int? index;

  ProductDetailScreen({required this.product, this.buy, this.index});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int cartQuantity = 0;
  double productRating = 3.0;

  @override
  void initState() {
    super.initState();
    productRating = double.tryParse(widget.product.rating?.count.toString() ?? '3') ?? 3.0;
    updateCartQuantity();
  }

  void updateCartQuantity() {
    final existingProductIndex = CartItems().cartItems.indexWhere(
          (item) => item['id'] == widget.product.id,
    );

    setState(() {
      cartQuantity = existingProductIndex != -1
          ? CartItems().cartItems[existingProductIndex]['quantity']
          : 1;
    });
  }

  void addToCart() {
    final existingProductIndex = CartItems().cartItems.indexWhere(
          (item) => item['id'] == widget.product.id,
    );

    if (existingProductIndex != -1) {
      CartItems().increaseQuantity(existingProductIndex);
    } else {
       CartItems().addItem({
        'id': widget.product.id,
        'title': widget.product.title,
        'price': widget.product.price,
        'image': widget.product.image,
        'quantity': 1,
      });
    }
    updateCartQuantity();
  }

  void removeFromCart() {
    final existingProductIndex = CartItems().cartItems.indexWhere(
          (item) => item['id'] == widget.product.id,
    );
    if (existingProductIndex != -1) {
      CartItems().decreaseQuantity(existingProductIndex);
      if (CartItems().cartItems[existingProductIndex]['quantity'] == 0) {
        CartItems().removeItem(existingProductIndex);
      }
    }
    updateCartQuantity();
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
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          color: floatingButtonColor,
          borderRadius: BorderRadius.circular(5),
        ),
        width: screenWidth * 0.924,
        height: 64,
        child: FloatingActionButton.extended(
          onPressed: () {
            addToCart();
            Navigator.pop(context);
          },
          label: const Text(
            'Add to Cart',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          backgroundColor: floatingButtonColor,
          elevation: 0,
        ),
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
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.product.description ?? 'No Description',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Price: \$${widget.product.price ?? 'N/A'}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 9),
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
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            setState(() {
                              productRating = rating;
                            });
                          },
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width:60,
                              child: Text(
                                'qty: $cartQuantity',
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
