import 'package:customer_app/routes/app_routes.dart';
import 'package:customer_app/widgets/login_button.dart';
import 'package:customer_app/widgets/signup_button.dart';
import 'package:flutter/material.dart';

class OnBoardingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFe7e0e0),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 60.0),
                Image.network(
                  "https://res.cloudinary.com/dzcjbziwt/image/upload/v1708533697/images/hefwwla0ozppgz5itlkt.png",
                  width: 550.0,
                  height: null,
                ),
                const SizedBox(height: 50.0),
                const Center(
                  child: Text(
                    'Fueling Your Life with Clean Energy',
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 70.0),
                Column(
                  children: [
                    LoginButton(
                      onPressed: () {
                        Navigator.pushNamed(context, loginRoute);
                      },
                    ),
                    const SizedBox(height: 5),
                    SignupButton(
                      onPressed: () {
                        Navigator.pushNamed(context, signupRoute);
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
