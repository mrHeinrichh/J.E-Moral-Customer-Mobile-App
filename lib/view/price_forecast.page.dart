import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ForecastPage extends StatefulWidget {
  @override
  _ForecastPageState createState() => _ForecastPageState();
}

Widget buildLineChart(
    List<PriceData> priceData, DateTime startDate, DateTime endDate) {
  List<FlSpot> spots = priceData.map((data) {
    // Calculate days since the start date
    double x = data.createdAt.difference(startDate).inDays.toDouble();
    return FlSpot(x, data.price);
  }).toList();

  return LineChart(
    LineChartData(
      gridData: FlGridData(show: true),
      titlesData: FlTitlesData(
        show: true,
      ),
      borderData: FlBorderData(show: true),
      minX: 0, // Start from 0 days
      maxX: endDate
          .difference(startDate)
          .inDays
          .toDouble(), // Set to the difference in days
      minY: priceData.map((data) => data.price).reduce((a, b) => a < b ? a : b),
      maxY: priceData.map((data) => data.price).reduce((a, b) => a > b ? a : b),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: false,
          color: Colors.blue,
          dotData: FlDotData(show: true),
          belowBarData: BarAreaData(show: true),
        ),
      ],
    ),
  );
}

class _ForecastPageState extends State<ForecastPage> {
  DateTime? startDate;
  DateTime? endDate;
  Item? selectedDropdownItem;
  List<PriceData> priceData = [];

  Future<List<Item>> fetchItems() async {
    try {
      final response = await http
          .get(Uri.parse('https://lpg-api-06n8.onrender.com/api/v1/items/'));

      if (response.statusCode == 200) {
        Map<String, dynamic>? responseData = json.decode(response.body);

        if (responseData != null && responseData.containsKey('data')) {
          List<dynamic> data = responseData['data'];

          List<Item> items = data.map((item) => Item.fromJson(item)).toList();
          return items;
        } else {
          print(
              'Invalid data format: "data" key not found in response: ${responseData.toString()}');
          throw Exception('Invalid data format');
        }
      } else {
        print('Failed to load items. Status code: ${response.statusCode}');
        throw Exception('Failed to load items');
      }
    } catch (error) {
      print('Error: $error');
      throw Exception('Error: $error');
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != startDate) {
      setState(() {
        startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != endDate) {
      setState(() {
        endDate = picked;
      });
    }
  }

  Future<void> fetchData() async {
    if (selectedDropdownItem != null && startDate != null && endDate != null) {
      final response = await http.get(
        Uri.parse(
          'https://lpg-api-06n8.onrender.com/api/v1/dashboard/prices?start=${startDate!.toIso8601String()}&end=${endDate!.toIso8601String()}&item=${selectedDropdownItem!.id}',
        ),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic>? responseData = json.decode(response.body);

        if (responseData != null &&
            responseData.containsKey('data') &&
            responseData['data'] is List) {
          List<dynamic> data = responseData['data'];
          setState(() {
            priceData = data.map((item) => PriceData.fromJson(item)).toList();
          });
        }
      } else {
        print(
            'Failed to fetch price data. Status code: ${response.statusCode}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Price Forecast Page',
          style: TextStyle(color: Color(0xFF232937), fontSize: 24),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FutureBuilder<List<Item>?>(
            future: fetchItems(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError || snapshot.data == null) {
                return Text(
                    'Error: ${snapshot.error ?? "Unable to fetch data"}');
              } else {
                List<Item> items = snapshot.data!;
                List<DropdownMenuItem<Item>> dropdownItems = items
                    .map(
                      (item) => DropdownMenuItem<Item>(
                        value: item,
                        child: Text(item.name ?? ''),
                      ),
                    )
                    .toList();

                if (startDate != null && endDate != null) {
                  dropdownItems.add(
                    DropdownMenuItem<Item>(
                      value: Item(id: 'custom_date', name: 'Custom Date'),
                      child: Text(
                        'Start: ${startDate?.toLocal()} - End: ${endDate?.toLocal()}',
                      ),
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Column(
                    children: [
                      Container(
                        width: 300,
                        child: DropdownButton<Item>(
                          isExpanded: true,
                          items: dropdownItems,
                          onChanged: (selectedItem) {
                            setState(() {
                              selectedDropdownItem = selectedItem;
                            });

                            if (selectedItem != null &&
                                selectedItem.id == 'custom_date') {
                              _selectStartDate(context);
                            } else if (selectedItem != null) {
                              fetchData();
                            }
                          },
                          hint: Text(
                              selectedDropdownItem?.name ?? 'Select an item'),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () => _selectStartDate(context),
                            child: Text('Select Start Date'),
                          ),
                          ElevatedButton(
                            onPressed: () => _selectEndDate(context),
                            child: Text('Select End Date'),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Start Date: ${startDate?.toLocal().toString() ?? 'Not selected'}',
                      ),
                      Text(
                        'End Date: ${endDate?.toLocal().toString() ?? 'Not selected'}',
                      ),
                    ],
                  ),
                );
              }
            },
          ),
          if (priceData.isNotEmpty)
            Container(
              // Wrap your LineChart with a Container
              height: 300, // Set a fixed height or adjust based on your needs
              child: buildLineChart(priceData, startDate!, endDate!),
            )
          else
            Text('No data available'),
        ],
      ),
    );
  }
}

class Item {
  final String id;
  final String name;

  Item({required this.id, required this.name});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['_id'],
      name: json['name'],
    );
  }
}

class PriceData {
  final String id;
  final String item;
  final double price;
  final String type;
  final bool deleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  PriceData({
    required this.id,
    required this.item,
    required this.price,
    required this.type,
    required this.deleted,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory PriceData.fromJson(Map<String, dynamic> json) {
    return PriceData(
      id: json['_id'],
      item: json['item'],
      price: json['price'].toDouble(),
      type: json['type'],
      deleted: json['deleted'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'],
    );
  }
}
