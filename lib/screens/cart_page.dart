import 'package:flutter/material.dart';
import 'singletone.dart';
import 'checkout.dart'; // Import the CartItems singleton

class CartPage extends StatefulWidget {
  bool? buy;
  CartPage({super.key, this.buy});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  @override
  void initState() {
    super.initState();
  }

  void increaseQuantity(int index) {
    setState(() {
      CartItems().increaseQuantity(index);
    });
  }

  void decreaseQuantity(int index) {
    setState(() {
      CartItems().decreaseQuantity(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = CartItems().cartItems;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Cart'),
        backgroundColor: Colors.white,
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text('Your cart is empty.'))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final product = cartItems[index];
                return ListTile(
                  leading: Image.network(
                    product['image'] ?? '',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(product['title'] ?? ''),
                  subtitle: Row(
                    children: [
                      Text(
                          '\$${product['price']} x ${product['quantity']} = \$${(product['price'] * product['quantity']).toStringAsFixed(2)}'),
                      const Spacer(),
                      IconButton(
                        onPressed: () => decreaseQuantity(index),
                        icon: const Icon(Icons.remove),
                      ),
                      Text(
                        '${product['quantity']}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: () => increaseQuantity(index),
                        icon: Icon(Icons.add),
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: cartItems.isNotEmpty
          ? SizedBox(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckoutPage(buy: widget.buy),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text(
                    'Proceed to Checkout',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
