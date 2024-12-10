import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:myapp/src/features/checkout/widgets/payment_detail.dart';
import 'package:myapp/src/features/checkout/widgets/shipping_address.dart';
import 'package:myapp/src/models/cart_item.dart';
import 'package:myapp/src/models/product.dart';
import 'package:myapp/src/features/checkout/checkout_result.dart';
import 'package:uuid/uuid.dart';
import 'package:myapp/src/models/order.dart' as myOrder; // Import your Order model


class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _postalCodeController = TextEditingController();
  List<CartItem> _cartItems = [];
  bool _isLoading = true;
  final _currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
  String _selectedPaymentMethod = 'Credit Card';

  @override
  void initState() {
    super.initState();
    _loadCartItems();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        final address = userData['address'] as Map<String, dynamic>?;
        setState(() {
          _streetController.text = address?['street'] ?? '';
          _cityController.text = address?['city'] ?? '';
          _stateController.text = address?['state'] ?? '';
          _postalCodeController.text = address?['postalCode'] ?? '';
        });
      }
    }
  }

  Future<void> _loadCartItems() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final cartSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .get();

      final List<CartItem> items = [];
      for (var doc in cartSnapshot.docs) {
        final data = doc.data();
        final productSnapshot = await FirebaseFirestore.instance
            .collection('products')
            .doc(data['productId'] as String)
            .get();

        if (productSnapshot.exists) {
          final productData = productSnapshot.data()!;
          productData['id'] = productSnapshot.id;
          items.add(CartItem(
            product: Product.fromMap(productData),
            quantity: data['quantity'] as int,
          ));
        }
      }

      setState(() {
        _cartItems = items;
        _isLoading = false;
      });
    }
  }

  Future<void> _updateCartItemQuantity(CartItem item, bool increment) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final newQuantity = increment ? item.quantity + 1 : item.quantity - 1;
      if (newQuantity >= 0) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('cart')
            .doc(item.product.id)
            .update({'quantity': newQuantity});

        setState(() {
          item.quantity = newQuantity;
        });
      }
    }
  }

  double get _subtotal => _cartItems.fold(
    0,
        (sum, item) => sum + (item.product.price * item.quantity),
  );

  double get _total => _subtotal + 24000;

  Widget _buildCartItem(CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                item.product.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.medication_rounded,
                  color: Colors.grey[400],
                  size: 30,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _currencyFormat.format(item.product.price),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => _updateCartItemQuantity(item, false),
                icon: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF4081),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.remove,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
              Text(
                '${item.quantity}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              IconButton(
                onPressed: () => _updateCartItemQuantity(item, true),
                icon: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF4081),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Method',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _selectedPaymentMethod,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: ['Credit Card', 'PayPal', 'Bank Transfer']
                .map((method) => DropdownMenuItem(
              value: method,
              child: Text(method),
            ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedPaymentMethod = value!;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            if (title == 'Cart Items (${_cartItems.length})')
              const Icon(Icons.more_horiz, color: Colors.grey)
          ],
        ),
        const SizedBox(height: 16),
        child,
      ],
    );
  }

 Widget _buildShippingAddress() {
  return ShippingAddress(
    streetController: _streetController,
    cityController: _cityController,
    stateController: _stateController,
    postalCodeController: _postalCodeController,
    saveAddress: () {
      // Call setState to rebuild the widget with the updated address
      setState(() {}); 
    },
  );
}

  Widget _buildPaymentDetail() {
    return PaymentDetail(currencyFormat: _currencyFormat, cartItems: _cartItems, total: _total);
  }

  Future<void> _placeOrder() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final String orderId = const Uuid().v4();
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          myOrder.Address address = myOrder.Address(
                      city: _cityController.text,
                      postalCode: _postalCodeController.text,
                      state: _stateController.text,
                      street: _streetController.text,
                    );

           // Create OrderItem objects
          List<myOrder.OrderItem> orderItems = _cartItems.map((item) => 
            myOrder.OrderItem(
              price: item.product.price.toInt(), // Assuming price is an int
              productId: item.product.id,
              quantity: item.quantity,
            )
          ).toList();

           // Create an Order object
          myOrder.Order order = myOrder.Order(
            orderId: orderId,
            address: address,
            createdAt: DateTime.now(), 
            items: orderItems,
            paymentMethod: _selectedPaymentMethod,
            shipping: 24000,
            status: 'pending',
            subtotal: _subtotal.toInt(),
            total: _total.toInt(),
          );

          final orderRef =  await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('orders') 
              .doc(orderId)
              .set(order.toMap()); 

          // Clear cart after successful order
          final cartDocs = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('cart')
              .get();

          for (var doc in cartDocs.docs) {
            await doc.reference.delete();
          }

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => CheckoutResultScreen(orderId: orderId),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error placing order: $e')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSection(
                  'Cart Items (${_cartItems.length})',
                  Column(
                    children:
                    _cartItems.map((item) => _buildCartItem(item)).toList(),
                  ),
                ),
                const SizedBox(height: 24),
                _buildSection('Shipping Address', _buildShippingAddress()),
                const SizedBox(height: 24),
                _buildSection('Payment Method', _buildPaymentMethod()),
                const SizedBox(height: 24),
                _buildSection('Payment Detail', _buildPaymentDetail()),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _placeOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF4081),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Checkout',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}