import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:customer_app/view/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:customer_app/routes/app_routes.dart';
import 'package:customer_app/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Future<Map<String, dynamic>> userData;
  bool isDiscounted = false;

  @override
  void initState() {
    super.initState();
    // Accessing userId from UserProvider
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
        print('User ID: $userId');
        print('Response Body: $userData');

        // Set isDiscounted based on the value of "discounted" in the user data
        isDiscounted = userData['data']['discounted'] ?? false;

        return userData;
      } else {
        print('Failed to load user data. Status code: ${response.statusCode}');
        throw Exception('Failed to load user data');
      }
    } catch (error) {
      print('Error: $error');
      throw error;
    }
  }

  double _calculateTotalPrice(List<CartItem> cartItems) {
    double totalPrice = 0.0;
    for (var cartItem in cartItems) {
      if (cartItem.isSelected) {
        totalPrice += cartItem.price * cartItem.quantity;
      }
    }

    // Apply a 20% discount if isDiscounted is true
    if (isDiscounted) {
      double discountAmount = totalPrice * 0.2; // 20% discount
      totalPrice -= discountAmount;
    }

    return totalPrice;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Padding(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Text(
            'Cart',
            style: TextStyle(color: Color(0xFF232937), fontSize: 24),
          ),
        ),
      ),
      body: Consumer2<CartProvider, UserProvider>(
        builder: (context, cartProvider, userProvider, child) {
          // Accessing userId from UserProvider
          String? userId = userProvider.userId;

          // Print userId here to ensure it is not null
          print('User ID: $userId');

          List<CartItem> cartItems = cartProvider.cartItems;

          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 5, 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 20),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: cartItems.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (context, index) {
                    return CartItemWidget(cartItem: cartItems[index]);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Price:"),
                        Text(
                          "₱${_calculateTotalPrice(cartItems)}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    CustomizedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, setDeliveryPage);
                      },
                      text: 'Place Order',
                      height: 60,
                      width: 240,
                      fontz: 20,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;

  const CartItemWidget({required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ListTile(
        contentPadding: EdgeInsets.all(20),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Checkbox(
                  value: cartItem.isSelected,
                  onChanged: (value) {
                    Provider.of<CartProvider>(context, listen: false)
                        .toggleSelection(cartItem);
                  },
                ),
                Image.network(
                  cartItem.imageUrl,
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error);
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cartItem.name,
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      '₱${cartItem.price * cartItem.quantity}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            Provider.of<CartProvider>(context, listen: false)
                                .decrementQuantity(cartItem);
                          },
                        ),
                        Text('${cartItem.quantity}'),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            Provider.of<CartProvider>(context, listen: false)
                                .incrementQuantity(cartItem);
                          },
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            Provider.of<CartProvider>(context, listen: false)
                                .removeFromCart(cartItem);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
