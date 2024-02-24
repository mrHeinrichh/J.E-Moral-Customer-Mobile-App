import 'package:carousel_slider/carousel_slider.dart';
import 'package:customer_app/routes/app_routes.dart';
import 'package:customer_app/view/product_details.page.dart';
import 'package:customer_app/widgets/custom_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> sampleData = [];
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> announcements = [];
  bool initialSectionShown = false;

  @override
  void initState() {
    super.initState();
    fetchDataFromAPI();
    fetchAnnouncements();
  }

  Future<void> fetchAnnouncements() async {
    final url =
        Uri.parse('https://lpg-api-06n8.onrender.com/api/v1/announcements/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final parsedData = json.decode(response.body);
      final data = parsedData['data'];

      if (mounted) {
        setState(() {
          announcements = List<Map<String, dynamic>>.from(data);
        });
      }
    }
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
            'id': item['_id'] ?? 'ID Not Available',
            'name': item['name'] ?? 'Name Not Available',
            'price': (item['customerPrice'] ?? 0.0).toString(),
            'imageUrl': item['image'] ?? 'Image URL Not Available',
            'description': item['description'] ?? 'Description Not Available',
            'weight': (item['weight'] ?? 0).toString(),
            'stock': (item['stock'] ?? 0).toString(),
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
    final url = Uri.parse(
        'https://lpg-api-06n8.onrender.com/api/v1/items/?&page=1&limit=300');
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
            '_id': item['_id'] ?? 'ID Not Available',
            'name': item['name'] ?? 'Name Not Available',
            'price': (item['customerPrice'] ?? 0.0).toString(),
            'imageUrl': item['image'] ?? 'Image URL Not Available',
            'description': item['description'] ?? 'Description Not Available',
            'weight': (item['weight'] ?? 0).toString(),
            'stock': (item['stock'] ?? 0).toString(),
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

  bool fullscreenImageVisible = false;
  String fullscreenImageUrl = '';

  Future<void> _refresh() async {
    await fetchDataFromAPI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Stack(
          children: [
            Column(
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
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.search,
                                        color: Color(0xFF232937),
                                      ),
                                      Expanded(
                                        child: TextField(
                                          controller: _searchController,
                                          onChanged: (text) {
                                            searchItems();
                                          },
                                          decoration: const InputDecoration(
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
                SizedBox(
                  child: CarouselSlider.builder(
                    itemCount: announcements.length + 1,
                    itemBuilder:
                        (BuildContext context, int index, int realIndex) {
                      if (index == 0) {
                        return SizedBox(
                          child: Center(
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              color: Colors.white,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Fueling Your Life with Clean Energy',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 26,
                                      color: const Color(0xFF050404)
                                          .withOpacity(0.8),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    'Applying for a Delivery Driver?',
                                    style: TextStyle(
                                      color: const Color(0xFF050404)
                                          .withOpacity(0.8),
                                      fontSize: 12,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 5),
                                  AppointmentButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, appointmentRoute);
                                    },
                                    text: 'Book an Appointment',
                                    height: 30,
                                    width: 210,
                                    fontz: 12,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        final announcement = announcements[index - 1];

                        return InkWell(
                          onTap: () {
                            setState(() {
                              fullscreenImageVisible = true;
                              fullscreenImageUrl = announcement['image'];
                            });
                          },
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: NetworkImage(announcement['image']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                    options: CarouselOptions(
                      height: 190,
                      enableInfiniteScroll: true,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      onPageChanged: (index, _) {
                        setState(() {
                          initialSectionShown = true;
                        });
                      },
                    ),
                  ),
                ),
                if (!initialSectionShown)
                  Visibility(
                    visible: initialSectionShown,
                    child: Expanded(
                      child: ListView.builder(
                        itemCount: sampleData.length,
                        itemBuilder: (context, categoryIndex) {
                          // ... Your existing category and product UI
                        },
                      ),
                    ),
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
                                        builder: (context) =>
                                            ProductDetailsPage(
                                          productName: product['name'] ??
                                              'Name Not Available',
                                          productPrice: product['price'] ??
                                              'Price Not Available',
                                          showProductPrice:
                                              product['showPrice'] ??
                                                  'Price Not Available',
                                          productImageUrl:
                                              product['imageUrl'] ??
                                                  'Image URL Not Available',
                                          category: category ??
                                              'Category Not Available',
                                          description: product['description'] ??
                                              'Description Not Available',
                                          weight: product['weight'] ??
                                              'Weight Not Available',
                                          stock: product['stock'] ??
                                              'Stock Not Available',
                                          availableStock:
                                              product['availableStock'] ??
                                                  'Stock Not Available',
                                          id: product['_id'] ??
                                              'ID Not Available',
                                        ),
                                      ),
                                    );
                                  },
                                  child: SizedBox(
                                    width: 130,
                                    child: Column(
                                      children: [
                                        Card(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                8.0), // You can adjust the value as needed
                                            child: Image.network(
                                              product['imageUrl'],
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          title: Text(
                                            product['name'],
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Color(0xFF232937),
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          subtitle: Text(
                                            '\₱${NumberFormat("#,##0.00", "en_US").format(double.parse(product['price']))}',
                                            style: const TextStyle(
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
            ),
            if (fullscreenImageVisible)
              FullScreenImageView(
                imageUrl: fullscreenImageUrl,
                onClose: () {
                  setState(() {
                    fullscreenImageVisible = false;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }
}

class FullScreenImageView extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onClose;

  FullScreenImageView({required this.imageUrl, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.black,
            child: Center(
              child: PhotoView(
                imageProvider: NetworkImage(imageUrl),
                backgroundDecoration: const BoxDecoration(
                  color: Colors.black,
                ),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
              ),
            ),
          ),
          Positioned(
            top: 30,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: onClose,
            ),
          ),
        ],
      ),
    );
  }
}
