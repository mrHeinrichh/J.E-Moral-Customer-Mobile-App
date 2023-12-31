import 'package:customer_app/routes/app_routes.dart';
import 'package:customer_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'user_provider.dart';

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
      // Handle the case where userId is null
      return;
    }

    final apiUrl = 'https://lpg-api-06n8.onrender.com/api/v1/transactions';
    final searchUrl = '$apiUrl/?search=$userId';

    final response = await http.get(Uri.parse(searchUrl));
    if (!mounted) {
      return; // Check if the widget is still in the tree
    }

    if (response.statusCode == 200) {
      final Map<String, dynamic>? data = jsonDecode(response.body);

      if (data != null && data['status'] == 'success') {
        final List<dynamic> transactionsData = data['data'] ?? [];

        setState(() {
          visibleTransactions = transactionsData.cast<Map<String, dynamic>>();
        });
      } else {
        // Handle unexpected data format or other API errors
      }
    } else {
      // Handle HTTP error
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> completedTransactions = visibleTransactions
        .where((transaction) => transaction['completed'] == true)
        .toList();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'History',
          style: TextStyle(color: Color(0xFF232937), fontSize: 24),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Text("View Current Orders Here!"),
            SizedBox(
              height: 20,
            ),
            CustomButton(
              backgroundColor: Color(0xFF232937),
              onPressed: () {
                Navigator.pushNamed(context, myOrdersPage);
              },
              text: 'View Details',
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
                        Text('Order #${i + 1}'),
                        Text('Name: ${completedTransactions[i]['name']}'),
                        Text(
                            'Contact Number: ${completedTransactions[i]['contactNumber']}'),
                        Text(
                            'House/Lot/Blk: ${completedTransactions[i]['houseLotBlk']}'),
                        Text(
                            'Payment Method: ${completedTransactions[i]['paymentMethod']}'),
                        Text(
                            'Delivery Time: ${completedTransactions[i]['deliveryTime']}'),
                        Text('Total: ${completedTransactions[i]['total']}'),
                        Text(
                            'Delivery Location: ${completedTransactions[i]['deliveryLocation']}'),
                        Text('Price: ${completedTransactions[i]['price']}'),
                        Text(
                            'Is Approved: ${completedTransactions[i]['isApproved']}'),
                        Text(
                            'Barangay: ${completedTransactions[i]['barangay']}'),
                        Text(
                            'Picked Up: ${completedTransactions[i]['pickedUp']}'),
                      ],
                    ),
                  ),
                  onTap: () {},
                ),
              ),
          ],
        ),
      ),
    );
  }
}
