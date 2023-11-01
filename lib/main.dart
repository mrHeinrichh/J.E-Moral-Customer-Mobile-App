import 'package:customer_app/routes/app_routes.dart';
import 'package:customer_app/view/appointment.page.dart';
import 'package:customer_app/view/cart.page.dart';
import 'package:customer_app/view/cart_provider.dart';
import 'package:customer_app/view/dashboard.page.dart';
import 'package:customer_app/view/faq.page.dart';
import 'package:customer_app/view/history.page.dart';
import 'package:customer_app/view/history_details.page.dart';
import 'package:customer_app/view/login.page.dart';
import 'package:customer_app/view/my_orders.page.dart';
import 'package:customer_app/view/onboarding.page.dart';
import 'package:customer_app/view/orders_details.page.dart';
import 'package:customer_app/view/product_details.page.dart';
import 'package:customer_app/view/set_delivery.page.dart';
import 'package:customer_app/view/signup.page.dart';
import 'package:customer_app/view/tracking.page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) {
        return CartProvider();
      },
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App',
      initialRoute: onboardingRoute, // Set the initial route
      routes: {
        onboardingRoute: (context) =>
            OnBoardingPage(), // Use the imported route
        signupRoute: (context) => SignupPage(), // Use the imported route
        loginRoute: (context) => LoginPage(), // Use the imported route
        dashboardRoute: (context) => DashboardPage(), // Use the imported route
        appointmentRoute: (context) =>
            AppointmentPage(), // Use the imported route
        cartRoute: (context) => CartPage(), // Use the imported route
        faqRoute: (context) => FaqPage(),
        historyRoute: (context) => HistoryPage(),
        historyDetails: (context) => HistoryDetails(),
        setDeliveryPage: (context) => SetDeliveryPage(),
        myOrdersPage: (context) => MyOrderPage(),
        trackingPage: (context) => TrackingPage(),
        orderDetailsPage: (context) => OrderDetails(),
        productDetailsPage: (context) {
          // You should provide the actual product details when this route is accessed.
          // For now, you can provide placeholder values, and these will be overridden when a product is tapped.
          const productName = "Placeholder Name";
          const productPrice = "Placeholder Price";
          const productImageUrl = "Placeholder Image URL";

          return ProductDetailsPage(
            productName: productName,
            productPrice: productPrice,
            productImageUrl: productImageUrl,
            categoryName: "Placeholder Category Name",
          );
        },
      },
    );
  }
}
