import 'package:customer_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:customer_app/widgets/custom_button.dart';

class HistoryCard extends StatelessWidget {
  final String orderText;
  final String price;
  final String status;

  HistoryCard({
    required this.orderText,
    required this.price,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: SizedBox(
        height: 160,
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
                      orderText,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(price),
                  ],
                ),
                Text("Status: $status"),
                CustomButton(
                  onPressed: () {
                    Navigator.pushNamed(context, historyDetails);
                  },
                  text: 'View Details',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
