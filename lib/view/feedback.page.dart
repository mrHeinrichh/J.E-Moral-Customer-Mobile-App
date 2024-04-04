import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:customer_app/routes/app_routes.dart';
import 'package:customer_app/view/my_orders.page.dart';
import 'package:customer_app/widgets/custom_button.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController feedbackController = TextEditingController();

  late String selectedApplicationResponsiveness;
  late String selectedOrderAcceptance;
  late String selectedRiderPerformance;
  late String selectedOverallSatisfaction;
  late String selectedRecommendation;

  bool applicationResponsivenessValid = true;
  bool orderAcceptanceValid = true;
  bool riderPerformanceValid = true;
  bool overallSatisfactionValid = true;
  bool recommendationValid = true;

  @override
  void initState() {
    super.initState();
    selectedApplicationResponsiveness = '';
    selectedOrderAcceptance = '';
    selectedRiderPerformance = '';
    selectedOverallSatisfaction = '';
    selectedRecommendation = '';
  }

  @override
  Widget build(BuildContext context) {
    final Transaction transaction =
        ModalRoute.of(context)!.settings.arguments as Transaction;

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
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              buildRadioList(
                'Application Responsiveness',
                'Are you satisfied with the speed and responsiveness of our mobile/web application when browsing and making purchases?',
                [
                  'Absolutely Satisfied', // POSITIVE
                  'Moderately Satisfied', // NEUTRAL
                  'Somewhat Dissatisfied' // NEGATIVE
                ],
                selectedApplicationResponsiveness,
                (String? value) {
                  setState(() {
                    selectedApplicationResponsiveness = value ?? '';
                  });
                },
                applicationResponsivenessValid,
              ),
              buildRadioList(
                'Order Acceptance',
                'How was the approval and speed of your transaction in the system?',
                [
                  'Fast and Hasslefree',
                  'Experiencing Delays but Tolerable',
                  'Complicated and Inconvenient',
                ],
                selectedOrderAcceptance,
                (String? value) {
                  setState(() {
                    selectedOrderAcceptance = value ?? '';
                  });
                },
                orderAcceptanceValid,
              ),
              buildRadioList(
                'Rider Performance',
                'How was the communication skills and punctuality of the delivery rider in delivering your LPG order?',
                [
                  'Interactive and Arrived on time',
                  'Average expectation',
                  'Needs more training and arrived late',
                ],
                selectedRiderPerformance,
                (String? value) {
                  setState(() {
                    selectedRiderPerformance = value ?? '';
                  });
                },
                riderPerformanceValid,
              ),
              buildRadioList(
                'Overall Satisfaction',
                'How would you describe your overall experience using our mobile/web application to purchase LPG products?',
                [
                  'One of a kind, will reuse the app',
                  'Medium performance, needs improvement',
                  'Inconvenient, will stick to conventional purchasing method.',
                ],
                selectedOverallSatisfaction,
                (String? value) {
                  setState(() {
                    selectedOverallSatisfaction = value ?? '';
                  });
                },
                overallSatisfactionValid,
              ),
              buildRadioList(
                'Recommendation',
                'Overall, how likely are you to recommend our mobile/web application to others based on your experience using it for LPG purchases?',
                [
                  'Will highly recommend to others',
                  'Undecided to recommend to others',
                  'Unlikely to recommend to others',
                ],
                selectedRecommendation,
                (String? value) {
                  setState(() {
                    selectedRecommendation = value ?? '';
                  });
                },
                recommendationValid,
              ),
              CustomizedButton(
                onPressed: () {
                  setState(() {
                    applicationResponsivenessValid =
                        selectedApplicationResponsiveness.isNotEmpty;
                    orderAcceptanceValid = selectedOrderAcceptance.isNotEmpty;
                    riderPerformanceValid = selectedRiderPerformance.isNotEmpty;
                    overallSatisfactionValid =
                        selectedOverallSatisfaction.isNotEmpty;
                    recommendationValid = selectedRecommendation.isNotEmpty;
                  });

                  if (applicationResponsivenessValid &&
                      orderAcceptanceValid &&
                      riderPerformanceValid &&
                      overallSatisfactionValid &&
                      recommendationValid) {
                    submitFeedback(transaction);
                  }
                },
                text: 'Submit',
                height: 50,
                width: 340,
                fontz: 18,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRadioList(
    String title,
    String prompt,
    List<String> options,
    String selectedValue,
    void Function(String?) onChanged,
    bool isValid,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: isValid
                ? Colors.black
                : const Color(0xFFd41111).withOpacity(0.8),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Divider(),
        const SizedBox(height: 5),
        Text(
          prompt,
          style: TextStyle(
            color: isValid ? Colors.black : Colors.red,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 5),
        Wrap(
          children: options.map((option) {
            return GestureDetector(
              onTap: () {
                onChanged(option);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: selectedValue == option
                      ? const Color(0xFFd41111).withOpacity(0.8)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: selectedValue == option
                        ? Colors.transparent
                        : const Color(0xFF050404).withOpacity(0.6),
                    width: 1,
                  ),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    color: selectedValue == option
                        ? Colors.white
                        : const Color(0xFF050404),
                    fontSize: 16,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Future<void> submitFeedback(Transaction transaction) async {
    Map<String, dynamic> feedbackData = {
      "hasFeedback": 'true',
      "feedback": feedbackController.text,
      "applicationResponsiveness": selectedApplicationResponsiveness,
      "orderAcceptance": selectedOrderAcceptance,
      "riderPerformance": selectedRiderPerformance,
      "overallSatisfaction": selectedOverallSatisfaction,
      "recommendation": selectedRecommendation,
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
        print(feedbackData);
        print("Feedback submitted successfully");
        print(response.body);
        print(response.statusCode);
        Navigator.pushNamed(context, historyRoute);
      } else {
        print("Failed to submit feedback. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error: $error");
    }
  }
}
