import 'dart:convert';

import 'package:customer_app/routes/app_routes.dart';
import 'package:customer_app/view/my_orders.page.dart';
import 'package:customer_app/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:customer_app/widgets/custom_button.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  double rating = 0.0;
  double rating1 = 0.0;
  double rating2 = 0.0;
  double rating3 = 0.0;
  double rating4 = 0.0;

  final userInterfaceController = TextEditingController();

  final easeofNavigationController = TextEditingController();

  final orderTimeController = TextEditingController();

  final riderandDeliveryserviceController = TextEditingController();

  final announcementsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Transaction transaction =
        ModalRoute.of(context)!.settings.arguments as Transaction;
    print(transaction.id);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Text(
            'Feedback',
            style: TextStyle(color: Color(0xFF232937), fontSize: 24),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: [
            const Text(
              'Application Responsiveness',
              style: TextStyle(
                color: Color(0xFF232937),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'How satisfied are you with the speed and responsiveness of our mobile/web application when browsing and making purchases?',
              style: TextStyle(
                color: Color(0xFF232937),
                fontSize: 15,
              ),
            ),
            RatingBar.builder(
              initialRating: rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemSize: 30,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (newRating) {
                setState(() {
                  rating = newRating;
                });
              },
            ),
            const Text(
              'Explain why you give such rating?',
              style: TextStyle(
                color: Color(0xFF232937),
                fontSize: 15,
              ),
            ),
            FeedbackTextField(
              labelText: '',
              hintText: '',
              controller: userInterfaceController,
            ),
            const Text(
              'Order Acceptance',
              style: TextStyle(
                color: Color(0xFF232937),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'How satisfied are you with the approval and speed of your transaction in the system?',
              style: TextStyle(
                color: Color(0xFF232937),
                fontSize: 15,
              ),
            ),
            RatingBar.builder(
              initialRating: rating1,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemSize: 30,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (newRating) {
                setState(() {
                  rating1 = newRating;
                });
              },
            ),
            const Text(
              'Explain why you give such rating?',
              style: TextStyle(
                color: Color(0xFF232937),
                fontSize: 15,
              ),
            ),
            FeedbackTextField(
              labelText: '',
              hintText: '',
              controller: easeofNavigationController,
            ),
            const Text(
              'Rider Performance',
              style: TextStyle(
                color: Color(0xFF232937),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'How satisfied are you with the communication skills and punctuality of the delivery rider in delivering your LPG order?',
              style: TextStyle(
                color: Color(0xFF232937),
                fontSize: 15,
              ),
            ),
            RatingBar.builder(
              initialRating: rating2,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemSize: 30,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (newRating) {
                setState(() {
                  rating2 = newRating;
                });
              },
            ),
            const Text(
              'Explain why you give such rating?',
              style: TextStyle(
                color: Color(0xFF232937),
                fontSize: 15,
              ),
            ),
            FeedbackTextField(
              labelText: '',
              hintText: '',
              controller: orderTimeController,
            ),
            const Text(
              'Overall Satisfaction',
              style: TextStyle(
                color: Color(0xFF232937),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'On a scale of 1 to 5, how would you describe your overall experience using our mobile/web application to purchase LPG products?',
              style: TextStyle(
                color: Color(0xFF232937),
                fontSize: 15,
              ),
            ),
            RatingBar.builder(
              initialRating: rating3,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemSize: 30,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (newRating) {
                setState(() {
                  rating3 = newRating;
                });
              },
            ),
            const Text(
              'Explain why you give such rating?',
              style: TextStyle(
                color: Color(0xFF232937),
                fontSize: 15,
              ),
            ),
            FeedbackTextField(
              labelText: '',
              hintText: '',
              controller: riderandDeliveryserviceController,
            ),
            const Text(
              'Recommendation',
              style: TextStyle(
                color: Color(0xFF232937),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Overall, how likely are you to recommend our mobile/web application to others based on your experience using it for LPG purchases?',
              style: TextStyle(
                color: Color(0xFF232937),
                fontSize: 15,
              ),
            ),
            RatingBar.builder(
              initialRating: rating4,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemSize: 30,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (newRating) {
                setState(() {
                  rating4 = newRating;
                });
              },
            ),
            const Text(
              'Explain why you give such rating?',
              style: TextStyle(
                color: Color(0xFF232937),
                fontSize: 15,
              ),
            ),
            FeedbackTextField(
              labelText: '',
              hintText: '',
              controller: announcementsController,
            ),
            CustomizedButton(
              onPressed: () {
                submitFeedback(transaction);
                // Navigator.pushNamed(context, dashboardRoute);
                print('Submitted Rating: $rating');
              },
              text: 'Submit',
              height: 50,
              width: 340,
              fontz: 18,
            ),
          ],
        ),
      ),
    );
  }

  List<String> getFeedbackValues() {
    return [
      rating.toString(),
      rating1.toString(),
      rating2.toString(),
      rating3.toString(),
      rating4.toString(),
      userInterfaceController.text,
      easeofNavigationController.text,
      orderTimeController.text,
      riderandDeliveryserviceController.text,
      announcementsController.text,
    ];
  }

  Future<void> submitFeedback(Transaction transaction) async {
    // List<String> feedbackValues = getFeedbackValues();

    // Validate ratings
    if (rating == 0.0 ||
        rating1 == 0.0 ||
        rating2 == 0.0 ||
        rating3 == 0.0 ||
        rating4 == 0.0) {
      // Show error message for missing ratings
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Please provide ratings for all categories."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
      return;
    }

    if (userInterfaceController.text.trim().isEmpty ||
        userInterfaceController.text.length < 5 ||
        easeofNavigationController.text.trim().isEmpty ||
        easeofNavigationController.text.length < 5 ||
        orderTimeController.text.trim().isEmpty ||
        orderTimeController.text.length < 5 ||
        riderandDeliveryserviceController.text.trim().isEmpty ||
        riderandDeliveryserviceController.text.length < 5 ||
        announcementsController.text.trim().isEmpty ||
        announcementsController.text.length < 5) {
      // Show error message for missing or insufficient explanations
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(
                "Please provide explanations for all categories and ensure each explanation is at least 5 characters long."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
      return;
    }

    // Map<String, dynamic> feedbackData = {
    //   "hasFeedback": 'true',
    //   "feedback":
    //       getFeedbackValues().join(', '), // Join the array into a string
    //   "_id": transaction.id,
    //   "__t": "Delivery"
    // };

    List<String> feedbackValues = getFeedbackValues();

    Map<String, dynamic> feedbackData = {
      "hasFeedback": 'true',
      "feedback":
          getFeedbackValues().join(', '), // Join the array into a string
      "_id": transaction.id,
      "__t": "Delivery"
    };

    String jsonData = jsonEncode(feedbackData);

    String apiUrl =
        "https://lpg-api-06n8.onrender.com/api/v1/transactions/${transaction.id}";

    try {
      http.Response response = await http.patch(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonData,
      );

      if (response.statusCode == 200) {
        print("Feedback submitted successfully");
        print(response.body);
        print(response.statusCode);
        Navigator.pushNamed(context, dashboardRoute);
      } else {
        print("Failed to submit feedback. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error: $error");
    }
  }
}
