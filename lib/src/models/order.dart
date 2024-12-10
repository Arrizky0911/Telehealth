import 'package:cloud_firestore/cloud_firestore.dart';

class Address {
  final String city;
  final String postalCode;
  final String state;
  final String street;

  Address({
    required this.city,
    required this.postalCode,
    required this.state,
    required this.street,
  });

  // You can add a factory constructor to create an Address from a map (optional)
 Map<String, dynamic> toMap() {
    return {
      'city': city,
      'postalCode': postalCode,
      'state': state,
      'street': street,
    };
  }
}

class OrderItem {
  final int price;
  final String productId;
  final int quantity;

  OrderItem({
    required this.price,
    required this.productId,
    required this.quantity,
  });

  // You can add a factory constructor to create an OrderItem from a map (optional)
  Map<String, dynamic> toMap() {
    return {
      'price': price,
      'productId': productId,
      'quantity': quantity,
    };
  }
}

class Order {
  final String orderId;
  final Address address;
  final DateTime createdAt;
  final List<OrderItem> items;
  final String paymentMethod;
  final int shipping;
  final String status;
  final int subtotal;
  final int total;

  Order({
    required this.orderId,
    required this.address,
    required this.createdAt,
    required this.items,
    required this.paymentMethod,
    required this.shipping,
    required this.status,
    required this.subtotal,
    required this.total,
  });

  // You can add a factory constructor to create an Order from a map (optional)
  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'address': address.toMap(), // Call toMap() on the address object
      'createdAt': createdAt, // Firestore will automatically handle DateTime
      'items': items.map((item) => item.toMap()).toList(), // Call toMap() on each item
      'paymentMethod': paymentMethod,
      'shipping': shipping,
      'status': status,
      'subtotal': subtotal,
      'total': total,
    };
  }
}