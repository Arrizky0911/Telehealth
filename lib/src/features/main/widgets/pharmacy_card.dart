import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/src/features/pharmacy/widgets/pharmacy_item.dart';
import 'package:myapp/src/features/pharmacy/pharmacy_screen.dart';
import 'package:myapp/src/models/product.dart';

import '../../pharmacy/product_detail_screen.dart';

class EPharmacySection extends StatefulWidget {
  const EPharmacySection({super.key});

  @override
  State<EPharmacySection> createState() => _EPharmacySectionState();
}

class _EPharmacySectionState extends State<EPharmacySection> {
  List<Product> _products = [];
  Map<String, int> _cartItems = {};

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _loadCartItems();
  }

  Future<void> _loadProducts() async {
    final productsSnapshot = await FirebaseFirestore.instance
        .collection('products')
        .limit(5)
        .get();

    setState(() {
      _products = productsSnapshot.docs
          .map((doc) => Product.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    });
  }

  Future<void> _loadCartItems() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final cartSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .get();

      setState(() {
        _cartItems = Map.fromEntries(
            cartSnapshot.docs.map((doc) => MapEntry(doc.id, doc.data()['quantity'] as int))
        );
      });
    }
  }

  Future<void> _addToCart(Product product) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .doc(product.id)
          .set({
        'productId': product.id,
        ''
        'quantity': FieldValue.increment(1),
      }, SetOptions(merge: true));

      setState(() {
        _cartItems[product.id] = (_cartItems[product.id] ?? 0) + 1;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${product.name} added to cart')),
      );
    }
  }

  Future<void> _updateCartQuantity(Product product, int newQuantity) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final cartRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .doc(product.id);

      if (newQuantity > 0) {
        await cartRef.update({'quantity': newQuantity});
        setState(() {
          _cartItems[product.id] = newQuantity;
        });
      } else {
        await cartRef.delete();
        setState(() {
          _cartItems.remove(product.id);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'E-Pharmacy',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PharmacyShopScreen()),
                  );
                },
                child: const Text(
                  'See All',
                  style: TextStyle(
                    color: Color(0xFFFF4081),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _products.length,
            itemBuilder: (context, index) {
              final product = _products[index];
              return ProductCard(
                product: product,
                cartQuantity: _cartItems[product.id] ?? 0,
                onAddToCart: () => _addToCart(product),
                onUpdateQuantity: (newQuantity) => _updateCartQuantity(product, newQuantity),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductDetailScreen(productId: product.id))
                  );
                }
              );
            },
          ),
        ),
      ],
    );
  }
}

