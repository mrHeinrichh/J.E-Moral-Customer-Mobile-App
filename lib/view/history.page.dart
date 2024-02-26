import 'package:customer_app/routes/app_routes.dart';
import 'package:customer_app/widgets/custom_button.dart';
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

//Search transaction id is used in customer history page to search the transaction made by the userid
  Future<void> fetchTransactions() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.userId;

    if (userId == null) {
      // Handle the case where userId is null
      return;
    }

    final apiUrl = 'https://lpg-api-06n8.onrender.com/api/v1/transactions';
    final filterUrl =
        '$apiUrl/?filter={"to":"$userId", "__t" : "Delivery"}&limit=900'; // Added limit parameter

    final response = await http.get(Uri.parse(filterUrl));
    if (!mounted) {
      return; // Check if the widget is still in the tree
    }

    if (response.statusCode == 200) {
      final Map<String, dynamic>? data = jsonDecode(response.body);
      print(response.body);

      if (data != null && data['status'] == 'success') {
        final List<dynamic> transactionsData = data['data'] ?? [];

        setState(() {
          visibleTransactions = transactionsData.cast<Map<String, dynamic>>();
          // Sort transactions based on 'updatedAt' in descending order
          visibleTransactions.sort((a, b) => DateTime.parse(b['updatedAt'])
              .compareTo(DateTime.parse(a['updatedAt'])));
        });
      } else {
        // Handle unexpected data format or other API errors
      }
    } else {
      // Handle HTTP error
    }
  }

  Future<void> refreshData() async {
    await fetchTransactions();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> completedTransactions = visibleTransactions
        .where((transaction) =>
            transaction['completed'] == true &&
            transaction['status'] == "Completed")
        .toList();

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
        automaticallyImplyLeading: false,
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              // Text("View Current Orders Here!"),
              SizedBox(
                height: 0,
              ),
              CustomButton(
                backgroundColor: Color(0xFF232937),
                onPressed: () {
                  Navigator.pushNamed(context, myOrdersPage);
                },
                text: 'View Pending Orders',
              ),
              Divider(),

              for (int i = 0; i < completedTransactions.length; i++)
                Card(
                  elevation: 10, // Increase the elevation
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15.0), // Add border radius
                  ),
                  child: ListTile(
                    subtitle: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order #${completedTransactions.length - i}: ${completedTransactions[i]['_id']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Divider(
                            color: Colors.black,
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: "Receiver Name: ",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: '${completedTransactions[i]['name']}',
                                ),
                              ],
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: "Receiver Contact Number: ",
                                  style: const TextStyle(
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
                                  style: const TextStyle(
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
                                  style: const TextStyle(
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
                                  style: const TextStyle(
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
                                  style: const TextStyle(
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
                                TextSpan(
                                  text: 'Assemble Option: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: completedTransactions[i]['assembly']
                                      ? 'Yes'
                                      : 'No',
                                ),
                              ],
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "Items: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (completedTransactions[i]['items'] != null)
                                  TextSpan(
                                    text: (completedTransactions[i]['items']
                                            as List)
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
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: '₱${completedTransactions[i]['total']}',
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: Colors.black,
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Delivery Date/Time: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: completedTransactions[i]['updatedAt'] !=
                                          null
                                      ? DateFormat('MMM d, y - h:mm a').format(
                                          DateTime.parse(
                                              completedTransactions[i]
                                                  ['updatedAt']),
                                        )
                                      : 'null',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
