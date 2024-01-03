import 'package:customer_app/routes/app_routes.dart';
import 'package:customer_app/view/product_details.page.dart';
import 'package:customer_app/widgets/custom_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
// ... Import statements remain unchanged

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> sampleData = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDataFromAPI();
  }

  void searchItems() async {
    final searchTerm = _searchController.text;
    final url = Uri.parse(
        'https://lpg-api-06n8.onrender.com/api/v1/items/?search=$searchTerm');
    final response = await http.get(url);
    if (!mounted) {
      return; // Check if the widget is still in the tree
    }

    if (response.statusCode == 200) {
      final parsedData = json.decode(response.body);
      final data = parsedData['data'];

      setState(() {
        final Map<String, List<Map<String, dynamic>>> groupedData = {};

        data.forEach((item) {
          final category = item['category'];
          final product = {
            'name': item['name'] ?? 'Name Not Available',
            'price': (item['customerPrice'] ?? 0.0).toString(),
            'imageUrl': item['image'] ?? 'Image URL Not Available',
            'description': item['description'] ?? 'Description Not Available',
            'weight': (item['weight'] ?? 0).toString(),
            'quantity': (item['quantity'] ?? 0).toString(),
          };

          if (groupedData.containsKey(category)) {
            groupedData[category]!.add(product);
          } else {
            groupedData[category] = [product];
          }
        });

        sampleData = groupedData.entries
            .map((entry) => {
                  'category': entry.key,
                  'products': entry.value,
                })
            .toList();
      });
    }
  }

  Future<void> fetchDataFromAPI() async {
    final url = Uri.parse('https://lpg-api-06n8.onrender.com/api/v1/items');
    final response = await http.get(url);
    if (!mounted) {
      return; // Check if the widget is still in the tree
    }

    if (response.statusCode == 200) {
      final parsedData = json.decode(response.body);
      final data = parsedData['data'];

      setState(() {
        final Map<String, List<Map<String, dynamic>>> groupedData = {};

        data.forEach((item) {
          final category = item['category'];
          final product = {
            'name': item['name'] ?? 'Name Not Available',
            'price': (item['customerPrice'] ?? 0.0).toString(),
            'imageUrl': item['image'] ?? 'Image URL Not Available',
            'description': item['description'] ?? 'Description Not Available',
            'weight': (item['weight'] ?? 0).toString(),
            'quantity': (item['quantity'] ?? 0).toString(),
          };

          if (groupedData.containsKey(category)) {
            groupedData[category]!.add(product);
          } else {
            groupedData[category] = [product];
          }
        });

        sampleData = groupedData.entries
            .map((entry) => {
                  'category': entry.key,
                  'products': entry.value,
                })
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 100,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35.0),
            child: Row(
              children: [
                Expanded(
                  child: Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(10.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search,
                                color: Color(0xFF232937),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  onChanged: (text) {
                                    searchItems();
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Search',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: IconButton(
                      icon: const Icon(
                        FontAwesomeIcons.cartShopping,
                        color: Color(0xFF232937),
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, cartRoute);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Text(
          'Fueling Your Life\nwith Clean Energy',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Color(0xFF232937),
          ),
        ),
        const Text('Applying for a Rider?'),
        CustomizedButton(
          onPressed: () {
            Navigator.pushNamed(context, appointmentRoute);
          },
          text: 'Book an Appointment',
          height: 40,
          width: 330,
          fontz: 15,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: sampleData.length,
            itemBuilder: (context, categoryIndex) {
              final category = sampleData[categoryIndex]['category'];
              final products = sampleData[categoryIndex]['products'];

              return Column(
                children: [
                  ListTile(
                    title: Text(
                      category,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xFF232937),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: products.length,
                      itemBuilder: (context, productIndex) {
                        final product = products[productIndex];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailsPage(
                                  productName:
                                      product['name'] ?? 'Name Not Available',
                                  productPrice:
                                      product['price'] ?? 'Price Not Available',
                                  productImageUrl: product['imageUrl'] ??
                                      'Image URL Not Available',
                                  category:
                                      category ?? 'Category Not Available',
                                  description: product['description'] ??
                                      'Description Not Available',
                                  weight: product['weight'] ??
                                      'Weight Not Available',
                                  quantity: product['quantity'] ??
                                      'Quantity Not Available',
                                ),
                              ),
                            );
                          },
                          child: SizedBox(
                            width: 130,
                            child: Column(
                              children: [
                                Card(
                                  child: Column(
                                    children: [
                                      Image.network(
                                        product['imageUrl'],
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ],
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    product['name'],
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF232937),
                                    ),
                                  ),
                                  subtitle: Text(
                                    '\₱${product['price']}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFFE98500),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
