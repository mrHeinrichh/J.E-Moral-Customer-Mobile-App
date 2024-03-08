import 'package:customer_app/widgets/custom_button.dart';
import 'package:customer_app/widgets/custom_text.dart';
import 'package:customer_app/widgets/fullscreen_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'package:customer_app/routes/app_routes.dart';

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
  final String barangay;
  final String paymentMethod;
  final String status;
  final bool assembly;
  final String deliveryDate;
  final double total;
  final String cancelReason;
  final String createdAt;
  final String pickupImages;
  final String cancellationImages;
  final String completionImages;
  final String discountIdImage;

  final List<Map<String, dynamic>> items;

  Transaction({
    required this.deliveryLocation,
    required this.customerPrice,
    required this.isApproved,
    required this.id,
    required this.name,
    required this.contactNumber,
    required this.houseLotBlk,
    required this.barangay,
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
    required this.discountIdImage,
  });
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
    final apiUrl =
        'https://lpg-api-06n8.onrender.com/api/v1/transactions/?filter={"to":"$userId","__t":"Delivery","hasFeedback":false,"deleted":false}&limit=300';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic>? data = jsonDecode(response.body);
      print(response.body);
      if (data != null && data['status'] == 'success') {
        final List<dynamic> transactionsData = data['data'] ?? [];

        transactionsData.sort((a, b) {
          DateTime dateTimeA = DateTime.parse(a['updatedAt']);
          DateTime dateTimeB = DateTime.parse(b['updatedAt']);
          return dateTimeB.compareTo(dateTimeA);
        });

        setState(() {
          visibleTransactions = transactionsData
              .where((transactionData) =>
                  transactionData['status'] == 'Pending' ||
                  transactionData['status'] == 'Declined' ||
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
                        : '',
                    isApproved: transactionData['isApproved'],
                    id: transactionData['_id'],
                    name: transactionData['name'],
                    contactNumber: transactionData['contactNumber'],
                    houseLotBlk: transactionData['houseLotBlk'],
                    barangay: transactionData['barangay'],
                    paymentMethod: transactionData['paymentMethod'],
                    assembly: transactionData['assembly'],
                    status: transactionData['status'],
                    cancelReason: transactionData['cancelReason'] != null
                        ? transactionData['cancelReason'].toString()
                        : '',
                    deliveryDate: transactionData['deliveryDate'] != null
                        ? transactionData['deliveryDate'].toString()
                        : '',
                    discountIdImage: transactionData['discountIdImage'] != null
                        ? transactionData['discountIdImage'].toString()
                        : '',
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

  Future<void> cancelTransaction(String transactionId) async {
    final response = await http.patch(
      Uri.parse(
          'https://lpg-api-06n8.onrender.com/api/v1/transactions/$transactionId'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'status': "Cancelled", '__t': 'Delivery'}),
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
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'My Orders',
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
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long_outlined),
            onPressed: () {
              Navigator.pushReplacementNamed(context, historyRoute);
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        color: const Color(0xFF050404),
        strokeWidth: 2.5,
        onRefresh: () async {
          final userProvider =
              Provider.of<UserProvider>(context, listen: false);
          final userId = userProvider.userId;

          if (userId != null) {
            await fetchTransactions(userId);
          }
        },
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView(
                  children: [
                    const SizedBox(height: 20),
                    for (int i = 0; i < visibleTransactions.length; i++)
                      GestureDetector(
                        onTap: () {},
                        child: TransactionCard(
                          transaction: visibleTransactions[i],
                          onDeleteTransaction: () {
                            cancelTransaction(visibleTransactions[i].id);
                            reloadTransactions();
                          },
                          reloadTransactions: reloadTransactions,
                          orderNumber: visibleTransactions.length - i,
                        ),
                      ),
                    const SizedBox(height: 10),
                  ],
                ),
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
  final VoidCallback reloadTransactions;

  final int orderNumber;

  TransactionCard({
    required this.transaction,
    required this.onDeleteTransaction,
    required this.reloadTransactions,
    required this.orderNumber,
  });

  @override
  _TransactionCardState createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  Color getTrackOrderButtonColor() {
    return widget.transaction.status.toString() == "On Going" ||
            widget.transaction.status.toString() == "Completed"
        ? const Color(0xFF050404).withOpacity(0.9)
        : const Color(0xFF050404).withOpacity(0.1);
  }

  Color getCancelOrderButtonColor() {
    return widget.transaction.status.toString() == "On Going" ||
            widget.transaction.status.toString() == "Approved" ||
            widget.transaction.status.toString() == "Declined" ||
            widget.transaction.status.toString() == "Completed" ||
            widget.transaction.status.toString() == "Cancelled"
        ? const Color(0xFF050404).withOpacity(0.1)
        : const Color(0xFF050404).withOpacity(0.9);
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
    return GestureDetector(
      onTap: () {
        _showTransactionDetailsModal(widget.transaction);
      },
      child: Column(
        children: [
          Card(
            color: Colors.white,
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Order #${widget.orderNumber}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (widget.transaction.status != "Cancelled" &&
                          widget.transaction.status != "Declined")
                        Text(
                          "₱${widget.transaction.total % 1 == 0 ? NumberFormat('#,##0').format(widget.transaction.total.toInt()) : NumberFormat('#,##0.00').format(widget.transaction.total).replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "")}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF050404).withOpacity(0.9),
                          ),
                        ),
                      if (widget.transaction.status == "Declined" ||
                          widget.transaction.status == "Cancelled")
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: const Color(0xFF050404).withOpacity(0.9),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  title: const Center(
                                    child: Text(
                                      "Confirmation",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  content: const Text(
                                    "Are you sure you want to Remove this Transaction?",
                                    textAlign: TextAlign.center,
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: const Color(0xFF050404)
                                            .withOpacity(0.8),
                                      ),
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        removeTransaction(
                                            widget.transaction.id);
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: const Color(0xFFd41111)
                                            .withOpacity(0.9),
                                      ),
                                      child: const Text("Remove"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                    ],
                  ),
                  const Divider(),
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: "Status: ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: widget.transaction.status,
                          style: TextStyle(
                            fontSize: 16,
                            color: const Color(0xFF050404).withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.transaction.cancelReason != null &&
                      widget.transaction.cancelReason.isNotEmpty)
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: "Reason/s: ",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: widget.transaction.cancelReason,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 15),
                  CustomButton(
                    backgroundColor: getTrackOrderButtonColor(),
                    onPressed: getTrackOrderButtonColor() ==
                            const Color(0xFF050404).withOpacity(0.1)
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
                  const SizedBox(height: 5),
                  CustomButton(
                    backgroundColor: getCancelOrderButtonColor(),
                    onPressed: (widget.transaction.status == 'Approved' ||
                            widget.transaction.status == 'Cancelled')
                        ? () {}
                        : () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  title: const Center(
                                    child: Text(
                                      "Confirmation",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  content: const Text(
                                    "Are you sure you want to Cancel this Order?",
                                    textAlign: TextAlign.center,
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: const Color(0xFF050404)
                                            .withOpacity(0.8),
                                      ),
                                      child: const Text("No"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        widget.onDeleteTransaction();
                                        Navigator.of(context).pop();
                                        widget.reloadTransactions();
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: const Color(0xFFd41111)
                                            .withOpacity(0.9),
                                      ),
                                      child: const Text("Cancel Order"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                    text: "Cancel Order",
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }

  Future<void> removeTransaction(String id) async {
    final response = await http.patch(
      Uri.parse('https://lpg-api-06n8.onrender.com/api/v1/transactions/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'deleted': true, '__t': 'Delivery'}),
    );

    if (response.statusCode == 200) {
      print(response.body);

      widget.reloadTransactions();
      Navigator.of(context).pop();
    } else {}
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
              'Transaction ID:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              transaction.id,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Divider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BodyMediumText(
                  text: 'Status: ${transaction.status}',
                ),
                if (transaction.cancelReason.isNotEmpty)
                  Column(
                    children: [
                      const SizedBox(height: 5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'Reason: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: transaction.cancelReason,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                const Divider(),
                const Center(
                  child: BodyMedium(
                    text: 'Receiver Information:',
                  ),
                ),
                BodyMediumText(
                  text: 'Name: ${transaction.name}',
                ),
                BodyMediumText(
                  text: 'Mobile Number: ${transaction.contactNumber}',
                ),
                BodyMediumOver(
                  text: 'House Number: ${transaction.houseLotBlk}',
                ),
                BodyMediumText(
                  text: 'Barangay: ${transaction.barangay}',
                ),
                BodyMediumOver(
                  text: 'Delivery Location: ${transaction.deliveryLocation}',
                ),
                const Divider(),
                BodyMediumText(
                  text: 'Payment Method: ${transaction.paymentMethod}',
                ),
                BodyMediumOver(
                    text:
                        'Delivery Date and Time: ${DateFormat('MMMM d, y - h:mm a ').format(
                  DateTime.parse(transaction.deliveryDate),
                )} '),
                BodyMediumText(
                  text:
                      'Assemble Option: ${transaction.assembly ? 'Yes' : 'No'}',
                ),
                BodyMediumText(
                  text:
                      'Applying for Discount: ${transaction.discountIdImage.isNotEmpty ? 'Yes' : 'No'}',
                ),
                if (transaction.discountIdImage.isNotEmpty)
                  Column(
                    children: [
                      const SizedBox(height: 5),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullScreenImageView(
                                imageUrl: transaction.discountIdImage!,
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
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color(0xFF050404).withOpacity(0.9),
                              width: 1,
                            ),
                            image: DecorationImage(
                              image: NetworkImage(transaction.discountIdImage),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                const SizedBox(height: 10),
                BodyMediumOver(
                  text: 'Items: ${transaction.items!.map((item) {
                    if (item is Map<String, dynamic> &&
                        item.containsKey('name') &&
                        item.containsKey('quantity') &&
                        item.containsKey('customerPrice')) {
                      final itemName = item['name'];
                      final quantity = item['quantity'];
                      final price = NumberFormat.decimalPattern().format(
                          double.parse(
                              (item['customerPrice']).toStringAsFixed(2)));

                      return '$itemName (₱$price x $quantity)';
                    }
                  }).join(', ')}',
                ),
                BodyMediumText(
                  text:
                      'Total Price: ₱${transaction.total % 1 == 0 ? NumberFormat('#,##0').format(transaction.total.toInt()) : NumberFormat('#,##0.00').format(transaction.total).replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "")}',
                ),
                if (transaction.pickupImages != "" ||
                    transaction.cancellationImages != "" ||
                    transaction.completionImages != "")
                  Column(
                    children: [
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              const Text(
                                'Pick-up Image',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              if (transaction.pickupImages != "")
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            FullScreenImageView(
                                          imageUrl: transaction.pickupImages!,
                                          onClose: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      transaction.pickupImages!,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
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
                              const SizedBox(height: 5),
                              if (transaction.completionImages != "")
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            FullScreenImageView(
                                          imageUrl:
                                              transaction.completionImages!,
                                          onClose: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      transaction.completionImages!,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
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
                                const SizedBox(height: 5),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            FullScreenImageView(
                                          imageUrl:
                                              transaction.cancellationImages!,
                                          onClose: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      transaction.cancellationImages!,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              ],
                            ),
                        ],
                      ),
                    ],
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
