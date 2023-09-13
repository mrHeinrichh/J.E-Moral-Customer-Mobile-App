import 'package:customer_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> cartItems = [
    CartItem(
      name: 'Regasco',
      price: 310.0,
      quantity: 2,
      imageUrl:
          'https://raw.githubusercontent.com/mrHeinrichh/J.E-Moral-cdn/main/assets/png/brandnewtanks/Beverage-Elements-20-lb-propane-tank-steel-new%201.png',
    ),
    CartItem(
      name: 'Solane',
      price: 215.0,
      quantity: 1,
      imageUrl:
          'https://raw.githubusercontent.com/mrHeinrichh/J.E-Moral-cdn/main/assets/png/refilltanks/Bg.png',
    ),
    CartItem(
      name: 'Regulator',
      price: 218.0,
      quantity: 3,
      imageUrl:
          'https://raw.githubusercontent.com/mrHeinrichh/J.E-Moral-cdn/main/assets/png/accessories/9764832_546062cf-143f-4750-a49b-344311c46413_700_700%201%20(1).png',
    ),
  ];

  @override
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
      body: Column(
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
            separatorBuilder: (context, index) =>
                Divider(), // Add a divider between items
            itemBuilder: (context, index) {
              final cartItem = cartItems[index];
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
                              setState(() {
                                cartItem.isSelected = value ?? false;
                              });
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
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () {
                                      setState(() {
                                        if (cartItem.quantity > 0) {
                                          cartItem.quantity--;

                                          // Remove the item from the list if quantity is 0
                                          if (cartItem.quantity == 0) {
                                            final updatedCartItems =
                                                List.of(cartItems);
                                            updatedCartItems.removeAt(index);
                                            setState(() {
                                              cartItems = updatedCartItems;
                                            });
                                          }
                                        }
                                      });
                                    },
                                  ),
                                  Text('${cartItem.quantity}'),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      setState(() {
                                        cartItem.quantity++;
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    width: 70,
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        final updatedCartItems =
                                            List.of(cartItems);
                                        updatedCartItems.removeAt(index);
                                        setState(() {
                                          cartItems = updatedCartItems;
                                        });
                                      });
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
            },
          )),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Price:"),
                    Text(
                      "₱${_calculateTotalPrice()}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ) // Display total price
                  ],
                ),
                const SizedBox(width: 35),
                CustomizedButton(
                  onPressed: () {
                    // Handle checkout logic
                  },
                  text: 'Place Order',
                  height: 60,
                  width: 260,
                  fontz: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to calculate the total price
  double _calculateTotalPrice() {
    double totalPrice = 0.0;
    for (var cartItem in cartItems) {
      totalPrice += cartItem.price * cartItem.quantity;
    }
    return totalPrice;
  }
}

class CartItem {
  final String name;
  final double price;
  final String imageUrl; // Add this field
  int quantity;
  bool isSelected;

  CartItem({
    required this.name,
    this.price = 0.0,
    required this.quantity,
    this.isSelected = false,
    required this.imageUrl, // Add this field to store the image URL
  });
}
