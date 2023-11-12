import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  void addToCart(CartItem newItem) {
    _cartItems.add(newItem);
    notifyListeners();
  }

  void removeFromCart(CartItem itemToRemove) {
    _cartItems.remove(itemToRemove);
    notifyListeners();
  }

  void toggleSelection(CartItem item) {
    item.isSelected = !item.isSelected;
    notifyListeners();
  }

  void incrementQuantity(CartItem item) {
    item.quantity++;
    notifyListeners();
  }

  void decrementQuantity(CartItem item) {
    if (item.quantity > 0) {
      item.quantity--;
      if (item.quantity == 0) {
        removeFromCart(item);
      }
    }
    notifyListeners();
  }

  double calculateTotalPrice() {
    double totalPrice = 0.0;
    for (var cartItem in _cartItems) {
      if (cartItem.isSelected) {
        totalPrice += cartItem.price * cartItem.quantity;
      }
    }
    return totalPrice;
  }
}

class CartItem {
  String name;
  double price;
  String imageUrl;
  bool isSelected;
  int quantity;

  CartItem({
    required this.name,
    required this.price,
    required this.imageUrl,
    this.isSelected = false,
    this.quantity = 1,
  });
}
