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
  final formKey = GlobalKey<FormState>();

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
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'Feedback',
          style: TextStyle(
            color: const Color(0xFF050404).withOpacity(0.9),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: const Color(0xFF050404).withOpacity(0.8),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.black,
            height: 0.2,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Application Responsiveness',
                  style: TextStyle(
                    color: Color(0xFF050404),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'How satisfied are you with the speed and responsiveness of our mobile/web application when browsing and making purchases?',
                  style: TextStyle(
                    color: Color(0xFF050404),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                RatingBar.builder(
                  initialRating: rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemSize: 35,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (newRating) {
                    setState(() {
                      rating = newRating;
                    });
                  },
                ),
                const SizedBox(height: 5),
                const Text(
                  'Explain why you give such rating?',
                  style: TextStyle(
                    color: Color(0xFF050404),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                FeedbackTextField(
                  controller: userInterfaceController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please provide an explanation for your rating.";
                    } else if (value.length < 5) {
                      return "Please provide a more detailed explanation.";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 15),
                const Text(
                  'Order Acceptance',
                  style: TextStyle(
                    color: Color(0xFF050404),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'How satisfied are you with the approval and speed of your transaction in the system?',
                  style: TextStyle(
                    color: Color(0xFF050404),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                RatingBar.builder(
                  initialRating: rating1,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemSize: 35,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (newRating) {
                    setState(() {
                      rating1 = newRating;
                    });
                  },
                ),
                const SizedBox(height: 5),
                const Text(
                  'Explain why you give such rating?',
                  style: TextStyle(
                    color: Color(0xFF050404),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                FeedbackTextField(
                  controller: easeofNavigationController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please provide an explanation for your rating.";
                    } else if (value.length < 5) {
                      return "Please provide a more detailed explanation.";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 15),
                const Text(
                  'Rider Performance',
                  style: TextStyle(
                    color: Color(0xFF050404),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'How satisfied are you with the communication skills and punctuality of the delivery rider in delivering your LPG order?',
                  style: TextStyle(
                    color: Color(0xFF050404),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                RatingBar.builder(
                  initialRating: rating2,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemSize: 35,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (newRating) {
                    setState(() {
                      rating2 = newRating;
                    });
                  },
                ),
                const SizedBox(height: 5),
                const Text(
                  'Explain why you give such rating?',
                  style: TextStyle(
                    color: Color(0xFF050404),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                FeedbackTextField(
                  controller: orderTimeController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please provide an explanation for your rating.";
                    } else if (value.length < 5) {
                      return "Please provide a more detailed explanation.";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 15),
                const Text(
                  'Overall Satisfaction',
                  style: TextStyle(
                    color: Color(0xFF050404),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'On a scale of 1 to 5, how would you describe your overall experience using our mobile/web application to purchase LPG products?',
                  style: TextStyle(
                    color: Color(0xFF050404),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                RatingBar.builder(
                  initialRating: rating3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemSize: 35,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (newRating) {
                    setState(() {
                      rating3 = newRating;
                    });
                  },
                ),
                const SizedBox(height: 5),
                const Text(
                  'Explain why you give such rating?',
                  style: TextStyle(
                    color: Color(0xFF050404),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                FeedbackTextField(
                  controller: riderandDeliveryserviceController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please provide an explanation for your rating.";
                    } else if (value.length < 5) {
                      return "Please provide a more detailed explanation.";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 15),
                const Text(
                  'Recommendation',
                  style: TextStyle(
                    color: Color(0xFF050404),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Overall, how likely are you to recommend our mobile/web application to others based on your experience using it for LPG purchases?',
                  style: TextStyle(
                    color: Color(0xFF050404),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                RatingBar.builder(
                  initialRating: rating4,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemSize: 35,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (newRating) {
                    setState(() {
                      rating4 = newRating;
                    });
                  },
                ),
                const SizedBox(height: 5),
                const Text(
                  'Explain why you give such rating?',
                  style: TextStyle(
                    color: Color(0xFF050404),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                FeedbackTextField(
                  controller: announcementsController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please provide an explanation for your rating.";
                    } else if (value.length < 5) {
                      return "Please provide a more detailed explanation.";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 15),
                CustomizedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      if (rating == 0.0 ||
                          rating1 == 0.0 ||
                          rating2 == 0.0 ||
                          rating3 == 0.0 ||
                          rating4 == 0.0) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Center(
                                child: Text(
                                  'Rating Error',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              content: const Text(
                                "Please ensure that you have selected and provided ratings for all categories.",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: const Color(0xFF050404)
                                        .withOpacity(0.8),
                                  ),
                                  child: const Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        submitFeedback(transaction);
                        print('Submitted Rating: $rating');
                      }
                    }
                  },
                  text: 'Submit',
                  height: 50,
                  width: 340,
                  fontz: 18,
                ),
              ],
            ),
          ),
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
    Map<String, dynamic> feedbackData = {
      "hasFeedback": 'true',
      "feedback": getFeedbackValues().join(', '),
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
