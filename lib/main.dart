import 'package:customer_app/routes/app_routes.dart';
import 'package:customer_app/view/appointment.page.dart';
import 'package:customer_app/view/authentication.page.dart';
import 'package:customer_app/view/cart.page.dart' as CartView;
import 'package:customer_app/view/cart_provider.dart' as CartProviderView;
import 'package:customer_app/view/dashboard.page.dart';
import 'package:customer_app/view/faq.page.dart';
import 'package:customer_app/view/feedback.page.dart';
import 'package:customer_app/view/history.page.dart';
import 'package:customer_app/view/history_details.page.dart';
import 'package:customer_app/view/login.page.dart';
import 'package:customer_app/view/maps.page.dart';
import 'package:customer_app/view/my_orders.page.dart';
import 'package:customer_app/view/onboarding.page.dart';
import 'package:customer_app/view/orders_details.page.dart';
import 'package:customer_app/view/product_details.page.dart';
import 'package:customer_app/view/set_delivery.page.dart';
import 'package:customer_app/view/signup.page.dart';
import 'package:customer_app/view/tracking.page.dart';
import 'package:customer_app/view/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => CartProviderView.CartProvider()),
        ChangeNotifierProvider(
            create: (context) => UserProvider()), // Add UserProvider
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App',
      initialRoute: onboardingRoute,
      routes: {
        onboardingRoute: (context) => OnBoardingPage(),
        signupRoute: (context) => SignupPage(),
        loginRoute: (context) => LoginPage(),
        dashboardRoute: (context) => DashboardPage(),
        appointmentRoute: (context) => AppointmentPage(),
        cartRoute: (context) => CartView.CartPage(),
        faqRoute: (context) => FaqPage(),
        historyRoute: (context) => HistoryPage(),
        historyDetails: (context) => HistoryDetails(),
        setDeliveryPage: (context) => SetDeliveryPage(),
        myOrdersPage: (context) => MyOrderPage(),
        trackingPage: (context) => TrackingPage(),
        authenticationPage: (context) => AuthenticationPage(),
        feedBackPage: (context) => FeedbackPage(),
        mapsPage: (context) => MapsPage(),
        orderDetailsPage: (context) {
          // Sample Transaction object
          Transaction sampleTransaction = Transaction(
            name: 'Sample Name',
            contactNumber: 'Sample Contact Number',
            houseLotBlk: 'Sample House/Lot/Block',
            paymentMethod: 'Sample Payment Method',
            assembly: 'Sample Assembly',
            deliveryTime: 'Sample Delivery Time',
            total: 0.0,
            completed: 'Sample Completed',
            hasFeedback: false,
            createdAt: 'Sample Created At',
            items: [
              {
                'productId': 'Sample Product ID',
                'quantity': 0,
              },
            ],
            deliveryLocation: 'Sample Location',
            price: 'Sample Price',
            isApproved: 'Sample Status',
            pickupImages: 'Sample Pickup Images',
            completionImages: 'Sample Completion Images',
            id: 'Sample ID',
          );

          return OrderDetails(transaction: sampleTransaction);
        },
        productDetailsPage: (context) {
          const productName = "Placeholder Name";
          const productPrice = "Placeholder Price";
          const productImageUrl = "Placeholder Image URL";
          const description = "Placeholder Description";
          const weight = "Placeholder Weight";
          const quantity = "Placeholder Quantity";

          return ProductDetailsPage(
            productName: productName,
            productPrice: productPrice,
            productImageUrl: productImageUrl,
            category: "Placeholder Category Name",
            description: description,
            weight: weight,
            quantity: quantity,
          );
        },
      },
    );
  }
}
