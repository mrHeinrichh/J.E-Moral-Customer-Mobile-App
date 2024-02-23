import 'package:flutter/material.dart';
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
  });

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int stock = 0;

  @override
  void initState() {
    super.initState();
    if (int.parse(widget.stock) <= 0) {
      stock = 0;
    } else {
      stock = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    final titleText = widget.category;

    final totalPrice = double.parse(widget.productPrice) * stock;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFd41111).withOpacity(0.8),
        title: Text(
          titleText,
          style: const TextStyle(
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
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
                    width: double.infinity,
                    height: 320,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  widget.productName,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Description:",
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                widget.description,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.start,
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
      ),
      bottomNavigationBar: SizedBox(
        height: 170,
        child: BottomAppBar(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Stock Available: ",
                          style: TextStyle(
                            color: const Color(0xFF050404).withOpacity(0.8),
                          ),
                        ),
                        Text(
                          widget.stock,
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
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Price: ",
                        style: TextStyle(
                          fontSize: 18,
                          color: const Color(0xFF050404).withOpacity(0.8),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: totalPrice % 1 == 0
                            ? '₱${totalPrice.toInt().toString()}'
                            : '₱${totalPrice.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match match) => '${match[1]},')}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xFFd41111),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                CartButton(
                  onPressed: stock > 0
                      ? () {
                          if (stock > 0) {
                            cartProvider.addToCart(
                              cartItem: CartItem(
                                id: widget.productName.hashCode,
                                name: widget.productName,
                                description: widget.description,
                                category: widget.category,
                                customerPrice:
                                    double.parse(widget.productPrice),
                                stock: stock,
                                imageUrl: widget.productImageUrl,
                                availableStock: int.parse(widget.stock),
                              ),
                              context: context,
                            );
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
