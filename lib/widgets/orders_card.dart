import 'package:customer_app/view/my_orders.page.dart';
import 'package:flutter/material.dart';
import 'custom_button.dart';

class OrdersCard extends StatefulWidget {
  final Order order;
  final VoidCallback onCancelOrder; // Change the function signature

  OrdersCard({
    required this.order,
    required this.onCancelOrder,
  });

  @override
  _OrdersCardState createState() => _OrdersCardState();
}

class _OrdersCardState extends State<OrdersCard> {
  Color getTrackOrderButtonColor() {
    return widget.order.status == "Approved"
        ? Color(0xFF232937)
        : Color(0xFFAFB7C9);
  }

  Color getCancelOrderButtonColor() {
    return widget.order.status == "Approved"
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
                      widget.order.orderText,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(widget.order.price),
                  ],
                ),
                Text("Status: ${widget.order.status}"),
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
                      ? () {} // This is an empty function, effectively disabling the button
                      : widget.onCancelOrder,
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
