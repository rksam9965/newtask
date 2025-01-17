import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/firestore_services.dart';

class PlacedOrder extends StatefulWidget {
  @override
  _PlacedOrderState createState() => _PlacedOrderState();
}

class _PlacedOrderState extends State<PlacedOrder> {
  late Future<List<Map<String, dynamic>>> ordersFuture;

  @override
  void initState() {
    super.initState();
    ordersFuture = FirestoreService().fetchPlacedOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Placed Orders",
          style: TextStyle(fontSize: 18),
        ),
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
            return const Center(child: Text('No orders found.'));
          }

          List<Map<String, dynamic>> orders = snapshot.data!;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                color: Colors.grey,
                margin: const EdgeInsets.all(8),
                elevation: 5,
                child: ListTile(
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Id: ${order['order_id']}',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Status: ${order['status']}',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Date: ${DateFormat('dd/MM/yyyy').format(order['order_date'].toDate())}',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Items: ${order['items'].length} item(s)',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  isThreeLine: true,
                  onTap: () {
                    // Navigate to order details or perform other actions
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
