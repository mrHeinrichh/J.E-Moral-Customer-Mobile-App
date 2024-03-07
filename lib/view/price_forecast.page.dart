import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ForecastPage extends StatefulWidget {
  @override
  _ForecastPageState createState() => _ForecastPageState();
}

class ResponseCard extends StatelessWidget {
  final PriceData priceData;
  final DateFormat dateTimeFormatter = DateFormat('MMMM d, y, hh:mm a');

  ResponseCard({required this.priceData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: ListTile(
          // title: Text(priceData.item),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Price: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                      "₱${NumberFormat.decimalPattern().format(double.parse((priceData.price ?? 0).toStringAsFixed(2)))}"),
                ],
              ),
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: "Reason: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: priceData.reason.toString(),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Updated at: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(dateTimeFormatter.format(priceData.updatedAt)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat.yMMMMd().format(date);
  }
}

Widget buildLineChart(
    List<PriceData> priceData, DateTime startDate, DateTime endDate) {
  List<FlSpot> spots = priceData.map((data) {
    double x = data.createdAt.difference(startDate).inDays.toDouble();
    return FlSpot(x, data.price);
  }).toList();

  return LineChart(
    LineChartData(
      gridData: const FlGridData(show: true),
      titlesData: const FlTitlesData(
        show: true,
      ),
      borderData: FlBorderData(show: true),
      minX: startDate.day.toDouble(),
      maxX: endDate.difference(startDate).inDays.toDouble(),
      minY: priceData.map((data) => data.price).reduce((a, b) => a < b ? a : b),
      maxY: priceData.map((data) => data.price).reduce((a, b) => a > b ? a : b),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: false,
          color: Colors.blue,
          dotData: const FlDotData(show: true),
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
      initialDate: DateTime(DateTime.now().year, DateTime.now().month, 1),
      firstDate: DateTime(2022),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFF050404).withOpacity(0.8),
              onPrimary: Colors.white,
            ),
            backgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != startDate) {
      setState(() {
        startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    DateTime currentDate = DateTime.now();
    DateTime lastDayOfMonth =
        DateTime(currentDate.year, currentDate.month + 1, 0);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: lastDayOfMonth,
      firstDate: DateTime(2022),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFF050404).withOpacity(0.8),
              onPrimary: Colors.white,
            ),
            backgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
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
          List<PriceData> fetchedData =
              data.map((item) => PriceData.fromJson(item)).toList();

          // Sort fetchedData based on updatedAt in descending order
          fetchedData.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

          setState(() {
            priceData = fetchedData;
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
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'Price Forecasting',
          style: TextStyle(
            color: const Color(0xFF050404).withOpacity(0.9),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.black,
            height: 0.2,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Item>?>(
        future: fetchItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.flickr(
                leftDotColor: const Color(0xFF050404).withOpacity(0.8),
                rightDotColor: const Color(0xFFd41111).withOpacity(0.8),
                size: 40,
              ),
            );
          } else if (snapshot.hasError || snapshot.data == null) {
            return Text('Error: ${snapshot.error ?? "Unable to fetch data"}');
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

            return RefreshIndicator(
              onRefresh: () async {
                await fetchItems();
                await fetchData();
              },
              color: const Color(0xFF050404),
              strokeWidth: 2.5,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 30,
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Select the Date:',
                            style: TextStyle(
                              fontSize: 14,
                              color: const Color(0xFF050404).withOpacity(0.8),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () => _selectStartDate(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: startDate != null
                                      ? Colors.white
                                      : const Color(0xFF050404)
                                          .withOpacity(0.8),
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                child: Container(
                                  width: 80,
                                  alignment: Alignment.center,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    'Start Date',
                                    style: TextStyle(
                                      color: startDate != null
                                          ? const Color(0xFF050404)
                                          : Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () => _selectEndDate(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: endDate != null
                                      ? Colors.white
                                      : const Color(0xFF050404)
                                          .withOpacity(0.8),
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                child: Container(
                                  width: 80,
                                  alignment: Alignment.center,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    'End Date',
                                    style: TextStyle(
                                      color: endDate != null
                                          ? const Color(0xFF050404)
                                          : Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Start Date: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                startDate != null
                                    ? DateFormat('MMMM d, y').format(startDate!)
                                    : 'Not selected',
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "End Date: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                endDate != null
                                    ? DateFormat('MMMM d, y').format(endDate!)
                                    : 'Not selected',
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: 300,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFF050404).withOpacity(0.8),
                                width: 1,
                              ),
                            ),
                            child: GestureDetector(
                              onTap: startDate != null && endDate != null
                                  ? null
                                  : () {
                                      showCustomOverlay(context,
                                          'Select the Start and End Date First!');
                                    },
                              child: DropdownButton<Item>(
                                isExpanded: true,
                                underline: const SizedBox(),
                                icon: const Icon(Icons.arrow_drop_down),
                                iconSize: 32,
                                elevation: 8,
                                alignment: Alignment.center,
                                items: dropdownItems,
                                onChanged: startDate != null && endDate != null
                                    ? (selectedItem) {
                                        setState(() {
                                          selectedDropdownItem = selectedItem;
                                        });

                                        if (selectedItem != null &&
                                            selectedItem.id == 'custom_date') {
                                          _selectStartDate(context);
                                        } else if (selectedItem != null) {
                                          fetchData();
                                        }
                                      }
                                    : null,
                                hint: Text(
                                  selectedDropdownItem?.name ??
                                      'Select the Product:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: const Color(0xFF050404)
                                        .withOpacity(0.8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (priceData.isNotEmpty)
                      Column(
                        children: [
                          SizedBox(
                            height: 300,
                            child:
                                buildLineChart(priceData, startDate!, endDate!),
                          ),
                          const SizedBox(height: 20),
                        ],
                      )
                    else
                      const Text('No data available.'),
                    ...priceData
                        .map((data) => ResponseCard(priceData: data))
                        .toList(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          }
        },
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
  final String reason;

  final double price;
  final String type;
  final bool deleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  final int v;

  PriceData({
    required this.id,
    required this.item,
    required this.reason,
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
      reason: json['reason'] ?? "",
      price: json['price'].toDouble(),
      type: json['type'],
      deleted: json['deleted'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'],
    );
  }
}

void showCustomOverlay(BuildContext context, String message) {
  final overlay = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).size.height * 0.5,
      left: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF050404).withOpacity(0.5),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Text(
            message,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  );

  Overlay.of(context)!.insert(overlay);

  Future.delayed(const Duration(seconds: 2), () {
    overlay.remove();
  });
}
