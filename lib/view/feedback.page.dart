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
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildRadioList(
                'Application Responsiveness',
                [
                  'Very satisfied',
                  'Satisfied',
                  'Neutral',
                  'Dissatisfied',
                  'Very dissatisfied'
                ],
                selectedApplicationResponsiveness,
                (String? value) {
                  setState(() {
                    selectedApplicationResponsiveness = value ?? '';
                  });
                },
              ),
              buildRadioList(
                'Order Acceptance',
                [
                  'Very satisfied',
                  'Satisfied',
                  'Neutral',
                  'Dissatisfied',
                  'Very dissatisfied'
                ],
                selectedOrderAcceptance,
                (String? value) {
                  setState(() {
                    selectedOrderAcceptance = value ?? '';
                  });
                },
              ),
              buildRadioList(
                'Rider Performance',
                [
                  'Very satisfied',
                  'Satisfied',
                  'Neutral',
                  'Dissatisfied',
                  'Very dissatisfied'
                ],
                selectedRiderPerformance,
                (String? value) {
                  setState(() {
                    selectedRiderPerformance = value ?? '';
                  });
                },
              ),
              buildRadioList(
                'Overall Satisfaction',
                [
                  'Very satisfied',
                  'Satisfied',
                  'Neutral',
                  'Dissatisfied',
                  'Very dissatisfied'
                ],
                selectedOverallSatisfaction,
                (String? value) {
                  setState(() {
                    selectedOverallSatisfaction = value ?? '';
                  });
                },
              ),
              buildRadioList(
                'Recommendation',
                [
                  'Very likely',
                  'Likely',
                  'Neutral',
                  'Unlikely',
                  'Very unlikely'
                ],
                selectedRecommendation,
                (String? value) {
                  setState(() {
                    selectedRecommendation = value ?? '';
                  });
                },
              ),
              SizedBox(height: 15),
              CustomizedButton(
                onPressed: () {
                  submitFeedback(transaction);
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
    );
  }

  Widget buildRadioList(
    String title,
    List<String> options,
    String selectedValue,
    void Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Color(0xFF050404),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        Text(
          'Select one:',
          style: TextStyle(
            color: Color(0xFF050404),
            fontSize: 14,
          ),
        ),
        SizedBox(height: 5),
        Wrap(
          children: options.map((option) {
            return Row(
              children: [
                Radio<String>(
                  value: option,
                  groupValue: selectedValue,
                  onChanged: onChanged,
                ),
                Text(option),
              ],
            );
          }).toList(),
        ),
        SizedBox(height: 15),
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
