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

  void incrementStock(CartItem item) {
    item.stock++;
    notifyListeners();
  }

  void clearCart() {
    // Clear the cart items
    cartItems.clear();
    // Notify listeners to update the UI
    notifyListeners();
  }

  void decrementStock(CartItem item) {
    if (item.stock > 0) {
      item.stock--;
      if (item.stock == 0) {
        removeFromCart(item);
      }
    }
    notifyListeners();
  }

  double calculateTotalPrice() {
    double totalPrice = 0.0;
    for (var cartItem in _cartItems) {
      if (cartItem.isSelected) {
        totalPrice += cartItem.customerPrice * cartItem.stock;
      }
    }
    return totalPrice;
  }
}

class CartItem {
  int id;
  String name;
  double customerPrice;
  String imageUrl;
  bool isSelected;
  int stock;

  CartItem({
    required this.id,
    required this.name,
    required this.customerPrice,
    required this.imageUrl,
    this.isSelected = true,
    this.stock = 1,
  });
}
