import 'package:flutter/material.dart';

class HistoryDetails extends StatefulWidget {
  @override
  _HistoryDetailsState createState() => _HistoryDetailsState();
}

class _HistoryDetailsState extends State<HistoryDetails> {
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
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color(0xFF232937), // Set the icon color here
          ),
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back when pressed
          },
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("List of Products:"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text("Regasco"), Text("Quantity: 1")],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text("Regasco"), Text("Quantity: 1")],
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.black,
                    ),
                    Text("Name: John Doe"),
                    Text("Contact: 0956 9734 9935"),
                    Text("House#/Lot/Blk:"),
                    Text("Barangay:"),
                    Text("Payment Method: Cash on Delivery"),
                    Text("Needs to be assembled?: Yes"),
                    Text("Delivery Time: Deliver Now"),
                    Text("Delivery Charge: Free"),
                    Text(
                      "Total Price: ---.--",
                    ),
                    Text(
                      "Date: 10/02/2002",
                    )
                  ],
                ),
              ),
            )
          ],
        ), // Use the custom HistoryCard widget here
      ),
    );
  }
}
