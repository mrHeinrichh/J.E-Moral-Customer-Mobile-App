import 'package:carousel_slider/carousel_slider.dart';
import 'package:customer_app/routes/app_routes.dart';
import 'package:customer_app/view/product_details.page.dart';
import 'package:customer_app/widgets/custom_button.dart';
import 'package:customer_app/widgets/fullscreen_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> itemsData = [];
  List<Map<String, dynamic>> announcements = [];
  TextEditingController searchController = TextEditingController();
  bool initialSectionShown = false;
  bool isDataFetching = true;

  @override
  void initState() {
    super.initState();
    fetchDataFromAPI();
    fetchAnnouncements();
    Future.wait([fetchDataFromAPI(), fetchAnnouncements()]).then((_) {
      setState(() {
        isDataFetching = false;
      });
    });
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
    final searchTerm = searchController.text;
    final url = Uri.parse(
        'https://lpg-api-06n8.onrender.com/api/v1/items/?search=$searchTerm');
    final response = await http.get(url);
    if (!mounted) {
      return;
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
            'price': (item['customerPrice'] ?? 0).toString(),
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

        itemsData = groupedData.entries
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
      return;
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
            'price': (item['customerPrice'] ?? 0).toString(),
            'showPrice': NumberFormat.decimalPattern().format(
                double.parse((item['customerPrice'] ?? 0).toStringAsFixed(2))),
            'imageUrl': item['image'] ?? 'Image URL Not Available',
            'description': item['description'] ?? 'Description Not Available',
            'weight': (item['weight'] ?? 0).toString(),
            'stock': (item['stock'] ?? 0).toString(),
            'availableStock': (item['stock'] ?? 0).toString(),
          };

          if (groupedData.containsKey(category)) {
            groupedData[category]!.add(product);
          } else {
            groupedData[category] = [product];
          }
        });

        itemsData = groupedData.entries
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
    await fetchAnnouncements();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: RefreshIndicator(
          onRefresh: _refresh,
          color: const Color(0xFF050404),
          strokeWidth: 2.5,
          child: Stack(
            children: [
              if (isDataFetching)
                Center(
                  child: LoadingAnimationWidget.flickr(
                    leftDotColor: const Color(0xFF050404).withOpacity(0.8),
                    rightDotColor: const Color(0xFFd41111).withOpacity(0.8),
                    size: 40,
                  ),
                ),
              if (!isDataFetching)
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 100,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 45,
                                  child: Material(
                                    elevation: 5,
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 14),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: TextField(
                                                  controller: searchController,
                                                  cursorColor:
                                                      const Color(0xFF050404),
                                                  onChanged: (text) {
                                                    searchItems();
                                                  },
                                                  decoration: InputDecoration(
                                                    hintText: 'Search',
                                                    border: InputBorder.none,
                                                    hintStyle: TextStyle(
                                                      color: const Color(
                                                              0xFF050404)
                                                          .withOpacity(0.5),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              const Icon(
                                                Icons.search,
                                                color: Color(0xFF050404),
                                              ),
                                            ],
                                          ),
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
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 4),
                                    child: IconButton(
                                      icon: Icon(
                                        FontAwesomeIcons.cartShopping,
                                        color: const Color(0xFF050404)
                                            .withOpacity(0.8),
                                        size: 23,
                                      ),
                                      onPressed: () {
                                        Navigator.pushNamed(context, cartRoute);
                                      },
                                    ),
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
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    color: Colors.white,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        image:
                                            NetworkImage(announcement['image']),
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
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: itemsData.length,
                        itemBuilder: (context, categoryIndex) {
                          final category = itemsData[categoryIndex]['category'];
                          final products = itemsData[categoryIndex]['products'];

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  title: Text(
                                    category,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: const Color(0xFF050404)
                                          .withOpacity(0.8),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  // height: 200,
                                  height: 180,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: products.length,
                                    itemBuilder: (context, productIndex) {
                                      final product = products[productIndex];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductDetailsPage(
                                                  productName:
                                                      product['name'] ??
                                                          'Name Not Available',
                                                  productPrice:
                                                      product['price'] ??
                                                          'Price Not Available',
                                                  showProductPrice:
                                                      product['showPrice'] ??
                                                          'Price Not Available',
                                                  productImageUrl: product[
                                                          'imageUrl'] ??
                                                      'Image URL Not Available',
                                                  category: category ??
                                                      'Category Not Available',
                                                  description: product[
                                                          'description'] ??
                                                      'Description Not Available',
                                                  weight: product['weight'] ??
                                                      'Weight Not Available',
                                                  stock: product['stock'] ??
                                                      'Stock Not Available',
                                                  availableStock: product[
                                                          'availableStock'] ??
                                                      'Stock Not Available',
                                                  id: product['_id'] ??
                                                      'ID Not Available',
                                                ),
                                              ),
                                            );
                                          },
                                          child: SizedBox(
                                            // width: 165,
                                            width: 130,
                                            // child: Card(
                                            //   elevation: 2,
                                            //   shape: RoundedRectangleBorder(
                                            //     borderRadius:
                                            //         BorderRadius.circular(12),
                                            //     side: BorderSide(
                                            //       color: const Color(0xFF050404)
                                            //           .withOpacity(0.8),
                                            //       width: 0.1,
                                            //     ),
                                            //   ),
                                            //   child: Column(
                                            //     crossAxisAlignment:
                                            //         CrossAxisAlignment.start,
                                            //     children: [
                                            //       ClipRRect(
                                            //         borderRadius:
                                            //             const BorderRadius.only(
                                            //           topLeft:
                                            //               Radius.circular(12),
                                            //           topRight:
                                            //               Radius.circular(12),
                                            //         ),
                                            //         child: Image.network(
                                            //           product['imageUrl'],
                                            //           width: double.infinity,
                                            //           height: 100,
                                            //           fit: BoxFit.cover,
                                            //         ),
                                            //       ),
                                            //       const SizedBox(height: 10),
                                            //       Padding(
                                            //         padding: const EdgeInsets
                                            //             .symmetric(
                                            //             horizontal: 8.0),
                                            //         child: Column(
                                            //           crossAxisAlignment:
                                            //               CrossAxisAlignment
                                            //                   .start,
                                            //           children: [
                                            //             Text(
                                            //               product['name'],
                                            //               style: TextStyle(
                                            //                 fontSize: 14,
                                            //                 color: const Color(
                                            //                         0xFF050404)
                                            //                     .withOpacity(
                                            //                         0.8),
                                            //                 fontWeight:
                                            //                     FontWeight.bold,
                                            //               ),
                                            //               overflow: TextOverflow
                                            //                   .ellipsis,
                                            //             ),
                                            //             const SizedBox(
                                            //                 height: 7),
                                            //             Text(
                                            //               product[
                                            //                   'description'],
                                            //               style: TextStyle(
                                            //                 fontSize: 11,
                                            //                 color: const Color(
                                            //                         0xFF050404)
                                            //                     .withOpacity(
                                            //                         0.8),
                                            //               ),
                                            //               maxLines: 1,
                                            //               overflow: TextOverflow
                                            //                   .ellipsis,
                                            //             ),
                                            //             const SizedBox(
                                            //                 height: 9),
                                            //             Row(
                                            //               mainAxisAlignment:
                                            //                   MainAxisAlignment
                                            //                       .spaceBetween,
                                            //               children: [
                                            //                 Text(
                                            //                   '₱${product['showPrice']}',
                                            //                   style:
                                            //                       const TextStyle(
                                            //                     fontSize: 16,
                                            //                     color: Color(
                                            //                         0xFFd41111),
                                            //                     fontWeight:
                                            //                         FontWeight
                                            //                             .bold,
                                            //                   ),
                                            //                 ),
                                            //                 Text.rich(
                                            //                   TextSpan(
                                            //                     children: [
                                            //                       TextSpan(
                                            //                         text:
                                            //                             'Stock: ',
                                            //                         style:
                                            //                             TextStyle(
                                            //                           fontSize:
                                            //                               13,
                                            //                           color: const Color(
                                            //                                   0xFF050404)
                                            //                               .withOpacity(
                                            //                                   0.8),
                                            //                         ),
                                            //                       ),
                                            //                       TextSpan(
                                            //                         text: product[
                                            //                             'stock'],
                                            //                         style:
                                            //                             TextStyle(
                                            //                           fontSize:
                                            //                               13,
                                            //                           fontWeight:
                                            //                               FontWeight
                                            //                                   .bold,
                                            //                           color: const Color(
                                            //                                   0xFF050404)
                                            //                               .withOpacity(
                                            //                                   0.8),
                                            //                         ),
                                            //                       ),
                                            //                     ],
                                            //                   ),
                                            //                 ),
                                            //               ],
                                            //             ),
                                            //           ],
                                            //         ),
                                            //       ),
                                            //     ],
                                            //   ),
                                            // ),
                                            child: Column(
                                              children: [
                                                Card(
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
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
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  subtitle: Text(
                                                    '₱${product['showPrice']}',
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: const Color(
                                                              0xFFd41111)
                                                          .withOpacity(0.8),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
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
      ),
    );
  }
}
