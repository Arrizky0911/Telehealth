import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/src/features/checkout/checkout_screen.dart';
import 'package:myapp/src/features/pharmacy/product_detail_screen.dart';
import 'package:myapp/src/models/product.dart';
import 'package:myapp/src/features/pharmacy/widgets/pharmacy_item.dart';

class PharmacyShopScreen extends StatefulWidget {
  const PharmacyShopScreen({Key? key}) : super(key: key);

  @override
  _PharmacyShopScreenState createState() => _PharmacyShopScreenState();
}

class _PharmacyShopScreenState extends State<PharmacyShopScreen> {
  List<Product> _products = [];
  Map<String, int> _cartItems = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _loadCartItems();
  }

  Future<void> _loadProducts() async {
    try {
      final productsSnapshot = await FirebaseFirestore.instance.collection('products').get();
      setState(() {
        _products = productsSnapshot.docs
            .map((doc) => Product.fromMap({...doc.data(), 'id': doc.id}))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading products: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadCartItems() async {
    try {
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
    } catch (e) {
      print('Error loading cart items: $e');
    }
  }

  Future<void> _addToCart(Product product) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to add items to cart')),
      );
      return;
    }

    try {
      final cartRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .doc(product.id);

      await cartRef.set({
        'productId': product.id,
        'quantity': 1,
      });

      setState(() {
        _cartItems[product.id] = 1;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Added to cart')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _updateCartQuantity(Product product, int newQuantity) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating cart: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'E-Pharmacy',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 16),
          SizedBox(
            height: 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
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
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: _cartItems.isNotEmpty
              ? () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CheckoutScreen())
            );
          }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF4081),
            disabledBackgroundColor: Colors.grey,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            _cartItems.isNotEmpty
                ? 'Checkout (${_cartItems.values.reduce((a, b) => a + b)} items)'
                : 'Cart is Empty',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
