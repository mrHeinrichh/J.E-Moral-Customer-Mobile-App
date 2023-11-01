import 'package:flutter/material.dart';

class CartItem {
  final String name;
  final double price;
  int quantity;
  final String imageUrl;
  bool isSelected; // Define isSelected property

  CartItem({
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    this.isSelected = false, // Initialize isSelected property
  });
}

class CartProvider extends ChangeNotifier {
  List<CartItem> cartItems = [];

  void addToCart(CartItem item) {
    cartItems.add(item);
    notifyListeners();
  }

  void removeFromCart(CartItem item) {
    cartItems.remove(item);
    notifyListeners();
  }
}
