import 'package:customer_app/view/my_orders.page.dart';
import 'package:flutter/material.dart';

class OrderDetails extends StatefulWidget {
  final Transaction transaction;

  OrderDetails({required this.transaction});

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Order Details',
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("List of Products:"),
                    // Add logic to display products based on the widget.transaction.items
                    for (var item in widget.transaction.items)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item[
                              'productId']), // Assuming 'productId' is the correct field
                          Text("Stock: ${item['stock']}"),
                        ],
                      ),
                    Divider(
                      thickness: 1,
                      color: Colors.black,
                    ),
                    Text("Name: ${widget.transaction.name}"),
                    Text("Contact: ${widget.transaction.contactNumber}"),
                    Text("House#/Lot/Blk: ${widget.transaction.houseLotBlk}"),
                    Text("Payment Method: ${widget.transaction.paymentMethod}"),
                    Text("Installed: ${widget.transaction.installed}"),
                    Text("Delivery Time: ${widget.transaction.deliveryDate}"),
                    Text("Total Price: ${widget.transaction.total}"),
                    Text("Date: ${widget.transaction.createdAt}"),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
