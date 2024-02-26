import 'package:customer_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:customer_app/routes/app_routes.dart';

class ApplyRiderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300,
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Fueling Your Life with Clean Energy',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                    color: const Color(0xFF050404).withOpacity(0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Applying for a Delivery Driver?',
                  style: TextStyle(
                    color: const Color(0xFF050404).withOpacity(0.8),
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                AppointmentButton(
                  onPressed: () {
                    Navigator.pushNamed(context, appointmentRoute);
                  },
                  text: 'Book an Appointment',
                  height: 30,
                  width: 210,
                  fontz: 12,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PriceForecastCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300,
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Price',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 26,
                            color: const Color(0xFF050404).withOpacity(0.8),
                          ),
                        ),
                        Text(
                          'Forecasting',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 26,
                            color: const Color(0xFF050404).withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Image.network(
                      "https://res.cloudinary.com/dzcjbziwt/image/upload/v1708968302/images/la25qf8wpfkejrdqfohk.png",
                      width: 80,
                      height: 80,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                AppointmentButton(
                  onPressed: () {
                    Navigator.pushNamed(context, forecastPage);
                  },
                  text: 'View Updated Prices',
                  height: 30,
                  width: 210,
                  fontz: 12,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
