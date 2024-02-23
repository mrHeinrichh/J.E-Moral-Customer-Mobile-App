import 'dart:convert';
import 'package:customer_app/widgets/checkout_cart.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:customer_app/routes/app_routes.dart';
import 'package:customer_app/widgets/custom_button.dart';
import 'cart_provider.dart';
import 'user_provider.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Future<Map<String, dynamic>> userData;

  @override
  void initState() {
    super.initState();
    final String? userId =
        Provider.of<UserProvider>(context, listen: false).userId;
    userData = fetchUserData(userId);
  }

  Future<Map<String, dynamic>> fetchUserData(String? userId) async {
    try {
      final response = await http.get(
          Uri.parse('https://lpg-api-06n8.onrender.com/api/v1/users/$userId'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = json.decode(response.body);
        return userData;
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (error) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFd41111).withOpacity(0.8),
        title: const Text(
          "Cart",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color(0xFFe7e0e0),
      body: Consumer2<CartProvider, UserProvider>(
        builder: (context, cartProvider, userProvider, child) {
          String? userId = userProvider.userId;

          List<CartItem> cartItems = cartProvider.cartItems;

          double calculateTotalPrice() {
            double totalPrice = 0.0;
            for (var cartItem in cartItems) {
              if (cartItem.isSelected) {
                totalPrice += cartItem.customerPrice * cartItem.stock;
              }
            }
            return totalPrice;
          }

          return FutureBuilder<Map<String, dynamic>>(
            future: userData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                Map<String, dynamic> userData = snapshot.data!;
                print('User ID: $userId');

                return Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 5, 5),
                      child: SizedBox(
                        height: 20,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          return CartItemWidget(cartItem: cartItems[index]);
                        },
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Selected Item${cartItems.where((item) => item.isSelected).length > 1 ? 's' : ''}: (${cartItems.where((item) => item.isSelected).length})",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF050404).withOpacity(0.8),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Price:",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF050404)
                                        .withOpacity(0.8),
                                  ),
                                ),
                                Text(
                                  calculateTotalPrice() % 1 == 0
                                      ? '₱${calculateTotalPrice().toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match match) => '${match[1]},')}'
                                      : '₱${calculateTotalPrice().toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match match) => '${match[1]},')}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: const Color(0xFFd41111)
                                        .withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                            CartButton(
                              onPressed: () {
                                Navigator.pushNamed(context, setDeliveryPage);
                              },
                              text: 'Checkout',
                              height: 60,
                              width: double.infinity,
                              fontz: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          );
        },
      ),
    );
  }
}
