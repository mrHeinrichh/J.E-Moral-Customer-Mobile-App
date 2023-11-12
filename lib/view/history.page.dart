import 'package:customer_app/routes/app_routes.dart';
import 'package:customer_app/widgets/custom_button.dart';
import 'package:customer_app/widgets/history_card.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'History',
          style: TextStyle(color: Color(0xFF232937), fontSize: 24),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
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
            HistoryCard(
              orderText: "Order #1",
              price: "₱---.--",
              status: "Completed",
            ),
            HistoryCard(
              orderText: "Order #2",
              price: "₱---.--",
              status: "Completed",
            ),
            HistoryCard(
              orderText: "Order #3",
              price: "₱---.--",
              status: "Completed",
            ),
          ],
        ), // Use the custom HistoryCard widget here
      ),
    );
  }
}
