import 'package:flutter/material.dart';
import 'package:customer_app/routes/app_routes.dart';
import 'package:customer_app/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';

class ProductDetailsPage extends StatefulWidget {
  String productName;
  String productPrice;
  String productImageUrl;
  String category;
  String description;
  String weight;
  String stock;

  ProductDetailsPage({
    required this.productName,
    required this.productPrice,
    required this.productImageUrl,
    required this.category,
    required this.description, // Added description
    required this.weight, // Added weight
    required this.stock, // Added stock
  });

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int stock = 0; // Initial stock

  @override
  void initState() {
    super.initState();
    // Set stock based on the available stock of the product
    if (int.parse(widget.stock) <= 0) {
      stock = 0;
    } else {
      stock = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    final titleText = "${widget.category}";

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFd41111).withOpacity(0.4),
        title: Text(
          titleText,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF050404).withOpacity(0.8),
          ),
        ),
        centerTitle: true,
        iconTheme:
            IconThemeData(color: const Color(0xFF050404).withOpacity(0.8)),
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
                  Container(
                    width: 320,
                    height: 320,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF050404),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        widget.productImageUrl,
                        width: 320,
                        height: 320,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${widget.productName}",
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          fontWeight: FontWeight.bold,
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
          color: const Color(0xFFd41111).withOpacity(0.4),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Stock Available:",
                          style: TextStyle(
                            color: const Color(0xFF050404).withOpacity(0.8),
                          ),
                        ),
                        Text(
                          " ${widget.stock}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF050404).withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          height: 30,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
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
                            color: const Color(0xFF050404).withOpacity(0.8),
                          ),
                        ),
                        Text(
                          "$stock",
                          style: TextStyle(
                            fontSize: 18,
                            color: const Color(0xFF050404).withOpacity(0.8),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          height: 30,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.add,
                              size: 15,
                            ),
                            onPressed: () {
                              setState(() {
                                if (stock < int.parse(widget.stock)) {
                                  stock++;
                                }
                              });
                            },
                            color: const Color(0xFF050404).withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  "Price: ₱${((double.tryParse(widget.productPrice) ?? 0) * stock).toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 18,
                    color: const Color(0xFF050404).withOpacity(0.8),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AddtoCart(
                  onPressed: stock > 0
                      ? () {
                          if (stock > 0) {
                            cartProvider.addToCart(
                              CartItem(
                                id: widget.productName.hashCode,
                                name: widget.productName,
                                customerPrice:
                                    double.parse(widget.productPrice),
                                stock: stock,
                                imageUrl: widget.productImageUrl,
                              ),
                            );
                            Navigator.pushNamed(context, cartRoute);
                          }
                        }
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Product is out of stock.'),
                              duration: Duration(seconds: 2),
                              backgroundColor: Colors.red,
                            ),
                          );
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
