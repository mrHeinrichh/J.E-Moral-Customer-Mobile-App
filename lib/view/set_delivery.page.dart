import 'dart:async';
import 'package:customer_app/routes/app_routes.dart';
import 'package:customer_app/view/cart_provider.dart';
import 'package:customer_app/view/user_provider.dart';
import 'package:customer_app/widgets/custom_image_upload.dart';
import 'package:customer_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:customer_app/widgets/custom_button.dart';
import 'package:customer_app/widgets/location_button.dart';
import 'package:customer_app/widgets/location_search.dart';
import 'package:customer_app/widgets/text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';

class SetDeliveryPage extends StatefulWidget {
  @override
  _SetDeliveryPageState createState() => _SetDeliveryPageState();
}

class _SetDeliveryPageState extends State<SetDeliveryPage> {
  final formKey = GlobalKey<FormState>();
  final imageStreamController = StreamController<File?>.broadcast();
  bool? selectedInstalledOption;

  DateTime? selectedDateTime;
  File? _image;

  String? selectedLocation;
  bool isSeniorCheckboxVisible = false;

  List<String> searchResults = [];
  TextEditingController locationController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController houseNumberController = TextEditingController();

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

  Future<void> _takeImage() async {
    final imagePickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (imagePickedFile != null) {
      final imageFile = File(imagePickedFile.path);
      imageStreamController.sink.add(imageFile);

      setState(() {
        _image = imageFile;
      });
    }
  }

  Future<void> _pickImage() async {
    final imagePickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (imagePickedFile != null) {
      final imageFile = File(imagePickedFile.path);
      imageStreamController.sink.add(imageFile);

      setState(() {
        _image = imageFile;
      });
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
        print("Image uploaded successfully: $responseBody");

        final parsedResponse = json.decode(responseBody);

        if (parsedResponse.containsKey('data')) {
          final List<dynamic> data = parsedResponse['data'];

          if (data.isNotEmpty && data[0].containsKey('path')) {
            final profileImageUrl = data[0]['path'];
            print("Image URL: $profileImageUrl");
            return {'url': profileImageUrl};
          } else {
            print("Invalid response format: $parsedResponse");
            return null;
          }
        } else {
          print("Invalid response format: $parsedResponse");
          return null;
        }
      } else {
        print(
            "Profile Image upload failed with status code: ${response.statusCode}");
        final responseBody = await response.stream.bytesToString();
        print("Response body: $responseBody");
        return null;
      }
    } catch (e) {
      print("Profile Image upload failed with error: $e");
      return null;
    }
  }

  List<Map<String, dynamic>> convertCartItems(List<CartItem> cartItems) {
    List<Map<String, dynamic>> itemsList = [];
    for (var cartItem in cartItems) {
      if (cartItem.isSelected) {
        itemsList.add({
          "_id": cartItem.id,
          "name": cartItem.name,
          "category": cartItem.category,
          "description": cartItem.description,
          "weight": cartItem.weight,
          "stock": cartItem.stock,
          "customerPrice": cartItem.customerPrice,
          // "retailerPrice": cartItem.retailerPrice,
          "image": cartItem.imageUrl,
          "type": cartItem.itemType,
          "quantity": cartItem.quantity,
          // "totalPrice": cartItem.customerPrice * cartItem.stock,
        });
      }
    }
    return itemsList;
  }

  Future<void> sendTransactionData() async {
    final apiUrl = 'https://lpg-api-06n8.onrender.com/api/v1/transactions';

    final CartProvider cartProvider =
        Provider.of<CartProvider>(context, listen: false);
    final List<Map<String, dynamic>> itemsList =
        convertCartItems(cartProvider.cartItems);
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    final String userId = userProvider.userId ?? '';

    if (userId == null || userId.isEmpty) {
      print('Error: User ID is null or empty.');
      return;
    }

    try {
      Map<String, dynamic>? discountedUploadResponse;

      if (_image != null) {
        discountedUploadResponse = await uploadImageToServer(_image!);
        print(
            "Upload Response for Discounted Image: $discountedUploadResponse");

        if (discountedUploadResponse != null) {
          print("Discounted Image URL: ${discountedUploadResponse["url"]}");
        } else {
          print("Discounted Image upload failed");
          return;
        }
      }

      final Map<String, dynamic> requestData = {
        "deliveryLocation": locationController.text,
        "houseLotBlk": houseNumberController.text,
        "paymentMethod": "COD",
        "status": "Pending",
        "installed": selectedInstalledOption.toString(),
        "deliveryDate": selectedDateTime.toString(),
        "barangay": selectedBarangay,
        "to": userId,
        "feedback": "",
        "rating": "0",
        "pickupImages": "",
        "completionImages": "",
        "cancellationImages": "",
        "cancelReason": "",
        "pickedUp": "false",
        "cancelled": "false",
        "hasFeedback": "false",
        // "long": "",
        // "lat": "",
        // "deleted": "false",
        "name": nameController.text,
        "contactNumber": contactNumberController.text,
        "items": itemsList,
        "discounted": discountedUploadResponse != null ? true : false,
        "completed": "false",
        "discountIdImage": discountedUploadResponse != null
            ? discountedUploadResponse["url"]
            : "",
        "__t": "Delivery",
        //
        "priceType": "Customer",
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode(requestData),
        headers: {'Content-Type': 'application/json'},
      );
      print(json.encode(requestData));

      if (response.statusCode == 200) {
        print('Transaction successful');
        print('Response: ${response.body}');

        locationController.clear();
        houseNumberController.clear();
        nameController.clear();
        contactNumberController.clear();
        _image = null;

        Navigator.pushNamed(context, myOrdersPage);
      } else {
        print('Transaction failed with status code: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'Delivery Information',
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
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    LocationSearchWidget(
                      controller: locationController,
                      labelText: 'Delivery Location',
                      hintText: 'Enter the Delivery Location',
                      onLocationChanged: (query) {
                        fetchLocationData(query);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter the Delivery Location";
                        } else {
                          return null;
                        }
                      },
                      child: ListView.builder(
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
                    ),
                    const SizedBox(height: 10),
                    LocationButtonWidget(
                      onLocationChanged: (String address) {
                        locationController.text = address;
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      labelText: 'Receiver Name',
                      hintText: 'Enter the Receiver Name',
                      controller: nameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter the Receiver Name";
                        } else {
                          return null;
                        }
                      },
                    ),
                    CustomTextField(
                      labelText: 'Receiver Mobile Number',
                      hintText: 'Enter the Receiver Mobile Number',
                      controller: contactNumberController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter the Receiver Mobile Number";
                        } else if (value.length != 11) {
                          return "Please Enter the Correct Mobile Number";
                        } else if (!value.startsWith('09')) {
                          return "Please Enter the Correct Mobile Number";
                        } else {
                          return null;
                        }
                      },
                    ),
                    CustomTextField(
                      labelText: 'Receiver House #/Lot/Blk',
                      hintText: 'Enter Receiver House Information',
                      controller: houseNumberController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter the Receiver House Information";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 5),
                    DropdownButtonFormField<String>(
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
                      decoration: InputDecoration(
                        labelText: 'Barangay',
                        labelStyle: TextStyle(
                          color: const Color(0xFF050404).withOpacity(0.7),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xFF050404)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Select the Barangay";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF050404)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: Text(
                              "Needs to be Installed:",
                              style: TextStyle(
                                color: Color(0xFF050404),
                              ),
                            ),
                          ),
                          FormField<bool>(
                            validator: (value) {
                              if (value == null) {
                                return 'Please make a Selection';
                              }
                              return null;
                            },
                            builder: (state) {
                              return Column(
                                children: [
                                  ListTile(
                                    leading: Radio<bool>(
                                      value: true,
                                      groupValue: selectedInstalledOption,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          selectedInstalledOption = value!;
                                        });
                                        state.didChange(value);
                                      },
                                      activeColor: const Color(0xFF050404),
                                    ),
                                    title: const Text('Yes'),
                                  ),
                                  ListTile(
                                    leading: Radio<bool>(
                                      value: false,
                                      groupValue: selectedInstalledOption,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          selectedInstalledOption = value!;
                                        });
                                        state.didChange(value);
                                      },
                                      activeColor: const Color(0xFF050404),
                                    ),
                                    title: const Text('No'),
                                  ),
                                  if (state.errorText != null) ...[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      child: Text(
                                        state.errorText!,
                                        style:
                                            const TextStyle(color: Colors.red),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                  ],
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isSeniorCheckboxVisible = !isSeniorCheckboxVisible;
                        });
                      },
                      child: const Text(
                        "Avail Discount for PWD/Senior Citizen",
                      ),
                    ),
                    if (isSeniorCheckboxVisible)
                      Column(
                        children: [
                          const SizedBox(height: 10),
                          StreamBuilder<File?>(
                            stream: imageStreamController.stream,
                            builder: (context, snapshot) {
                              return Column(
                                children: [
                                  Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 200,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF050404)
                                              .withOpacity(0.4),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        foregroundDecoration: snapshot.data !=
                                                null
                                            ? BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                image: DecorationImage(
                                                  image:
                                                      FileImage(snapshot.data!),
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                            : null,
                                        child: snapshot.data == null
                                            ? const Icon(
                                                Icons.image,
                                                color: Colors.white,
                                                size: 50,
                                              )
                                            : null,
                                      ),
                                      if (snapshot.data != null)
                                        GestureDetector(
                                          onTap: () {
                                            imageStreamController.add(null);
                                            _image = null;
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.all(8),
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFd41111)
                                                  .withOpacity(0.8),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  ImageUploader(
                                    takeImage: _takeImage,
                                    pickImage: _pickImage,
                                    buttonText: "Upload your Discount Id Image",
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomizedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        final selectedDate = await showDateTimePicker(context);
                        if (selectedDate != null) {
                          final selectedTime =
                              await showCustomTimePicker(context);
                          if (selectedTime != null) {
                            print('Selected Date: $selectedDate');
                            print('Selected Time: $selectedTime');

                            const startTime = TimeOfDay(hour: 7, minute: 0);
                            const endTime = TimeOfDay(hour: 19, minute: 0);
                            if (selectedTime.hour >= startTime.hour &&
                                selectedTime.hour <= endTime.hour) {
                              setState(() {
                                selectedDateTime = DateTime(
                                  selectedDate.year,
                                  selectedDate.month,
                                  selectedDate.day,
                                  selectedTime.hour,
                                  selectedTime.minute,
                                );
                                print('Selected DateTime: $selectedDateTime');
                                confirmDialog();
                              });
                            } else {
                              // NONSENSE
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    title: const Center(
                                      child: Text(
                                        'Invalid Time',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    content: const Text(
                                      'Please select a time between 7 AM and 7 PM for delivery.',
                                      textAlign: TextAlign.center,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        style: TextButton.styleFrom(
                                          foregroundColor:
                                              const Color(0xFF050404)
                                                  .withOpacity(0.8),
                                        ),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          }
                        }
                      }
                    },
                    text: 'Scheduled',
                    height: 50,
                    width: 170,
                    fontz: 20,
                  ),
                  CustomizedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        final currentTime = DateTime.now();
                        final startTime = DateTime(currentTime.year,
                            currentTime.month, currentTime.day, 7);
                        final endTime = DateTime(currentTime.year,
                            currentTime.month, currentTime.day, 19);

                        if (currentTime.isAfter(startTime) &&
                            currentTime.isBefore(endTime)) {
                          selectedDateTime = DateTime.now();
                          confirmDialog();
                        } else {
                          // NONSENSE
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                title: const Center(
                                  child: Text(
                                    'Delivery Hours Notice',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                content: const Text(
                                  'Sorry, your order cannot be delivered at the moment. Our delivery hours are from 7 AM to 7 PM daily.',
                                  textAlign: TextAlign.center,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: const Color(0xFF050404)
                                          .withOpacity(0.8),
                                    ),
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                    },
                    text: 'Deliver Now',
                    height: 50,
                    width: 170,
                    fontz: 20,
                    enabled: true,
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Future<DateTime?> showDateTimePicker(BuildContext context) {
    DateTime initialDate = DateTime.now().add(const Duration(days: 1));

    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: initialDate,
      lastDate: initialDate.add(const Duration(days: 365)),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFF050404).withOpacity(0.8),
            colorScheme: ColorScheme.light(
              primary: const Color(0xFF050404).withOpacity(0.8),
            ),
          ),
          child: child!,
        );
      },
    );
  }

  Future<TimeOfDay?> showCustomTimePicker(BuildContext context) {
    TimeOfDay initialTime = const TimeOfDay(hour: 9, minute: 0);

    return showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFF050404).withOpacity(0.8),
            colorScheme: ColorScheme.light(
              primary: const Color(0xFF050404).withOpacity(0.8),
            ),
          ),
          child: child!,
        );
      },
    );
  }

  Future<void> confirmDialog() async {
    BuildContext currentContext = context;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Center(
            child: Text(
              'Delivery Confirmation',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: BodyMedium(text: "Receiver Information:"),
              ),
              BodyMediumText(
                text: 'Name: ${nameController.text}',
              ),
              BodyMediumText(
                text: 'Mobile Number: ${contactNumberController.text}',
              ),
              BodyMediumOver(
                text: 'House Number: ${houseNumberController.text}',
              ),
              BodyMediumText(
                text: 'Barangay: $selectedBarangay',
              ),
              BodyMediumOver(
                text: 'Delivery Location: ${locationController.text}',
              ),
              const Divider(),
              BodyMediumOver(
                  text:
                      'Delivery Date and Time: ${DateFormat('MMMM d, y - h:mm a ').format(
                selectedDateTime!,
              )} '),
              BodyMediumText(
                text:
                    'Installed Option: ${selectedInstalledOption! ? 'Yes' : 'No'}',
              ),
              BodyMediumText(
                text: 'Applying for Discount: ${_image != null ? 'Yes' : 'No'}',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF050404).withOpacity(0.7),
              ),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await sendTransactionData();
                Provider.of<CartProvider>(currentContext, listen: false)
                    .clearCart();

                Navigator.pushNamed(currentContext, dashboardRoute,
                    arguments: 1);
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF050404).withOpacity(0.9),
              ),
              child: const Text(
                'Confirm',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }
}

void showAlertDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: const Center(
          child: Text(
            'Delivery Hours Notice',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
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
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF050404).withOpacity(0.8),
            ),
            child: const Text('Ok, I Understand'),
          ),
        ],
      );
    },
  );
}
