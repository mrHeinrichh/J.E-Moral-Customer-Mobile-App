import 'package:customer_app/routes/app_routes.dart';
import 'package:customer_app/view/appointment.page.dart';
import 'package:customer_app/view/dashboard.page.dart';
import 'package:customer_app/view/login.page.dart';
import 'package:customer_app/view/onboarding.page.dart';
import 'package:customer_app/view/signup.page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
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
      },
    );
  }
}
