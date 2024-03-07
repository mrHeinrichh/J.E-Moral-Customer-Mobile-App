import 'package:customer_app/routes/app_routes.dart';
import 'package:customer_app/view/appointment.page.dart';
import 'package:customer_app/view/authentication.page.dart';
import 'package:customer_app/view/cart.page.dart' as CartView;
import 'package:customer_app/view/cart_provider.dart' as CartProviderView;
import 'package:customer_app/view/chat.page.dart';
import 'package:customer_app/view/dashboard.page.dart';
import 'package:customer_app/view/faq.page.dart';
import 'package:customer_app/view/feedback.page.dart';
import 'package:customer_app/view/history.page.dart';
import 'package:customer_app/view/login.page.dart';
import 'package:customer_app/view/maps.page.dart';
import 'package:customer_app/view/my_orders.page.dart';
import 'package:customer_app/view/onboarding.page.dart';
import 'package:customer_app/view/orders_details.page.dart';
import 'package:customer_app/view/price_forecast.page.dart';
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
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => MessageProvider()),
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
        setDeliveryPage: (context) => SetDeliveryPage(),
        myOrdersPage: (context) => MyOrderPage(),
        trackingPage: (context) => TrackingPage(),
        authenticationPage: (context) => AuthenticationPage(),
        feedBackPage: (context) => FeedbackPage(),
        mapsPage: (context) => MapsPage(),
        forecastPage: (context) => ForecastPage(),
        orderDetailsPage: (context) {
          // Sample Transaction object
          Transaction sampleTransaction = Transaction(
            name: 'Sample Name',
            contactNumber: 'Sample Contact Number',
            houseLotBlk: 'Sample House/Lot/Block',
            paymentMethod: 'Sample Payment Method',
            assembly: false,
            deliveryDate: 'Sample Delivery Time',
            barangay: 'Sample Barangay',
            total: 0.0,
            completed: 'Sample Completed',
            hasFeedback: false,
            createdAt: 'Sample Created At',
            status: 'Sample Status',
            cancelReason: 'Sample Cancel Reason',
            items: [
              {
                'productId': 'Sample Product ID',
                'stock': 0,
              },
            ],
            deliveryLocation: 'Sample Location',
            customerPrice: 'Sample CustomerPrice',
            isApproved: 'Sample Status',
            pickupImages: 'Sample Pickup Images',
            cancellationImages: 'Sample Cancellation Images',
            completionImages: 'Sample Completion Images',
            id: 'Sample ID',
            discountIdImage: 'Sample discountIdImage',
          );

          return OrderDetails(transaction: sampleTransaction);
        },
        productDetailsPage: (context) {
          const id = "Placeholder ID";
          const productName = "Placeholder Name";
          const productPrice = "Placeholder Price";
          const showProductPrice = "Placeholder Price";
          const productImageUrl = "Placeholder Image URL";
          const description = "Placeholder Description";
          const weight = "Placeholder Weight";
          const stock = "Placeholder Stock";
          const quantity = 0;
          const itemType = "Placeholder Type";

          return ProductDetailsPage(
            id: id,
            productName: productName,
            productPrice: productPrice,
            showProductPrice: showProductPrice,
            productImageUrl: productImageUrl,
            category: "Placeholder Category Name",
            description: description,
            weight: weight,
            stock: stock,
            quantity: quantity,
            itemType: itemType,
          );
        },
      },
    );
  }
}
