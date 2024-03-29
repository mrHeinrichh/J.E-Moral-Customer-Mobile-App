import 'package:customer_app/routes/app_routes.dart';
import 'package:customer_app/widgets/custom_button.dart';
import 'package:customer_app/widgets/custom_text.dart';
import 'package:customer_app/widgets/fullscreen_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> visibleTransactions = [];
  bool loadingData = false;

  double calculateSavedAmount(
      int index, List<Map<String, dynamic>> transactions) {
    final total = transactions[index]['total'] ?? 0.0;
    return total * 0.25;
  }

  @override
  void initState() {
    super.initState();
    loadingData = true;
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.userId;

    if (userId == null) {
      return;
    }

    final apiUrl = 'https://lpg-api-06n8.onrender.com/api/v1/transactions';
    final filterUrl = '$apiUrl/?filter={"to":"$userId", "__t" : "Delivery"} ';

    final response = await http.get(Uri.parse(filterUrl));
    if (!mounted) {
      return;
    }

    if (response.statusCode == 200) {
      final Map<String, dynamic>? data = jsonDecode(response.body);
      print(response.body);

      if (data != null && data['status'] == 'success') {
        final List<dynamic> transactionsData = data['data'] ?? [];

        setState(() {
          visibleTransactions.clear();
          visibleTransactions
              .addAll(transactionsData.cast<Map<String, dynamic>>());
          visibleTransactions.sort((a, b) => DateTime.parse(b['updatedAt'])
              .compareTo(DateTime.parse(a['updatedAt'])));

          // Limit
          if (visibleTransactions.length > 500) {
            visibleTransactions = visibleTransactions.sublist(0, 500);
          }

          loadingData = false;
        });
      } else {}
    } else {}
  }

  Future<void> refreshData() async {
    await fetchTransactions();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> completedTransactions = visibleTransactions
        .where((transaction) =>
            transaction['completed'] == true &&
            transaction['status'] == "Completed" &&
            transaction['hasFeedback'] == true)
        .toList();
    double savedAmount = 0.0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'Transaction History',
          style: TextStyle(
            color: const Color(0xFF050404).withOpacity(0.9),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: const Color(0xFF050404).withOpacity(0.8),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.black,
            height: 0.2,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, dashboardRoute, arguments: 1);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: loadingData
          ? Center(
              child: LoadingAnimationWidget.flickr(
                leftDotColor: const Color(0xFF050404).withOpacity(0.8),
                rightDotColor: const Color(0xFFd41111).withOpacity(0.8),
                size: 40,
              ),
            )
          : RefreshIndicator(
              onRefresh: refreshData,
              color: const Color(0xFF050404),
              strokeWidth: 2.5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView(
                  children: [
                    const SizedBox(height: 10),
                    for (int i = 0; i < completedTransactions.length; i++)
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                content: SingleChildScrollView(
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (completedTransactions[i]
                                                    ['discountIdImage'] !=
                                                null &&
                                            completedTransactions[i]
                                                    ['discountIdImage'] !=
                                                "")
                                          Column(
                                            children: [
                                              const Text(
                                                'Discount Id Image',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(height: 5),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          FullScreenImageView(
                                                        imageUrl:
                                                            completedTransactions[
                                                                    i][
                                                                'discountIdImage'],
                                                        onClose: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  width: double.infinity,
                                                  height: 150,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                      color: const Color(
                                                              0xFF050404)
                                                          .withOpacity(0.9),
                                                      width: 1,
                                                    ),
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                        completedTransactions[i]
                                                            ['discountIdImage'],
                                                      ),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                            ],
                                          ),
                                        if (completedTransactions[i]
                                                    ['pickupImages'] !=
                                                null &&
                                            completedTransactions[i]
                                                    ['pickupImages'] !=
                                                "")
                                          Column(
                                            children: [
                                              const Text(
                                                'Pick-up Image',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(height: 5),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          FullScreenImageView(
                                                        imageUrl:
                                                            completedTransactions[
                                                                    i][
                                                                'pickupImages'],
                                                        onClose: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  width: double.infinity,
                                                  height: 150,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                      color: const Color(
                                                              0xFF050404)
                                                          .withOpacity(0.9),
                                                      width: 1,
                                                    ),
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                        completedTransactions[i]
                                                            ['pickupImages'],
                                                      ),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                            ],
                                          ),
                                        if (completedTransactions[i]
                                                    ['completionImages'] !=
                                                null &&
                                            completedTransactions[i]
                                                    ['completionImages'] !=
                                                "")
                                          Column(
                                            children: [
                                              const Text(
                                                'Drop-off Image',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(height: 5),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          FullScreenImageView(
                                                        imageUrl:
                                                            completedTransactions[
                                                                    i][
                                                                'completionImages'],
                                                        onClose: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  width: double.infinity,
                                                  height: 150,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                      color: const Color(
                                                              0xFF050404)
                                                          .withOpacity(0.9),
                                                      width: 1,
                                                    ),
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                        completedTransactions[i]
                                                            [
                                                            'completionImages'],
                                                      ),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Column(
                          children: [
                            Card(
                              color: Colors.white,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ListTile(
                                subtitle: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Column(
                                          children: [
                                            const BodyMedium(
                                              text: 'Transaction ID',
                                            ),
                                            BodyMedium(
                                              text:
                                                  '${completedTransactions[i]['_id']}',
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Divider(),
                                      const Center(
                                        child: BodyMedium(
                                          text: 'Receiver Information:',
                                        ),
                                      ),
                                      BodyMediumText(
                                        text:
                                            'Name: ${completedTransactions[i]['name']}',
                                      ),
                                      BodyMediumText(
                                        text:
                                            'Mobile Number: ${completedTransactions[i]['contactNumber']}',
                                      ),
                                      BodyMediumOver(
                                        text:
                                            'House Number: ${completedTransactions[i]['houseLotBlk']}',
                                      ),
                                      BodyMediumText(
                                        text:
                                            'Barangay: ${completedTransactions[i]['barangay']}',
                                      ),
                                      BodyMediumOver(
                                        text:
                                            'Delivery Location: ${completedTransactions[i]['deliveryLocation']}',
                                      ),
                                      const Divider(),
                                      BodyMediumText(
                                        text:
                                            'Payment Method: ${completedTransactions[i]['paymentMethod']}',
                                      ),
                                      BodyMediumText(
                                        text:
                                            'Assemble Option: ${completedTransactions[i]['assembly'] ? 'Yes' : 'No'}',
                                      ),
                                      BodyMediumOver(
                                        text:
                                            'Delivery Date and Time: ${DateFormat('MMMM d, y - h:mm a').format(DateTime.parse(completedTransactions[i]['deliveryDate']))}',
                                      ),
                                      BodyMediumText(
                                        text:
                                            'Discounted: ${completedTransactions[i]['discountIdImage'] != null ? 'Yes' : 'No'}',
                                      ),
                                      const Divider(),
                                      BodyMediumOver(
                                        text:
                                            'Items: ${completedTransactions[i]['items']!.map((item) {
                                          if (item is Map<String, dynamic> &&
                                              item.containsKey('name') &&
                                              item.containsKey('quantity') &&
                                              item.containsKey(
                                                  'customerPrice')) {
                                            final itemName = item['name'];
                                            final quantity = item['quantity'];
                                            final price =
                                                NumberFormat.decimalPattern()
                                                    .format(double.parse(
                                                        (item['customerPrice'])
                                                            .toStringAsFixed(
                                                                2)));

                                            return '$itemName ₱$price (x$quantity)';
                                          }
                                        }).join(', ')}',
                                      ),
                                      // Display saved amount

                                      BodyMediumText(
                                        text:
                                            'Saved Amount: ₱${calculateSavedAmount(i, completedTransactions).toStringAsFixed(2)}',
                                      ),
                                      BodyMediumText(
                                        text:
                                            'Total Price: ₱${completedTransactions[i]['total'] % 1 == 0 ? NumberFormat('#,##0').format(completedTransactions[i]['total'].toInt()) : NumberFormat('#,##0.00').format(completedTransactions[i]['total']).replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "")}',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
