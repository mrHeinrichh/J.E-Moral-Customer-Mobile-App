import 'package:flutter/material.dart';

class PrivacyPolicyDialog extends StatefulWidget {
  @override
  _PrivacyPolicyDialogState createState() => _PrivacyPolicyDialogState();
}

class _PrivacyPolicyDialogState extends State<PrivacyPolicyDialog> {
  late ScrollController _scrollController;
  bool _isScrolledToBottom = false;
  bool _hasScrolledToBottomOnce = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        _isScrolledToBottom = true;
        _hasScrolledToBottomOnce = true;
      });
    } else {
      setState(() {
        _isScrolledToBottom = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Center(
        child: Text(
          "Terms and Conditions",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      content: SizedBox(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              const Text(
                "(Updated as of March 2024)",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              const Text(
                "*Please Read Carefully!*",
                style: TextStyle(
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // Icon(
              //   Icons.handshake,
              //   color: const Color(0xFFd41111).withOpacity(0.8),
              //   size: 100.0,
              // ),
              Image.network(
                "https://res.cloudinary.com/dzcjbziwt/image/upload/v1708533697/images/hefwwla0ozppgz5itlkt.png",
                width: 100,
                height: null,
              ),
              const SizedBox(height: 10),
              const Text(
                "Welcome to J.E. Moral LPG Products, Parts and Accessories E-Commerce Platform, a mobile application developed and owned by J.E. Moral LPG Dealer Store located at Barangay North Signal Village, Taguig City.",
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 10),
              const Text(
                "By accessing or using the Application, you agree to be bound by the following Terms and Conditions of Use, otherwise you may not access or use the application:",
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 10),
              const Text(
                " • To fully access the service of the system, we will collect your personal and receiver's information, including your name, email address, personal image, and any other personal information you provide to us.",
                style: TextStyle(
                  fontSize: 15.0,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 5),
              const Text(
                "• Administrator only has the right to edit your personal information, only by having your personal consent.",
                style: TextStyle(
                  fontSize: 15.0,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 5),
              const Text(
                "• Delivery drivers may also have access to your personal information, especially on the time of purchase for delivery.",
                style: TextStyle(
                  fontSize: 15.0,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 5),
              const Text(
                "• The system grants you an exclusive, non-transferable access of the application for your personal and non-commercial use as a customer. You may not use the application for any illegal or unauthorized purpose. You may not reproduce, distribute, modify, create derivative works of, or publicly display the applicaton without the prior written consent of the shop.",
                style: TextStyle(
                  fontSize: 15.0,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 5),
              const Text(
                "• You agree to use the application in a responsible and lawful manner. You agree not to use the application for any purpose that is illegal or unauthorized, or that could harm or damage the application or anyone else. You agree not to interfere with or disrupt the operation of the application. You agree not to use the application to transmit any material that is harmful, offensive, or illegal.",
                style: TextStyle(
                  fontSize: 15.0,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 5),
              const Text(
                "• You may place orders for LPG products, parts, and accessories through the application and agree to pay the prices listed for the products you order. You agree to pay for your orders only using the payment methods available through the application.",
                style: TextStyle(
                  fontSize: 15.0,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 5),
              const Text(
                "• You can only avail discount in the total price of your transaction by uploading your PWD/Senior Citizen ID subjected to approval by the administrator.",
                style: TextStyle(
                  fontSize: 15.0,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 5),
              const Text(
                "• Delivery time of products is followed on the operation hours of the shop, daily from 7:00 a.m. to 7:00 p.m. and only within the vicinity of Taguig City.",
                style: TextStyle(
                  fontSize: 15.0,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 5),
              const Text(
                "• Our shop's delivery drivers ship your orders to the address you provide with exclusion of delivery fee. Make sure to pickup the orders ontime (10-15 minutes grace period) for the delivery driver has the capability to reject your order provided with a valid reason on hand.",
                style: TextStyle(
                  fontSize: 15.0,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 5),
              const Text(
                "• The shop warrants that the products you purchase through the application will be free of defects and hazards in materials and workmanship. In case of a complaint, feel free to contact us. Your complaint is always subject for investigation for the shop may offer a replacement or refund.",
                style: TextStyle(
                  fontSize: 15.0,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 5),
              const Text(
                "• The shop shall not be liable for any damages of any kind arising from the use of the application or the products purchased through the application, including, but not limited to, direct, indirect, incidental, punitive, and consequential damages.",
                style: TextStyle(
                  fontSize: 15.0,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 5),
              const Text(
                "• In case of personal information and privacy threats. You can withdraw your consent to our use of your personal information at any time by informing the administrator using the chat section.",
                style: TextStyle(
                  fontSize: 15.0,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 5),
              const Text(
                "• The shop may update these terms from time to time. These terms constitute the entire agreement between you and the shop with respect to the use of the application and supersede all prior or contemporaneous communications, representations, or agreements, whether oral or written.",
                style: TextStyle(
                  fontSize: 15.0,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 15),
              const Text(
                "The store owner has the right to impose penalties to any unlawful and disobedience in proper usage of the application.",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                ),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: _hasScrolledToBottomOnce
              ? () {
                  Navigator.of(context).pop();
                }
              : null,
          child: Text(
            "OK",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _hasScrolledToBottomOnce
                  ? const Color(0xFF050404)
                  : const Color(0xFF050404).withOpacity(0.5),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
