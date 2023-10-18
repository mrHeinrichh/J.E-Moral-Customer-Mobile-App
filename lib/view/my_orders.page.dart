import 'package:customer_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:customer_app/widgets/orders_card.dart';

class MyOrderPage extends StatefulWidget {
  @override
  _MyOrderPageState createState() => _MyOrderPageState();
}

class Order {
  final String orderText;
  final String price;
  final String status;

  Order({
    required this.orderText,
    required this.price,
    required this.status,
  });
}

class _MyOrderPageState extends State<MyOrderPage> {
  List<Order> orders = [
    Order(orderText: "Order #1", price: "₱---.--", status: "Approved"),
    Order(orderText: "Order #2", price: "₱---.--", status: "Not Approved"),
    Order(orderText: "Order #3", price: "₱---.--", status: "Not Approved"),
  ];

  List<Order> visibleOrders = []; // List of currently visible orders

  void cancelOrder(Order order) {
    setState(() {
      visibleOrders
          .remove(order); // Remove the order from the list of visible orders
    });
  }

  @override
  void initState() {
    super.initState();
    visibleOrders.addAll(
        orders); // Initialize the list of visible orders with all orders
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
        child: Column(
          children: [
            for (var order in visibleOrders)
              GestureDetector(
                onTap: () {
                  // Navigate to the order details page
                  Navigator.pushNamed(context, orderDetailsPage);
                },
                child: OrdersCard(
                  order: order,
                  onCancelOrder: () => cancelOrder(order),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
