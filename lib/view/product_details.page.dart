import 'package:flutter/material.dart';
import 'package:customer_app/routes/app_routes.dart';
import 'package:customer_app/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';

class ProductDetailsPage extends StatefulWidget {
  final String productName;
  final String productPrice;
  final String productImageUrl;
  final String category;
  final String description;
  final String weight;
  final String quantity;

  ProductDetailsPage({
    required this.productName,
    required this.productPrice,
    required this.productImageUrl,
    required this.category,
    required this.description, // Added description
    required this.weight, // Added weight
    required this.quantity, // Added quantity
  });

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int quantity = 1; // Initial quantity

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    final titleText = "${widget.productName} - ${widget.category}";

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          titleText,
          style: TextStyle(color: Color(0xFF232937), fontSize: 24),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Image.network(
                  widget.productImageUrl,
                  width: 400,
                  height: 400,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 20),
                Text(
                    "Description: ${widget.description}"), // Display description
                Text("Weight: ${widget.weight}"), // Display weight
                Text("Quantity: ${widget.quantity}"), // Display quantity
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 170,
        child: BottomAppBar(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Stock Available: 10"),
                    SizedBox(
                      width: 150,
                    ),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey,
                          width: 0.50,
                        ),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.remove,
                          size: 15,
                        ),
                        onPressed: () {
                          setState(() {
                            if (quantity > 1) {
                              quantity--;
                            }
                          });
                        },
                      ),
                    ),
                    Text(
                      "$quantity",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF232937),
                      ),
                    ),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey,
                          width: 0.50,
                        ),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.add,
                          size: 15,
                        ),
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Price: \n₱${(double.tryParse(widget.productPrice) ?? 0) * quantity}",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFF232937),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CustomizedButton(
                      onPressed: () {
                        cartProvider.addToCart(
                          CartItem(
                            name: widget.productName,
                            price: double.parse(widget.productPrice),
                            quantity: quantity,
                            imageUrl: widget.productImageUrl,
                          ),
                        );
                        Navigator.pushNamed(context, cartRoute);
                      },
                      text: 'Add to Cart',
                      height: 60,
                      width: 220,
                      fontz: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
