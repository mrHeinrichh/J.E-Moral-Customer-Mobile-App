import 'package:flutter/material.dart';

class PrivacyPolicyDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Terms and Conditions of Use\n (PLEASE READ CAREFULLY)",
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center, // Center the text
      ),
      content: Container(
        height: 400, // Set a fixed height for the content
        child: SingleChildScrollView(
          child: Column(
            children: [
              Icon(
                Icons
                    .handshake, // You can change this to any other icon you prefer
                color: Colors.green, // Change the icon color as needed
                size: 100.0, // Change the icon size as needed
              ),
              // SizedBox(
              //     height:
              //         16.0), // Add some vertical spacing between the icon and text

              // Your text widgets go here...
              Text(
                "Welcome to J.E. Moral LPG Products, Parts and Accessories E-Commerce Platform, a mobile application developed and owned by J.E. Moral LPG Dealer Store located at Barangay North Signal Village, Taguig City. \n\nBy accessing or using the Application, you agree to be bound by the following Terms and Conditions of Use, otherwise you may not access or use the application:",
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),

              Text(
                "\n•To full access the service of the system, we will collect your personal information, including your name, email address, personal image, and any other personal information you provide to us.",
                style: TextStyle(
                  fontSize: 15.0,
                ),
                textAlign: TextAlign.justify,
              ),
              Text(
                "\n•Administrator/s only have the right to edit your personal information as a retailer, only by having your personal consent.",
                style: TextStyle(
                  fontSize: 15.0,
                ),
                textAlign: TextAlign.justify,
              ),

              Text(
                "\n•Delivery riders may also have access to your personal information, especially on the time of purchase for delivery.",
                style: TextStyle(
                  fontSize: 15.0,
                ),
                textAlign: TextAlign.justify,
              ),
              Text(
                "\n•The shop grants you a non-exclusive, non-transferable, revocable license to use the application for your personal, non-commercial use as a Retailer. You may not use the application for any illegal or unauthorized purpose. You may not reproduce, distribute, modify, create derivative works of, or publicly display the applicaton without the prior written consent of the shop.",
                style: TextStyle(
                  fontSize: 15.0,
                ),
                textAlign: TextAlign.justify,
              ),
              Text(
                "\n•You agree to use the application in a responsible and lawful manner. You agree not to use the application for any purpose that is illegal or unauthorized, or that could harm or damage the application or anyone else. You agree not to interfere with or disrupt the operation of the application. You agree not to use the application to transmit any material that is harmful, offensive, or illegal.",
                style: TextStyle(
                  fontSize: 15.0,
                ),
                textAlign: TextAlign.justify,
              ),
              Text(
                "\n•You may place orders for LPG products, parts, and accessories through the application. You agree to pay the prices listed for the products you order. You may pay for your orders using the payment methods available through the application.",
                style: TextStyle(
                  fontSize: 15.0,
                ),
                textAlign: TextAlign.justify,
              ),
              Text(
                "\n•The shop will ship your orders to the address you provide. You agree to pay the shipping costs for your orders.",
                style: TextStyle(
                  fontSize: 15.0,
                ),
                textAlign: TextAlign.justify,
              ),
              Text(
                "\n•The shop warrants that the products you purchase through the application will be free of defects and hazards in materials and workmanship. In case of a complaint, feel free to contact us. Your complaint is subject for investigation for the shop may offer a replacement or refund.",
                style: TextStyle(
                  fontSize: 15.0,
                ),
                textAlign: TextAlign.justify,
              ),
              Text(
                "\n•The shop shall not be liable for any damages of any kind arising from the use of the application or the products purchased through the application, including, but not limited to, direct, indirect, incidental, punitive, and consequential damages.",
                style: TextStyle(
                  fontSize: 15.0,
                ),
                textAlign: TextAlign.justify,
              ),
              Text(
                "\n•In case of personal information and privacy threats. You can withdraw your consent to our use of your personal information at any time.",
                style: TextStyle(
                  fontSize: 15.0,
                ),
                textAlign: TextAlign.justify,
              ),
              Text(
                "\nThe shop may update these terms from time to time. These terms constitute the entire agreement between you and the shop with respect to the use of the application and supersede all prior or contemporaneous communications, representations, or agreements, whether oral or written.",
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
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Close"),
        ),
      ],
    );
  }
}
