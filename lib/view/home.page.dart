import 'package:customer_app/routes/app_routes.dart';
import 'package:customer_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  List<Map<String, dynamic>> sampleData = [
    {
      'category': 'Accessories',
      'products': [
        {
          'name': 'Ball Valve',
          'price': '---.--',
          'imageUrl':
              'https://raw.githubusercontent.com/mrHeinrichh/J.E-Moral-cdn/main/assets/png/accessories/gas-cylinder-home-propane-tank-w7GLlP4-600%201.png'
        },
        {
          'name': 'Lpg Hose',
          'price': '---.--',
          'imageUrl':
              'https://raw.githubusercontent.com/mrHeinrichh/J.E-Moral-cdn/main/assets/png/accessories/gas-cylinder-blue-Zelrn95-600%201.png'
        },
        {
          'name': 'Regulator',
          'price': '---.--',
          'imageUrl':
              'https://raw.githubusercontent.com/mrHeinrichh/J.E-Moral-cdn/main/assets/png/accessories/9764832_546062cf-143f-4750-a49b-344311c46413_700_700%201%20(1).png'
        },
      ],
    },
    {
      'category': 'Brandnew Tanks',
      'products': [
        {
          'name': 'Island Gas',
          'price': '---.--',
          'imageUrl':
              'https://raw.githubusercontent.com/mrHeinrichh/J.E-Moral-cdn/main/assets/png/brandnewtanks/Beverage-Elements-20-lb-propane-tank-steel-new%201%20(1).png'
        },
        {
          'name': 'Regasco',
          'price': '---.--',
          'imageUrl':
              'https://raw.githubusercontent.com/mrHeinrichh/J.E-Moral-cdn/main/assets/png/brandnewtanks/Beverage-Elements-20-lb-propane-tank-steel-new%201.png'
        },
      ],
    },
    {
      'category': 'Refill Tanks',
      'products': [
        {
          'name': 'Solane',
          'price': '---.--',
          'imageUrl':
              'https://raw.githubusercontent.com/mrHeinrichh/J.E-Moral-cdn/main/assets/png/refilltanks/Bg.png'
        },
        {
          'name': 'Phoenix',
          'price': '---.--',
          'imageUrl':
              'https://raw.githubusercontent.com/mrHeinrichh/J.E-Moral-cdn/main/assets/png/refilltanks/Beverage-Elements-20-lb-propane-tank-steel-new%201%20(2).png'
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            '"Fueling Your Life\nwith Clean Energy"', // Add your desired text here
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Color(0xFF232937), // Set the text color here
            ),
          ),
          Text("Applying for a Rider?"),
          CustomizedButton(
            onPressed: () {
              Navigator.pushNamed(context, appointmentRoute);
            },
            text: 'Book an Appointment',
            height: 40,
            width: 330,
            fontz: 15,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: sampleData.length,
              itemBuilder: (context, categoryIndex) {
                final category = sampleData[categoryIndex]['category'];
                final products = sampleData[categoryIndex]['products'];

                return Container(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          category, // Add your desired text here
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color(0xFF232937), // Set the text color here
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 180, // Adjust the height as needed
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: products.length,
                          itemBuilder: (context, productIndex) {
                            final product = products[productIndex];
                            return SizedBox(
                              width: 130,
                              child: Column(
                                children: [
                                  Card(
                                    child: Column(
                                      children: [
                                        Image.network(
                                          product[
                                              'imageUrl'], // URL of the image
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ],
                                    ),
                                  ),
                                  ListTile(
                                    title: Text(
                                      product['name'],
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Color(
                                            0xFF232937), // Set the text color here
                                      ),
                                    ),
                                    subtitle: Text(
                                      '\₱${product['price']}',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Color(
                                            0xFFE98500), // Set the text color here
                                      ),
                                    ),
                                    // Add more product information as needed
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
