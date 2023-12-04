import 'package:flutter/material.dart';

class FaqPage extends StatefulWidget {
  @override
  _FaqPageState createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  List<String> questions = [
    'How Can We help?',
    'How Can We Access Your Application?',
    'How to Apply as a Rider?',
    'How to Order?',
    'Mode of Payment',
    'Can I track my order?',
    'Do you Offer Warranty on Products?',
    'How can I Contact Customer Support?',
    // 'Support Request',
    // 'My Account',
    // 'Orders and Payment',
    // 'Get Help With My Pay',
    // 'Safety Concerns',
    // 'How to Become a Retailer',
    // 'Selling and Billing',
    // 'Refilling',
    // 'How to Order',
    // 'Get Customer Support',
  ];

  List<String> answers = [
    'We, the J.E. Moral LPG Store is committed to help our growing clients by giving them a platform to access our products anytime and anywhere to ease their purchasing time and efforts.',
    'To access the full potential of the application according to your role, just simply register or create an account, supply the necessary requirements, and wait for the confirmation of your account. Discounts awaits for Senior Citizens and PWD. Just provide your Identification Cards upon registering.',
    'To apply as a Rider of our shop, just click "Book an Appointment" below "Apply as a Rider?" question in the landing page, supply the appointment information needed, and wait for the approval from the administrator confirming your schedule.',
    'For you to order in the application, just search or click to your desired products, add it to your cart, review, and proceed to checkout by supplying the necessary delivery information provided.',
    'The application offers you a Cash on Delivery and contactless payment such as GCash.',
    'Yes, you can track your order once it is shipped. Just go to History -> View Orders -> Track Order.',
    'Yes, we do offer warranty on our products especially the LPG parts and accessories items. Warranty covers replacement of items nor refund if there is no more stocks available, but warranty complaints are always subject for thorough investigations. ',
    'You can reach out to us through the "Contact Us" page on the website or by using the live chat option in the application for real-time support.',
    // 'Answer 6',
    // 'Answer 7',
    // 'Answer 8',
    // 'Answer 9',
    // 'Answer 10',
    // 'Answer 11',
    // 'Answer 12',
    // 'Answer 13',
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
