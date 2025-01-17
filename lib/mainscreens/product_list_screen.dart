import 'package:fires/mainscreens/product_details_screen.dart';
import 'package:flutter/material.dart';
import '../services/api_repo.dart';
import '../utils/custom_alert.dart';
import '../../models/product.dart';
import '../utils/home_menu_list.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool _isLoading = true;
  ProductList? products;
  final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>(); // Use the scaffoldKey

  int Count = 0;

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 0), () {
      getDatum();
    });
    super.initState();
  }

  Future<void> getDatum() async {
    displayProgress(context);
    getDatumList().then((ProductList productList) {
      hideProgress(context);
      if (productList.products!.isNotEmpty) {
        debugPrint('SUCCESS...');
        setState(() {
          products = productList;
        });
      } else {}
    }).catchError((error, stackTrace) {
      hideProgress(context);
      debugPrint(error.toString());
      debugPrint(stackTrace.toString());
      displayAlert(context, GlobalKey(), error.toString());
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
          icon: Icon(Icons.menu),
          onPressed: () {
            // Open the drawer using the scaffoldKey
            scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: HomeMenuList(), // The drawer is assigned correctly here
      body: ListView.builder(
        itemCount: products?.products!.length,
        itemBuilder: (context, index) {
          final product = products?.products![index];
          return Container(
            height: 100,
            margin: EdgeInsets.only(top: 10), // Margin at the top
            decoration: BoxDecoration(
              color: Colors.white, // Background color of the container
              borderRadius: BorderRadius.circular(8), // Rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.grey, // Shadow color with opacity
                  spreadRadius: 1, // Spread of the shadow
                  blurRadius: 5, // Blur effect
                  offset: Offset(0, 2), // Horizontal and vertical offset
                ),
              ],
            ),
            child: InkWell(
              onTap: () {
                if (product != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailScreen(
                        product: product,
                      ),
                    ),
                  );
                }
              },
              child: Container(
                padding: EdgeInsets.only(
                    left: 16), // Optional padding to give the content space
                child: Row(
                  children: [
                    const Icon(Icons.shopping_cart), // Example icon
                    SizedBox(width: 10), // Space between icon and text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            product?.title ?? 'No Title',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12, // Adjusted font size
                            ),
                            overflow: TextOverflow
                                .ellipsis, // Add ellipsis for overflow
                            maxLines:
                                1, // Ensure the title does not wrap to multiple lines
                          ),
                          Text(
                            '\$${product?.price}',
                            style: TextStyle(
                                fontSize:
                                    12), // Adjust price font size as needed
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
