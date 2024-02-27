import 'package:customer_app/routes/app_routes.dart';
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  void addToCart({
    required CartItem cartItem,
    required BuildContext context,
  }) {
    int existingIndex = _cartItems.indexWhere((item) => item.id == cartItem.id);

    if (existingIndex != -1) {
      int totalStock = _cartItems[existingIndex].stock + cartItem.stock;

      if (totalStock <= cartItem.availableStock) {
        _cartItems[existingIndex].stock = totalStock;
      } else {
        showCustomOverlay(
          context,
          'Stock Limit Exceeded',
          'The Quantity you are trying to Add exceeds the Available Stock. Please Adjust the Quantity.',
          cartItem.availableStock,
          _cartItems[existingIndex].stock,
          cartItem.stock,
        );

        return;
      }
    } else {
      _cartItems.add(cartItem);
    }
    notifyListeners();

    Navigator.pushNamed(context, cartRoute);
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
    if (item.stock < item.availableStock) {
      item.stock++;
      notifyListeners();
    }
  }

  void clearCart() {
    cartItems.clear();
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
  String id;
  String name;
  String description;
  String category;
  double customerPrice;
  String imageUrl;
  bool isSelected;
  int stock;
  int availableStock;

  CartItem({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.customerPrice,
    required this.imageUrl,
    this.isSelected = true,
    this.stock = 1,
    required this.availableStock,
  });
}

void showCustomOverlay(BuildContext context, String title, String message,
    int stockAvailable, int existingCart, int addingToCart) {
  final overlay = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).size.height * 0.5 - 100,
      left: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          decoration: BoxDecoration(
            color: const Color(0xFFd41111).withOpacity(0.7),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const Divider(),
              const SizedBox(height: 10),
              Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                'Available Stock: $stockAvailable',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'Already in the Cart: $existingCart',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'Quantity to Add in your Cart: $addingToCart',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Overlay.of(context)!.insert(overlay);

  Future.delayed(const Duration(seconds: 3), () {
    overlay.remove();
  });
}
