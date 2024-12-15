import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/src/models/order.dart' as myOrder;
import 'package:myapp/src/models/product.dart'; // Import your Product model

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text('User not logged in'));
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Order History',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('orders')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data!.docs.map((doc) {
            final data = doc.data();
            return myOrder.Order( // Use the alias here
              orderId: data['orderId'],
              address: myOrder.Address( // Use the alias here
                street: data['address']['street'],
                city: data['address']['city'],
                state: data['address']['state'],
                postalCode: data['address']['postalCode'],
              ),
              createdAt: (data['createdAt'] as Timestamp).toDate(),
              items: (data['items'] as List).map((item) {
                return myOrder.OrderItem( // Use the alias here
                  price: item['price'].toInt(),
                  productId: item['productId'],
                  quantity: item['quantity'].toInt(),
                );
              }).toList(),
              paymentMethod: data['paymentMethod'],
              shipping: data['shipping'].toInt(),
              status: data['status'],
              subtotal: data['subtotal'].toInt(),
              total: data['total'].toInt(),
            );
          }).toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return OrderHistoryCard(order: order);
            },
          );
        },
      ),
    );
  }
}

class OrderHistoryCard extends StatelessWidget {
  final myOrder.Order order; // Use the Order class defined below
  const OrderHistoryCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
        locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order ID: ${order.orderId}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Items:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            // Fetch and display product details
            ...order.items.map((item) {
              return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                future: FirebaseFirestore.instance
                    .collection('products')
                    .doc(item.productId)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Text('Error loading product');
                    }
                    if (snapshot.hasData) {
                      final productData = snapshot.data!.data()!;
                      productData['id'] = snapshot.data!.id;
                      Product product = Product.fromMap(productData);
                      return Text('- ${item.quantity}x ${product.name}');
                    } else {
                      return const Text('Product not found');
                    }
                  } else {
                    return const Text('Loading...');
                  }
                },
              );
            }).toList(),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}