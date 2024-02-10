import 'package:customer_app/routes/app_routes.dart';
import 'package:customer_app/view/cart_provider.dart';
import 'package:customer_app/view/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:customer_app/widgets/custom_button.dart';
import 'package:customer_app/widgets/custom_timepicker.dart';
import 'package:customer_app/widgets/location_button.dart';
import 'package:customer_app/widgets/location_search.dart';
import 'package:customer_app/widgets/text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';

class SetDeliveryPage extends StatefulWidget {
  @override
  _SetDeliveryPageState createState() => _SetDeliveryPageState();
}

DateTime? selectedDateTime;
File? _image;

class _SetDeliveryPageState extends State<SetDeliveryPage> {
  String? selectedLocation;
  String? selectedPaymentMethod;
  bool isSeniorCheckboxVisible = false;

  String paymentMethodToString(String? paymentMethod) {
    switch (paymentMethod) {
      case 'COD':
        return 'COD';
      case 'GCASH':
        return 'GCASH';
      default:
        return '';
    }
  }

  bool? selectedAssemblyOption;

  List<String> searchResults = [];
  TextEditingController locationController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController houseNumberController = TextEditingController();

  List<Map<String, dynamic>> convertCartItems(List<CartItem> cartItems) {
    List<Map<String, dynamic>> itemsList = [];
    for (var cartItem in cartItems) {
      if (cartItem.isSelected) {
        itemsList.add({
          "productId":
              cartItem.id, // Use the name as a placeholder for the product ID
          "name": cartItem.name,
          "customerPrice": cartItem.price,

          "stock": cartItem.stock,
        });
      }
    }
    return itemsList;
  }

  Future<void> fetchLocationData(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }
    const apiKey = 'e8d77b2d8e7740c3b7727970dc8fc59e';
    final apiUrl =
        'https://api.geoapify.com/v1/geocode/autocomplete?text=$query&apiKey=$apiKey';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data.containsKey('features')) {
          final features = data['features'] as List<dynamic>;
          final results = features
              .map((feature) => feature['properties']['formatted'] as String)
              .toList();

          setState(() {
            searchResults = results;
          });
        } else {
          print('No "features" key in the API response.');
        }
      } else {
        print('API Request Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Map<String, dynamic>? discountIdImageResponse;
  Future<void> sendTransactionData() async {
    final apiUrl = 'https://lpg-api-06n8.onrender.com/api/v1/transactions';

    final CartProvider cartProvider =
        Provider.of<CartProvider>(context, listen: false);
    final List<Map<String, dynamic>> itemsList =
        convertCartItems(cartProvider.cartItems);
    double totalPrice = cartProvider.calculateTotalPrice();

    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    final String userId = userProvider.userId ?? '';

    if (userId == null || userId.isEmpty) {
      print('Error: User ID is null or empty.');
      return;
    }
    if (_image != null) {
      discountIdImageResponse = await uploadImageToServer(_image!);
      final String? discountIdImage =
          discountIdImageResponse?["data"]?[0]?["path"] as String?;
      // Use discountIdImage as needed...
    }
    final String? discountIdImage =
        discountIdImageResponse?["data"]?[0]?["path"] as String?;

    final Map<String, dynamic> requestData = {
      "deliveryLocation": locationController.text,
      "name": nameController.text,
      "contactNumber": contactNumberController.text,
      "houseLotBlk": houseNumberController.text,
      "paymentMethod": paymentMethodToString(selectedPaymentMethod),
      "assembly": selectedAssemblyOption.toString(),
      "deliveryDate": selectedDateTime.toString(),
      "barangay": selectedBarangay,
      "items": itemsList,
      "to": userId,
      "hasFeedback": "false",
      "feedback": "",
      "rating": "0",
      "pickupImages": "",
      "completionImages": "",
      "cancellationImages": "",
      "cancelReason": "",
      "pickedUp": "false",
      "cancelled": "false",
      "completed": "false",
      "type": "Delivery",
      "status": "Pending",
      "discountIdImage": discountIdImage,
    };
    print('isSeniorCheckboxVisible: $isSeniorCheckboxVisible');
    print('_image: $_image');
    print('requestData["discountIdImage"]: ${requestData["discountIdImage"]}');

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode(requestData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Transaction successful');
        print('Response: ${response.body}');
        Navigator.pushNamed(context, myOrdersPage);
      } else {
        print('Transaction failed with status code: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> showConfirmationDialog() async {
    BuildContext currentContext = context;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Delivery Location: ${locationController.text}'),
              Text('Name: ${nameController.text}'),
              Text('Contact Number: ${contactNumberController.text}'),
              Text('House#/Lot/Blk: ${houseNumberController.text}'),
              Text('Barangay $selectedBarangay'),
              Text('Scheduled Date and Time: ${selectedDateTime.toString()}'),
              Text(
                'Payment Method: ${paymentMethodToString(selectedPaymentMethod)}',
              ),
              Text(
                  'Needs to be assembled: ${selectedAssemblyOption.toString()}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await sendTransactionData();
                Provider.of<CartProvider>(currentContext, listen: false)
                    .clearCart();
                Navigator.pushNamed(currentContext, myOrdersPage);
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  bool validateFields() {
    if (locationController.text.isEmpty ||
        nameController.text.isEmpty ||
        contactNumberController.text.isEmpty ||
        houseNumberController.text.isEmpty ||
        selectedBarangay == null ||
        selectedPaymentMethod == null ||
        selectedAssemblyOption == null) {
      print("Please fill in all the required fields");
      return false;
    }

    return true;
  }

  List<String> fieldErrors = [];

  void clearFieldErrors() {
    fieldErrors.clear();
  }

  void displayFieldErrors() {
    if (locationController.text.isEmpty) {
      fieldErrors.add('Location is required.');
    }
    if (nameController.text.isEmpty) {
      fieldErrors.add('Receiver Name is required.');
    }
    if (contactNumberController.text.isEmpty) {
      fieldErrors.add('Contact Number is required.');
    }
    if (houseNumberController.text.isEmpty) {
      fieldErrors.add('House Number is required.');
    }
    if (selectedBarangay == null) {
      fieldErrors.add('Barangay is required.');
    }
    if (selectedPaymentMethod == null) {
      fieldErrors.add('Payment Method is required.');
    }
    if (selectedAssemblyOption == null) {
      fieldErrors.add('Assembly Option is required.');
    }

    showFieldErrorMessages();
  }

  void showFieldErrorMessages() {
    List<String> fieldErrors = [
      if (locationController.text.isEmpty) 'Location is required.',
      if (nameController.text.isEmpty) 'Receiver Name is required.',
      if (contactNumberController.text.isEmpty) 'Contact Number is required.',
      if (houseNumberController.text.isEmpty) 'House Number is required.',
      if (selectedBarangay == null) 'Barangay is required.',
      if (selectedPaymentMethod == null) 'Payment Method is required.',
      if (selectedAssemblyOption == null) 'Assembly Option is required.',
    ];
    if (fieldErrors.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            fieldErrors.join('\n'),
            style: TextStyle(color: Colors.white), // Set text color to white
          ),
          backgroundColor: Colors.red, // Set the background color to red
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  bool areThereNoErrors() {
    return fieldErrors.isEmpty;
  }

  bool deliveryNoticeShown = false;

  Future<void> confirmDialog() async {
    selectedDateTime = DateTime.now();
    BuildContext currentContext = context;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Delivery Location: ${locationController.text}'),
              Text('Name: ${nameController.text}'),
              Text('Contact Number: ${contactNumberController.text}'),
              Text('House#/Lot/Blk: ${houseNumberController.text}'),
              Text('Barangay $selectedBarangay'),
              Text('Scheduled Date and Time: ${selectedDateTime.toString()}'),
              Text(
                'Payment Method: ${paymentMethodToString(selectedPaymentMethod)}',
              ),
              Text(
                  'Needs to be assembled: ${selectedAssemblyOption.toString()}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await sendTransactionData();
                Provider.of<CartProvider>(currentContext, listen: false)
                    .clearCart();
                Navigator.pushNamed(currentContext, myOrdersPage);
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  String? selectedBarangay;
  final List<String> barangays = [
    'Bagumbayan',
    'Bambang',
    'Calzada Tipas',
    'Central Bicutan',
    'Central Signal Village',
    'Cembo',
    'Comembo',
    'East Rembo',
    'Fort Bonifacio',
    'Hagonoy',
    'Ibayo Tipas',
    'Katuparan',
    'Ligid Tipas',
    'Lower Bicutan',
    'Maharlika Village',
    'Napindan',
    'New Lower Bicutan',
    'North Daang Hari',
    'North Signal Village',
    'Palingon Tipas',
    'Pembo',
    'Pinagsama',
    'Pitogo',
    'Post Proper Northside',
    'Post Proper Southside',
    'Rizal',
    'San Miguel',
    'Santa Ana',
    'South Cembo',
    'South Daang Hari',
    'South Signal Village',
    'Tanyag',
    'Tuktukan',
    'Ususan',
    'Upper Bicutan',
    'Wawa',
    'West Rembo',
    'Western Bicutan'
  ];

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      // Call the function to upload the image to the server
      await uploadImageToServer(_image!);
    }
  }

  Future<Map<String, dynamic>?> uploadImageToServer(File imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://lpg-api-06n8.onrender.com/api/v1/upload/image'),
      );

      var fileStream = http.ByteStream(Stream.castFrom(imageFile.openRead()));
      var length = await imageFile.length();

      String fileExtension = imageFile.path.split('.').last.toLowerCase();
      var contentType = MediaType('image', 'png');

      Map<String, String> imageExtensions = {
        'png': 'png',
        'jpg': 'jpeg',
        'jpeg': 'jpeg',
        'gif': 'gif',
      };

      if (imageExtensions.containsKey(fileExtension)) {
        contentType = MediaType('image', imageExtensions[fileExtension]!);
      }

      var multipartFile = http.MultipartFile(
        'image',
        fileStream,
        length,
        filename: 'image.$fileExtension',
        contentType: contentType,
      );

      request.files.add(multipartFile);

      var response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final parsedResponse = json.decode(responseBody);
        print(parsedResponse);
        return parsedResponse;
      } else {
        print("Image upload failed with status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Image upload failed with error: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Set Delivery',
          style: TextStyle(color: Color(0xFF232937), fontSize: 24),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, dashboardRoute);
          },
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                const Text("Set Delivery Location"),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Column(
                    children: [
                      LocationSearchWidget(
                        locationController: locationController,
                        onLocationChanged: (query) {
                          fetchLocationData(query);
                        },
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(searchResults[index]),
                            onTap: () {
                              setState(() {
                                selectedLocation = searchResults[index];
                                locationController.text = searchResults[index];
                                searchResults = [];
                              });
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                LocationButtonWidget(
                  onLocationChanged: (String address) {
                    locationController.text = address;
                  },
                ),
                const SizedBox(height: 10),
                CustomTextField1(
                  labelText: 'Name',
                  hintText: 'Enter your Name',
                  controller: nameController,
                ),
                CustomTextField1(
                  labelText: 'Contact Number',
                  hintText: 'Enter your contact number',
                  controller: contactNumberController,
                ),
                CustomTextField1(
                  labelText: 'House#/Lot/Blk',
                  hintText: 'Enter your house number',
                  controller: houseNumberController,
                ),
                const SizedBox(height: 5),
                const Text("Choose Barangay"),
                const SizedBox(height: 5),
                SingleChildScrollView(
                  child: DropdownButtonFormField<String>(
                    value: selectedBarangay,
                    items: barangays.map((barangay) {
                      return DropdownMenuItem<String>(
                        value: barangay,
                        child: Text(barangay),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        selectedBarangay = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Select your Barangay',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text("Choose Payment Method"),
                ListTile(
                  title: const Text('Cash On Delivery'),
                  leading: Radio<String>(
                    value: 'COD',
                    groupValue: selectedPaymentMethod,
                    onChanged: (String? value) {
                      setState(() {
                        selectedPaymentMethod = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Gcash Payment'),
                  leading: Radio<String>(
                    value: 'GCASH',
                    groupValue: selectedPaymentMethod,
                    onChanged: (String? value) {
                      setState(() {
                        selectedPaymentMethod = value;
                      });
                    },
                  ),
                ),
                const Text("Needs to be assembled?"),
                ListTile(
                  title: const Text('Yes'),
                  leading: Radio<bool>(
                    value: true,
                    groupValue: selectedAssemblyOption,
                    onChanged: (bool? value) {
                      setState(() {
                        selectedAssemblyOption = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('No'),
                  leading: Radio<bool>(
                    value: false,
                    groupValue: selectedAssemblyOption,
                    onChanged: (bool? value) {
                      setState(() {
                        selectedAssemblyOption = value;
                      });
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isSeniorCheckboxVisible = !isSeniorCheckboxVisible;
                    });
                  },
                  child: const Text("Tap here if you are a Senior Citizen/PWD"),
                ),

                // Conditionally show the checkbox
                if (isSeniorCheckboxVisible)
                  Column(
                    children: [
                      _image == null
                          ? Container(
                              width: 300,
                              height: 300,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(
                                    10), // half of width/height for a circle
                              ),
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 50,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  8), // adjust the borderRadius as needed
                              child: Image.file(
                                _image!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                      TextButton(
                        onPressed: _pickImage,
                        child: const Text(
                          "Upload your Discount ID Image",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomizedButton(
                onPressed: () async {
                  clearFieldErrors();

                  displayFieldErrors();

                  if (areThereNoErrors()) {
                    final selectedDate = await showDateTimePicker(context);
                    if (selectedDate != null) {
                      setState(() {
                        selectedDateTime = selectedDate;
                        showConfirmationDialog();
                      });
                    }
                  }
                },
                text: 'Scheduled',
                height: 50,
                width: 160,
                fontz: 20,
              ),
              CustomizedButton(
                onPressed: () {
                  clearFieldErrors();
                  displayFieldErrors();

                  if (areThereNoErrors()) {
                    if (isWithinDeliveryHours()) {
                      confirmDialog();
                    } else {
                      if (!deliveryNoticeShown) {
                        showAlertDialog(context);
                        setState(() {
                          deliveryNoticeShown = true;
                        });
                      }
                    }
                  }
                },
                text: 'Deliver Now',
                height: 50,
                width: 160,
                fontz: 20,
                enabled: !deliveryNoticeShown,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void showAlertDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Delivery Hours Notice'),
        content: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Dear Valued Customer,',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'We sincerely apologize for any inconvenience.\n\n'
              'We regret to inform you that we cannot process your order at the moment.\n\n'
              'Our delivery service is only available between 7 am and 7 pm.\n\n'
              'To ensure a seamless and timely delivery experience, kindly place your order during our operational hours.\n\n'
              'Thank you for your understanding.',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Ok, I Understand'),
          ),
        ],
      );
    },
  );
}

bool isWithinDeliveryHours() {
  DateTime now = DateTime.now();
  int currentHour = now.hour;

  return currentHour >= 7 && currentHour < 19;
}
