import 'dart:ui';

import 'package:customer_app/view/my_orders.page.dart';
import 'package:customer_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class TransactionCard extends StatefulWidget {
  final Transaction transaction;
  final VoidCallback onCancelTransaction;

  TransactionCard({
    required this.transaction,
    required this.onCancelTransaction,
  });

  @override
  _TransactionCardState createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  Color getTrackOrderButtonColor() {
    return widget.transaction.isApproved == "true"
        ? Color(0xFF232937)
        : Color(0xFFAFB7C9);
  }

  Color getCancelOrderButtonColor() {
    return widget.transaction.isApproved == "true"
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
                      widget.transaction.deliveryLocation,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(widget.transaction.customerPrice),
                  ],
                ),
                Text("Status: ${widget.transaction.status}"),
                CustomButton(
                  backgroundColor: getTrackOrderButtonColor(),
                  onPressed: () {},
                  text: 'Track Order',
                ),
                CustomButton(
                  backgroundColor: getCancelOrderButtonColor(),
                  onPressed: getCancelOrderButtonColor() == Color(0xFFAFB7C9)
                      ? () {}
                      : widget.onCancelTransaction,
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
