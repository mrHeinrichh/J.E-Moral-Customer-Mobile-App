//my_orders.page.dart

import 'package:customer_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'package:customer_app/routes/app_routes.dart';
import 'package:photo_view/photo_view.dart';

class Transaction {
  final String deliveryLocation;
  final String customerPrice;
  final dynamic isApproved;
  final bool hasFeedback;
  final dynamic completed;
  final String id;
  final String name;
  final String contactNumber;
  final String houseLotBlk;
  final String paymentMethod;
  final String status;
  final String assembly;
  final String deliveryDate;
  final double total;
  final String cancelReason;
  final String createdAt;
  final String pickupImages;
  final String cancellationImages;
  final String completionImages;

  final List<Map<String, dynamic>> items;

  Transaction({
    required this.deliveryLocation,
    required this.customerPrice,
    required this.isApproved,
    required this.id,
    required this.name,
    required this.contactNumber,
    required this.houseLotBlk,
    required this.paymentMethod,
    required this.assembly,
    required this.status,
    required this.deliveryDate,
    required this.total,
    required this.createdAt,
    required this.items,
    required this.completed,
    required this.cancelReason,
    required this.pickupImages,
    required this.hasFeedback,
    required this.cancellationImages,
    required this.completionImages,
  });
}

class ZoomableImage extends StatelessWidget {
  final String imageUrl;

  ZoomableImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Image Proof',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        color: Colors.white,
        child: PhotoView(
          imageProvider: NetworkImage(imageUrl),
        ),
      ),
    );
  }
}

class MyOrderPage extends StatefulWidget {
  @override
  _MyOrderPageState createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrderPage> {
  List<Transaction> visibleTransactions = [];

  @override
  void initState() {
    super.initState();

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.userId;

    if (userId != null) {
      fetchTransactions(userId);
    }
  }

  void reloadTransactions() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.userId;

    if (userId != null) {
      fetchTransactions(userId);
    }
  }

  Future<void> fetchTransactions(String userId) async {
    final apiUrl = 'https://lpg-api-06n8.onrender.com/api/v1/transactions';

    final filterQuery =
        '{"to": "$userId", "__t": "Delivery", "hasFeedback": false}';

    // Add a limit parameter to the search URL
    final searchUrl =
        '$apiUrl/?filter=$filterQuery&limit=300'; // Adjust the limit value as needed

    final response = await http.get(Uri.parse(searchUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic>? data = jsonDecode(response.body);
      print(response.body);
      if (data != null && data['status'] == 'success') {
        final List<dynamic> transactionsData = data['data'] ?? [];

        transactionsData.sort((a, b) {
          // Convert updatedAt strings to DateTime and compare
          DateTime dateTimeA = DateTime.parse(a['updatedAt']);
          DateTime dateTimeB = DateTime.parse(b['updatedAt']);
          return dateTimeB.compareTo(dateTimeA);
        });

        setState(() {
          visibleTransactions = transactionsData
              .where((transactionData) =>
                  transactionData['status'] == 'Pending' ||
                  transactionData['status'] == 'Approved' ||
                  transactionData['status'] == 'On Going' ||
                  transactionData['status'] == 'Cancelled' ||
                  transactionData['status'] == 'Completed' &&
                      transactionData['hasFeedback'] == false &&
                      transactionData['deleted'] == false)
              .map((transactionData) => Transaction(
                    deliveryLocation: transactionData['deliveryLocation'],
                    customerPrice: transactionData['customerPrice'] != null
                        ? transactionData['customerPrice'].toString()
                        : 'N/A',
                    isApproved: transactionData['isApproved'],
                    id: transactionData['_id'],
                    name: transactionData['name'],
                    contactNumber: transactionData['contactNumber'],
                    houseLotBlk: transactionData['houseLotBlk'],
                    paymentMethod: transactionData['paymentMethod'],
                    assembly: transactionData['assembly'] is bool
                        ? transactionData['assembly'].toString()
                        : transactionData['assembly'],
                    status: transactionData['status'],
                    cancelReason: transactionData['cancelReason'] != null
                        ? transactionData['cancelReason'].toString()
                        : 'N/A',
                    deliveryDate: transactionData['deliveryDate'] != null
                        ? transactionData['deliveryDate'].toString()
                        : 'N/A',
                    total: transactionData['total'].toDouble(),
                    createdAt: transactionData['createdAt'],
                    items: (transactionData['items'] as List<dynamic>?)
                            ?.map<Map<String, dynamic>>((item) =>
                                item is Map<String, dynamic> ? item : {})
                            .toList() ??
                        [],
                    completed: transactionData['completed'],
                    pickupImages: transactionData['pickupImages'],
                    hasFeedback: transactionData['hasFeedback'],
                    cancellationImages: transactionData['cancellationImages'],
                    completionImages: transactionData['completionImages'],
                  ))
              .toList();
        });
      } else {}
    } else {}
  }

  Future<void> deleteTransaction(String transactionId) async {
    final response = await http.patch(
      Uri.parse(
          'https://lpg-api-06n8.onrender.com/api/v1/transactions/$transactionId'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
          {'status': "Archived", '__t': 'Delivery', 'deleted': true}),
    );

    if (response.statusCode == 200) {
      print(response.body);
      setState(() {});
    } else {}
  }

  Future<void> refreshData(userId) async {
    await fetchTransactions(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'My Orders',
          // style: TextStyle(color: Color(0xFF232937), fontSize: 24),
          style: TextStyle(
            color: const Color(0xFF050404).withOpacity(0.9),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              final userProvider =
                  Provider.of<UserProvider>(context, listen: false);
              final userId = userProvider.userId;

              if (userId != null) {
                fetchTransactions(userId);
              }
            },
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, dashboardRoute);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            for (int i = 0; i < visibleTransactions.length; i++)
              GestureDetector(
                onTap: () {},
                child: TransactionCard(
                  transaction: visibleTransactions[i],
                  onDeleteTransaction: () {
                    deleteTransaction(visibleTransactions[i].id);
                    reloadTransactions(); // Call the reloadTransactions callback
                  },
                  reloadTransactions:
                      reloadTransactions, // Pass the reloadTransactions callback
                  orderNumber: visibleTransactions.length - i,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class TransactionCard extends StatefulWidget {
  final Transaction transaction;
  final VoidCallback onDeleteTransaction;
  final VoidCallback reloadTransactions; // Add this line

  final int orderNumber;

  TransactionCard({
    required this.transaction,
    required this.onDeleteTransaction,
    required this.reloadTransactions, // Add this line

    required this.orderNumber,
  });

  @override
  _TransactionCardState createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  Color getTrackOrderButtonColor() {
    return widget.transaction.status.toString() == "On Going" ||
            widget.transaction.status.toString() == "Completed"
        ? const Color(0xFF232937)
        : const Color(0xFFAFB7C9);
  }

  Color getCancelOrderButtonColor() {
    return widget.transaction.status.toString() == "On Going" ||
            widget.transaction.status.toString() == "Approved" ||
            widget.transaction.status.toString() == "Completed"
        ? const Color(0xFFAFB7C9)
        : const Color(0xFF232937);
  }

  String getTrackOrderButtonText() {
    return widget.transaction.completed == true ? 'Feedback' : 'Track Order';
  }

  void _showTransactionDetailsModal(Transaction transaction) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return TransactionDetailsModal(transaction: transaction);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: SizedBox(
        height: 250,
        child: GestureDetector(
          onTap: () {
            _showTransactionDetailsModal(widget.transaction);
          },
          child: Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Order #${widget.orderNumber}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "₱${NumberFormat.decimalPattern().format(widget.transaction.total)}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black), // Default text style
                      children: [
                        TextSpan(
                          text: "Status: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold), // Bold style
                        ),
                        TextSpan(
                          text: "${widget.transaction.status}", // Regular style
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: widget.transaction.cancelReason != null &&
                        widget.transaction.cancelReason.isNotEmpty,
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black), // Default text style
                        children: [
                          TextSpan(
                            text: "Cancel Reason: ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold), // Bold style
                          ),
                          TextSpan(
                            text:
                                "${widget.transaction.cancelReason}", // Regular style
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomButton(
                    backgroundColor: getTrackOrderButtonColor(),
                    onPressed:
                        getTrackOrderButtonColor() == const Color(0xFFAFB7C9)
                            ? () {}
                            : () {
                                Navigator.pushNamed(
                                  context,
                                  authenticationPage,
                                  arguments: widget.transaction,
                                );
                              },
                    text: getTrackOrderButtonText(),
                  ),
                  CustomButton(
                    backgroundColor: getCancelOrderButtonColor(),
                    onPressed:
                        getCancelOrderButtonColor() == const Color(0xFFAFB7C9)
                            ? () {}
                            : () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Confirmation"),
                                      content: Text(
                                          "Are you sure you want to cancel this order? Action cannot be undone."),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                          },
                                          child: Text("No"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            // Call the onDeleteTransaction callback to archive the order
                                            widget.onDeleteTransaction();
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                            widget
                                                .reloadTransactions(); // Reload transactions
                                          },
                                          child: Text("Cancel Order"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                    text: 'Cancel Order',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TransactionDetailsModal extends StatelessWidget {
  final Transaction transaction;

  TransactionDetailsModal({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Transaction Number',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              transaction.id,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Divider(),
            const SizedBox(height: 5),
            Row(
              children: [
                const Text(
                  'Transaction Status',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(' : ${transaction.status}'),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            WidgetSpan(
                              child: const Icon(Icons.perm_identity_outlined),
                            ),
                            TextSpan(
                              text: ' : ${transaction.name}',
                            ),
                          ],
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            WidgetSpan(
                              child: const Icon(Icons.phone_rounded),
                            ),
                            TextSpan(
                              text: ' : ${transaction.contactNumber}',
                            ),
                          ],
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            WidgetSpan(
                              child: const Icon(Icons.location_on_outlined),
                            ),
                            TextSpan(
                              text: ' : ${transaction.deliveryLocation}',
                            ),
                          ],
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            WidgetSpan(
                              child: const Icon(Icons.house_outlined),
                            ),
                            TextSpan(
                              text: ' : ${transaction.houseLotBlk}',
                            ),
                          ],
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.payment_outlined),
                    Text(' : ${transaction.paymentMethod}'),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Assemble Option: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      transaction.paymentMethod.isNotEmpty ? 'Yes' : 'No',
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Items: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            if (transaction.items != null)
                              TextSpan(
                                text: transaction.items!.map((item) {
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
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('Total Price: ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                    Text(
                      '₱${NumberFormat.decimalPattern().format(transaction.total)}',
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Delivery Date/Time: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(DateFormat('MMM d, y - h:mm a ')
                        .format(DateTime.parse(transaction.deliveryDate))),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        const Text(
                          'Pick-up Image',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if (transaction.pickupImages != "")
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ZoomableImage(
                                    imageUrl: transaction.pickupImages!,
                                  ),
                                ),
                              );
                            },
                            child: ClipOval(
                              child: Image.network(
                                transaction.pickupImages!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          )
                        else
                          const Text(''),
                      ],
                    ),
                    Column(
                      children: [
                        const Text(
                          'Drop-off Image',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if (transaction.completionImages != "")
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ZoomableImage(
                                    imageUrl: transaction.completionImages!,
                                  ),
                                ),
                              );
                            },
                            child: ClipOval(
                              child: Image.network(
                                transaction.completionImages!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          )
                        else
                          const Text(''),
                      ],
                    ),
                    if (transaction.cancellationImages != "")
                      Column(
                        children: [
                          const Text(
                            'Cancellation Image',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ZoomableImage(
                                    imageUrl: transaction.cancellationImages!,
                                  ),
                                ),
                              );
                            },
                            child: ClipOval(
                              child: Image.network(
                                transaction.cancellationImages!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          )
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
