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
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Padding(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
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
              'Visually Appearance',
              style: TextStyle(
                color: Color(0xFF232937),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'How well does the visual appeal of the platform translate across different devices, such as web and mobile?',
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
              'Transaction Speed',
              style: TextStyle(
                color: Color(0xFF232937),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'How satisfied are you with the speed of the application in processing your LPG transactions?',
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
              'Payment Method',
              style: TextStyle(
                color: Color(0xFF232937),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'How satisfied are you with the efficiency and security of the payment processing system within the application?',
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
              'Announcements Efficiency',
              style: TextStyle(
                color: Color(0xFF232937),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'How valuable do you find the announcements section in keeping you informed -about the trends in the LPG Industry',
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
