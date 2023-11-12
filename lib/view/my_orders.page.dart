import 'package:customer_app/view/orders_details.page.dart';
import 'package:customer_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'package:customer_app/routes/app_routes.dart';

class Transaction {
  final String deliveryLocation;
  final String price;
  final dynamic isApproved;
  final String id; // Added ID field for identifying transactions
  final String name;
  final String contactNumber;
  final String houseLotBlk;
  final String paymentMethod;
  final String assembly;
  final String deliveryTime;
  final double total;
  final String createdAt;
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
    required this.deliveryTime,
    required this.total,
    required this.createdAt,
    required this.items,
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

  Future<void> fetchTransactions(String userId) async {
    final apiUrl = 'https://lpg-api-06n8.onrender.com/api/v1/transactions';
    final searchUrl = '$apiUrl/?search=$userId';

    final response = await http.get(Uri.parse(searchUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic>? data = jsonDecode(response.body);

      if (data != null && data['status'] == 'success') {
        final List<dynamic> transactionsData = data['data'] ?? [];

        setState(() {
          visibleTransactions = transactionsData
              .map((transactionData) => Transaction(
                    name: transactionData['name'] ?? '',
                    contactNumber: transactionData['contactNumber'] ?? '',
                    houseLotBlk: transactionData['houseLotBlk'] ?? '',
                    paymentMethod: transactionData['paymentMethod'] ?? '',
                    assembly: transactionData['assembly'] ?? '',
                    deliveryTime: transactionData['deliveryTime'] ?? '',
                    total: transactionData['total'] ?? 0,
                    createdAt: transactionData['createdAt'] ?? '',
                    items: List<Map<String, dynamic>>.from(
                        transactionData['items'] ?? []),
                    deliveryLocation: transactionData['deliveryLocation'] ?? '',
                    price: transactionData['total'].toString(),
                    isApproved: transactionData['isApproved'] ?? '',
                    id: transactionData['_id'] ?? '',
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
    final apiUrl = 'https://lpg-api-06n8.onrender.com/api/v1/transactions';
    final deleteUrl = '$apiUrl/$transactionId';

    final response = await http.delete(Uri.parse(deleteUrl));

    if (response.statusCode == 200) {
      // Transaction deleted successfully, update UI or handle as needed
    } else {
      // Handle HTTP error
    }
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            for (int i = 0; i < visibleTransactions.length; i++)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          OrderDetails(transaction: visibleTransactions[i]),
                    ),
                  );
                },
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
    return widget.transaction.isApproved.toString() == "true"
        ? Color(0xFF232937)
        : Color(0xFFAFB7C9);
  }

  Color getCancelOrderButtonColor() {
    return widget.transaction.isApproved.toString() == "true"
        ? Color(0xFFAFB7C9)
        : Color(0xFF232937);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: SizedBox(
        height: 200,
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
                    Text(widget.transaction.price),
                  ],
                ),
                Text("Status: ${widget.transaction.isApproved}"),
                CustomButton(
                  backgroundColor: getTrackOrderButtonColor(),
                  onPressed: () {
                    // Navigate to track order page
                  },
                  text: 'Track Order',
                ),
                CustomButton(
                  backgroundColor: getCancelOrderButtonColor(),
                  onPressed: getCancelOrderButtonColor() == Color(0xFFAFB7C9)
                      ? () {}
                      : widget.onDeleteTransaction,
                  text: 'Cancel Order',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
