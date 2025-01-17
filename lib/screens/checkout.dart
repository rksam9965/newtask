import 'package:flutter/material.dart';
import '../../models/product.dart';
import 'singletone.dart';

class CheckoutPage extends StatelessWidget {
  bool? buy;
  CheckoutPage({this.buy});

  double calculateTotalPrice(List<Product> products) {
    return products.fold(0, (sum, product) => sum + (product.price ?? 0));
  }

  @override
  Widget build(BuildContext context) {
    var productList = CartItems()
        .cartItems
        .map((item) => Product.fromJson(item))
        .toList();
    final double totalPrice = calculateTotalPrice(productList);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: productList.isEmpty
            ? const Center(
          child: Text(
            'Your cart is empty!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Order Summary:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: productList.length,
                itemBuilder: (context, index) {
                  final product = productList[index];
                  return ListTile(
                    leading: Image.network(
                      product.image ?? '',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.image_not_supported,
                            size: 50, color: Colors.grey);
                      },
                    ),
                    title: Text(product.title ?? ''),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('\$${product.price?.toStringAsFixed(2)}',style:const TextStyle(fontWeight: FontWeight.bold,color: Colors.redAccent)),
                        Text('qty: ${product.quantity}',style:const TextStyle(fontWeight: FontWeight.bold,color: Colors.redAccent),),
                      ],
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            Center(
              child: Text(
                'Total Price: \$${totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50,horizontal: 17),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
            if(buy == true) {
              Navigator.pop(context);
            }
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Order placed successfully!')),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
          child: const Text(
            'Place Order',
            style: TextStyle(fontSize: 18,color: Colors.white),
          ),
        ),
      ),
    );
  }
}
