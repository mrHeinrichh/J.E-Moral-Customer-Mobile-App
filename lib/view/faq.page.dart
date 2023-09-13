import 'package:flutter/material.dart';

class FaqPage extends StatefulWidget {
  @override
  _FaqPageState createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          child: const Card(
            elevation: 0,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'How can we help? ',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios, color: Color(0xFF5E738A)),
                    ],
                  ),
                  Divider(color: Colors.black),
                  Row(
                    children: [
                      Text(
                        'My Orders',
                        style: TextStyle(fontSize: 16),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios, color: Color(0xFF5E738A)),
                    ],
                  ),
                  Divider(color: Colors.black),
                  Row(
                    children: [
                      Text(
                        'Support request',
                        style: TextStyle(fontSize: 16),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios, color: Color(0xFF5E738A)),
                    ],
                  ),
                  Divider(color: Colors.black),
                  Row(
                    children: [
                      Text(
                        'My Account ',
                        style: TextStyle(fontSize: 16),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios, color: Color(0xFF5E738A)),
                    ],
                  ),
                  Divider(color: Colors.black),
                  Row(
                    children: [
                      Text(
                        'Orders and Payment ',
                        style: TextStyle(fontSize: 16),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios, color: Color(0xFF5E738A)),
                    ],
                  ),
                  Divider(color: Colors.black),
                  Row(
                    children: [
                      Text(
                        'Get help with my pay ',
                        style: TextStyle(fontSize: 16),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios, color: Color(0xFF5E738A)),
                    ],
                  ),
                  Divider(color: Colors.black),
                  Row(
                    children: [
                      Text(
                        'Safety Concerns ',
                        style: TextStyle(fontSize: 16),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios, color: Color(0xFF5E738A)),
                    ],
                  ),
                  Divider(color: Colors.black),
                  Row(
                    children: [
                      Text(
                        'How to become a Rider ',
                        style: TextStyle(fontSize: 16),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios, color: Color(0xFF5E738A)),
                    ],
                  ),
                  Divider(color: Colors.black),
                  Row(
                    children: [
                      Text(
                        'How to become a Retailer ',
                        style: TextStyle(fontSize: 16),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios, color: Color(0xFF5E738A)),
                    ],
                  ),
                  Divider(color: Colors.black),
                  Row(
                    children: [
                      Text(
                        'Selling and Billing ',
                        style: TextStyle(fontSize: 16),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios, color: Color(0xFF5E738A)),
                    ],
                  ),
                  Divider(color: Colors.black),
                  Row(
                    children: [
                      Text(
                        'Refilling ',
                        style: TextStyle(fontSize: 16),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios, color: Color(0xFF5E738A)),
                    ],
                  ),
                  Divider(color: Colors.black),
                  Row(
                    children: [
                      Text(
                        'How to order ',
                        style: TextStyle(fontSize: 16),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios, color: Color(0xFF5E738A)),
                    ],
                  ),
                  Divider(color: Colors.black),
                  Row(
                    children: [
                      Text(
                        'Get customer support ',
                        style: TextStyle(fontSize: 16),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios, color: Color(0xFF5E738A)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
