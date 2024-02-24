import 'package:flutter/material.dart';
import 'package:customer_app/routes/app_routes.dart';
import 'package:customer_app/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';

class ProductDetailsPage extends StatefulWidget {
  String productName;
  String productPrice;
  String showProductPrice;
  String productImageUrl;
  String category;
  String description;
  String weight;
  String stock;
  String availableStock;
  String id;

  ProductDetailsPage({
    required this.productName,
    required this.productPrice,
    required this.showProductPrice,
    required this.productImageUrl,
    required this.category,
    required this.description,
    required this.weight,
    required this.stock,
    required this.availableStock,
    required this.id,
  });
  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int stock = 1; // Initial stock

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    final titleText = "${widget.category}";

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          titleText,
          style: const TextStyle(color: Color(0xFF232937), fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Image.network(
                    widget.productImageUrl,
                    width: 320,
                    height: 320,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${widget.productName}",
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          // decoration: TextDecoration.underline,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Description:",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Text(
                          "${widget.description}",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (widget.category != "Accessories")
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Weight:",
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Text(
                            "${widget.weight} kg.",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 170,
        child: BottomAppBar(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text("Stock Available:"),
                        Text(
                          " ${widget.stock}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey, width: 0.50),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.remove, size: 15),
                            onPressed: () {
                              setState(() {
                                if (stock > 1) {
                                  stock--;
                                }
                              });
                            },
                          ),
                        ),
                        Text(
                          "$stock",
                          style: const TextStyle(
                            fontSize: 18,
                            color: Color(0xFF232937),
                          ),
                        ),
                        Container(
                          height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey,
                              width: 0.50,
                            ),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.add,
                              size: 15,
                            ),
                            onPressed: () {
                              setState(() {
                                stock++;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  "Price: ₱${((double.tryParse(widget.productPrice) ?? 0) * stock).toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xFF232937),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CustomizedButton(
                  onPressed: () {
                    // Check if the desired quantity exceeds the available stock
                    if (stock <= int.parse(widget.stock)) {
                      cartProvider.addToCart(
                        cartItem: CartItem(
                          id: widget.id,
                          name: widget.productName,
                          description: widget.description,
                          category: widget.category,
                          customerPrice: double.parse(widget.productPrice),
                          stock: stock,
                          imageUrl: widget.productImageUrl,
                          availableStock: int.parse(widget.stock),
                        ),
                        context: context,
                      );
                      Navigator.pushNamed(context, cartRoute);
                    } else {
                      // Show an error message or perform any other action when the quantity exceeds the available stock
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Invalid Quantity'),
                            content: Text(
                                'The chosen quantity exceeds the available stock for this product.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  text: 'Add to Cart',
                  height: 50,
                  width: 220,
                  fontz: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
