import 'package:customer_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'package:customer_app/routes/app_routes.dart';
import 'package:photo_view/photo_view.dart';

class Transaction {
  final String deliveryLocation;
  final String price;
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
    required this.price,
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
        title: Text(
          'Image Proof',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme:
            IconThemeData(color: Colors.black), // Set back icon color to black
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

  Future<void> fetchTransactions(String userId) async {
    final apiUrl = 'https://lpg-api-06n8.onrender.com/api/v1/transactions';

    // Use the query parameter to filter by 'to' and '__t' fields
    final filterQuery = '{"to": "$userId", "__t": "Delivery"}';
    final searchUrl = '$apiUrl/?filter=$filterQuery';

    final response = await http.get(Uri.parse(searchUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic>? data = jsonDecode(response.body);
      print(response.body);
      if (data != null && data['status'] == 'success') {
        final List<dynamic> transactionsData = data['data'] ?? [];

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
                    price: transactionData['price'] != null
                        ? transactionData['price'].toString()
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
      } else {
        // Handle unexpected data format or other API errors
      }
    } else {
      // Handle HTTP error
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'My Orders',
          style: TextStyle(color: Color(0xFF232937), fontSize: 24),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // Add logic to refresh the page here
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
          icon: Icon(Icons.arrow_back),
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
                  onDeleteTransaction: () =>
                      deleteTransaction(visibleTransactions[i].id),
                  orderNumber: i + 1,
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
  final int orderNumber;

  TransactionCard({
    required this.transaction,
    required this.onDeleteTransaction,
    required this.orderNumber,
  });

  @override
  _TransactionCardState createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  Color getTrackOrderButtonColor() {
    return widget.transaction.status.toString() == "On Going" ||
            widget.transaction.status.toString() == "Completed"
        ? Color(0xFF232937)
        : Color(0xFFAFB7C9);
  }

  Color getCancelOrderButtonColor() {
    return widget.transaction.status.toString() == "On Going" ||
            widget.transaction.status.toString() == "Approved" ||
            widget.transaction.status.toString() == "Completed"
        ? Color(0xFFAFB7C9)
        : Color(0xFF232937);
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
                      Text("${widget.transaction.total}"),
                    ],
                  ),
                  Text("Status: ${widget.transaction.status}"),
                  Visibility(
                    visible: widget.transaction.cancelReason != null &&
                        widget.transaction.cancelReason.isNotEmpty,
                    child: Text(
                      "Cancel Reason: ${widget.transaction.cancelReason}",
                      style: TextStyle(
                          fontSize: 16), // Adjust the font size as needed
                    ),
                  ),
                  CustomButton(
                    backgroundColor: getTrackOrderButtonColor(),
                    onPressed: getTrackOrderButtonColor() == Color(0xFFAFB7C9)
                        ? () {} // Provide an empty function for disabled state
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
                    onPressed: getCancelOrderButtonColor() == Color(0xFFAFB7C9)
                        ? () {}
                        : widget.onDeleteTransaction,
                    text: 'Archive Order',
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
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Transaction Number',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${transaction.id}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Divider(),
            SizedBox(height: 5),
            Row(
              children: [
                Text(
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
                  children: [
                    Icon(Icons.perm_identity_outlined),
                    Text(' : ${transaction.name}'),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.phone_rounded),
                    Text(' : ${transaction.contactNumber}'),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.house_outlined),
                    Text(' : ${transaction.houseLotBlk}'),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on_outlined),
                    Expanded(
                      child: Text(
                        ' : ${transaction.deliveryLocation}',
                        textAlign:
                            TextAlign.start, // Align text to start (left)
                      ),
                    ),
                  ],
                ),

                // SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.payment_outlined),
                    Text(' : ${transaction.paymentMethod}'),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Assemble Option',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(' : ${transaction.assembly}'),
                  ],
                ),

                Row(
                  children: [
                    Text(
                      'Delivery Date/Time',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(' : ${transaction.deliveryDate}'),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Items: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                        width:
                            5), // Add some space between "Items:" and the items list
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (transaction.items != null)
                            Text(
                              transaction.items!.map((item) {
                                if (item is Map<String, dynamic> &&
                                    item.containsKey('name') &&
                                    item.containsKey('quantity')) {
                                  return '${item['name']} (${item['quantity']})';
                                }
                                return ''; // Return an empty string if 'name' or 'quantity' is not available
                              }).join(', '), // Join item texts with commas
                            ),
                        ],
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Text('Total Price ₱',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                    Text('${transaction.total}'),
                  ],
                ),

                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Pick Up Image',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if (transaction.pickupImages != null &&
                            transaction.pickupImages!.isNotEmpty)
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
                          Text('N/A'),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Cancellation Image',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if (transaction.cancellationImages != null &&
                            transaction.cancellationImages!.isNotEmpty)
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
                        else
                          Text('N/A'),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Dropoff Image',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if (transaction.completionImages != null &&
                            transaction.completionImages!.isNotEmpty)
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
                                fit: BoxFit
                                    .fitHeight, // Make the image cover the circular area
                              ),
                            ),
                          )
                        else
                          Text('N/A'),
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
