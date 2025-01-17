import 'package:fires/screens/product_details_screen.dart';
import 'package:flutter/material.dart';
import '../services/api_repo.dart';
import '../utils/custom_alert.dart';
import '../../models/product.dart';
import '../utils/home_menu_list.dart';
import 'cart_page.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  ProductList? products;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int count = 0;
  bool cart = false;
  bool buy = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      getDatum();
    });
  }

  Future<void> getDatum() async {
    displayProgress(context);
    await Future.delayed(const Duration(seconds: 2));
    getDatumList().then((ProductList productList) {
      hideProgress(context);
      if (productList.products!.isNotEmpty) {
        debugPrint('SUCCESS...');
        setState(() {
          products = productList;
        });
      } else {
        displayAlert(context, scaffoldKey, 'No products found.');
      }
    }).catchError((error, stackTrace) {
      hideProgress(context);
      debugPrint(error.toString());
      debugPrint(stackTrace.toString());
      displayAlert(context, scaffoldKey, error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey, // Assign the scaffoldKey to the Scaffold
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Product",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        // Hamburger menu button that opens the drawer
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Open the drawer using the scaffoldKey
            scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
          Stack(children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined,
                  color: Colors.black, size: 24),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartPage(buy: cart),
                  ),
                );
              },
            ),
          ]),
        ],
      ),
      drawer: HomeMenuList(), // The drawer is assigned correctly here
      body: products == null
          ? const Center()
          : ListView.builder(
              itemCount: products?.products?.length ?? 0,
              itemBuilder: (context, index) {
                final product = products?.products?[index];
                return card(product!, context, index);
              },
            ),
    );
  }

  Widget card(Product product, BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.only(top: 2),
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Positioned(
              top: 15,
              bottom: 15,
              left: 25,
              child: CircleAvatar(
                radius: 70,
                backgroundColor: Colors.white,
                child: ClipOval(
                  child: Image.network(
                    product.image.toString(),
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      'assets/images/sinimagen.png',
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 20,
              left: 170,
              right: 10,
              child: Text(
                product.title.toString(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Positioned(
              top: 155,
              left: 170,
              right: 10,
              child: Text(
                '\$${product.price.toString()}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                ),
              ),
            ),
            Positioned(
              top: 140,
              right: 10,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailScreen(
                          product: product, buy: buy, index: index),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.purple),
                ),
                child: const Text(
                  'Buy',
                  style: TextStyle(
                    color: Colors.purple,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 5,
              left: 5,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.favorite_outline_outlined,
                  color: Colors.redAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
