import 'package:customer_app/routes/app_routes.dart';
import 'package:customer_app/widgets/custom_button.dart';
import 'package:customer_app/widgets/fullscreen_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

  @override
  void initState() {
    super.initState();
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
          if (visibleTransactions.length > 300) {
            visibleTransactions = visibleTransactions.sublist(0, 300);
          }
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

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
      ),
      body: RefreshIndicator(
        onRefresh: refreshData,
        color: const Color(0xFF050404),
        strokeWidth: 2.5,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            children: [
              const SizedBox(height: 10),
              CustomButton(
                backgroundColor: const Color(0xFF050404).withOpacity(0.9),
                onPressed: () {
                  Navigator.pushNamed(context, myOrdersPage);
                },
                text: 'View Pending Orders',
              ),
              const SizedBox(height: 10),
              for (int i = 0; i < completedTransactions.length; i++)
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
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
                                              fontWeight: FontWeight.bold),
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
                                                      completedTransactions[i]
                                                          ['discountIdImage'],
                                                  onClose: () {
                                                    Navigator.pop(context);
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
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: const Color(0xFF050404)
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
                                              fontWeight: FontWeight.bold),
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
                                                      completedTransactions[i]
                                                          ['pickupImages'],
                                                  onClose: () {
                                                    Navigator.pop(context);
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
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: const Color(0xFF050404)
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
                                              fontWeight: FontWeight.bold),
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
                                                      completedTransactions[i]
                                                          ['completionImages'],
                                                  onClose: () {
                                                    Navigator.pop(context);
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
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: const Color(0xFF050404)
                                                    .withOpacity(0.9),
                                                width: 1,
                                              ),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  completedTransactions[i]
                                                      ['completionImages'],
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
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ListTile(
                          subtitle: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Order #${completedTransactions.length - i}: ${completedTransactions[i]['_id']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Divider(),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: "Receiver Name: ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            '${completedTransactions[i]['name']}',
                                      ),
                                    ],
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: "Receiver Contact Number: ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            '${completedTransactions[i]['contactNumber']}',
                                      ),
                                    ],
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: "Pin Location: ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            '${completedTransactions[i]['deliveryLocation']}',
                                      ),
                                    ],
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: "Receiver House#/Lot/Blk: ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            '${completedTransactions[i]['houseLotBlk']}',
                                      ),
                                    ],
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: "Barangay: ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            '${completedTransactions[i]['barangay']}',
                                      ),
                                    ],
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: "Payment Method: ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            '${completedTransactions[i]['paymentMethod']}',
                                      ),
                                    ],
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: 'Assemble Option: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: completedTransactions[i]
                                                ['assembly']
                                            ? 'Yes'
                                            : 'No',
                                      ),
                                    ],
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: 'Discounted: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: completedTransactions[i]
                                                    ['discountIdImage'] !=
                                                null
                                            ? 'Yes'
                                            : 'No',
                                      ),
                                    ],
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: 'Delivery Date/Time: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: completedTransactions[i]
                                                    ['updatedAt'] !=
                                                null
                                            ? DateFormat('MMMM d, y - h:mm a')
                                                .format(
                                                DateTime.parse(
                                                    completedTransactions[i]
                                                        ['updatedAt']),
                                              )
                                            : 'null',
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: "Items: ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (completedTransactions[i]['items'] !=
                                          null)
                                        TextSpan(
                                          text: (completedTransactions[i]
                                                  ['items'] as List)
                                              .map((item) {
                                            if (item is Map<String, dynamic> &&
                                                item.containsKey('name') &&
                                                item.containsKey('quantity')) {
                                              return '${item['name']} (${item['quantity']})';
                                            }
                                            return '';
                                          }).join(', '),
                                        ),
                                    ],
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: "Total Price: ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            "₱${completedTransactions[i]['total'] % 1 == 0 ? NumberFormat('#,##0').format(completedTransactions[i]['total'].toInt()) : NumberFormat('#,##0.00').format(completedTransactions[i]['total']).replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "")}",
                                      ),
                                    ],
                                  ),
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
