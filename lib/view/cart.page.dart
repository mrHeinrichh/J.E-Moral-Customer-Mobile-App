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
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          List<CartItem> cartItems = cartProvider.cartItems;

          double _calculateTotalPrice() {
            double totalPrice = 0.0;
            for (var cartItem in cartItems) {
              if (cartItem.isSelected) {
                totalPrice += cartItem.price * cartItem.quantity;
              }
            }
            return totalPrice;
          }

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
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Price:"),
                        Text(
                          "₱${cartProvider.calculateTotalPrice()}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(width: 35),
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
                          width: 70,
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
