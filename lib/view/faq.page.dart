import 'package:flutter/material.dart';

class FaqPage extends StatefulWidget {
  @override
  _FaqPageState createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  List<String> questions = [
    'How can we help?',
    'My Orders',
    'Support request',
    'My Account',
    'Orders and Payment',
    'Get help with my pay',
    'Safety Concerns',
    'How to become a Rider',
    'How to become a Retailer',
    'Selling and Billing',
    'Refilling',
    'How to order',
    'Get customer support',
  ];

  List<String> answers = [
    'We, the J.E. Moral LPG Store is committed to help our growing clients by giving them a platform to access our products anytime and anywhere to ease their purchasing time and efforts.',
    'Answer 2',
    'Answer 3',
    'Answer 4',
    'Answer 5',
    'Answer 6',
    'Answer 7',
    'Answer 8',
    'Answer 9',
    'Answer 10',
    'Answer 11',
    'Answer 12',
    'Answer 13',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Padding(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Text(
            'FAQs',
            style: TextStyle(color: Color(0xFF232937), fontSize: 24),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Card(
            elevation: 0,
            child: ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  title: Text(
                    questions[index],
                    style: TextStyle(fontSize: 16),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            answers[index],
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
