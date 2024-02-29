import 'package:customer_app/routes/app_routes.dart';
import 'package:customer_app/view/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:customer_app/view/my_orders.page.dart';
import 'package:customer_app/widgets/custom_button.dart';

class AuthenticationPage extends StatefulWidget {
  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final GlobalKey<_AuthenticationPageState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final Transaction transaction =
        ModalRoute.of(context)!.settings.arguments as Transaction;

    String qrCodeData = transaction.id.toString();
    print(transaction.id);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'Authentication',
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
      body: RefreshIndicator(
        color: const Color(0xFF050404),
          strokeWidth: 2.5,
        onRefresh: () async {
          _key.currentState?.forceRebuild();
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              const SizedBox(height: 40),
              Visibility(
                visible: !transaction.completed,
                child: QrImageView(
                  data: qrCodeData,
                  version: QrVersions.auto,
                  size: 400,
                ),
              ),
              Visibility(
                visible: !transaction.completed,
                child: const Text(
                  'Show this QR code to Rider',
                  style: TextStyle(
                    color: Color(0xFF232937),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Visibility(
                visible: !transaction.completed,
                child: const Text(
                  'Show this QR code to Rider to confirm your Identity and to get the Orders',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF232937), fontSize: 15),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Visibility(
                visible: !transaction.completed,
                child: CustomizedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, mapsPage,
                        arguments: transaction);
                  },
                  text: 'View Live Tracking',
                  height: 50,
                  width: 340,
                  fontz: 15,
                ),
              ),
              Visibility(
                visible: transaction.completed,
                child: Column(
                  children: [
                    Image.network(
                      'https://raw.githubusercontent.com/mrHeinrichh/J.E-Moral-cdn/a3e79f6df6790060ff333407a565fa1a65b69125/assets/png/success.png',
                      width: 550.0,
                      height: null,
                    ),
                    const Text(
                      'Order Success',
                      style: TextStyle(
                        color: Color(0xFF232937),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Thank you for purchasing from us. To serve you better, you are required to answer the feedback survey form.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF232937), fontSize: 15),
                    ),
                    CustomizedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          feedBackPage,
                          arguments: transaction,
                        );
                      },
                      text: 'Feedback',
                      height: 50,
                      width: 340,
                      fontz: 15,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void forceRebuild() {
    setState(() {});
  }
}
