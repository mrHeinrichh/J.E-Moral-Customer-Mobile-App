import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class MessageProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _messages = [];

  List<Map<String, dynamic>> get messages => _messages;

  // Add a method to add a new message
  void addMessage(Map<String, dynamic> message) {
    _messages.add(message);
    notifyListeners();
  }
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _textController = TextEditingController();
  late IO.Socket socket;
  late Future<List<Map<String, dynamic>>> messages;
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    // Initialize Socket.IO and connect
    initializeSocketIO();
    // Fetch messages from the API
    messages = fetchMessages();
    print('initState: fetchMessages called');
  }

  void initializeSocketIO() {
    // Your existing Socket.IO initialization code goes here
    socket = IO.io('https://lpg-api-06n8.onrender.com', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.on('message', (data) {
      print('Incoming message: $data');
      // Handle the incoming message, update the UI, etc.
    });

    // Connect to the server
    socket.connect();
  }

  Future<void> loadMoreMessages() async {
    _isLoading = true;
    try {
      _currentPage++;
      final moreMessages = await fetchMessages();
      final List<Map<String, dynamic>> currentMessages =
          await messages; // Get the current messages
      final List<Map<String, dynamic>> updatedMessages =
          List.from(currentMessages)..addAll(moreMessages);

      // Sort the updated messages
      updatedMessages.sort(
        (a, b) => b['createdAt'].compareTo(a['createdAt']),
      );

      setState(() {
        messages = Future.value(updatedMessages);
      });

      // Scroll back to the original position before loading more messages
      _scrollController.jumpTo(_scrollController.offset +
          (_scrollController.position.viewportDimension * moreMessages.length));
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
    }
  }

  Future<List<Map<String, dynamic>>> fetchMessages() async {
    final response = await http.get(
      Uri.parse(
          'https://lpg-api-06n8.onrender.com/api/v1/messages?user=65b251323deddfd62fa5523d&page=$_currentPage&limit=100'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] == 'success') {
        List<Map<String, dynamic>> messages =
            List<Map<String, dynamic>>.from(data['data']);
        messages.sort((a, b) => b['createdAt']
            .compareTo(a['createdAt'])); // Sort in descending order
        return messages;
      } else {
        print('Failed to fetch messages');
        return [];
      }
    } else {
      print('Failed to fetch messages. Status code: ${response.statusCode}');
      return [];
    }
  }

  Future<void> sendMessage(String content) async {
    final Map<String, dynamic> messageData = {
      "user": "65b251323deddfd62fa5523d",
      "content": content,
    };

    final response = await http.post(
      Uri.parse('https://lpg-api-06n8.onrender.com/api/v1/messages'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(messageData),
    );

    if (response.statusCode == 200) {
      // Message sent successfully
      final Map<String, dynamic> responseData = json.decode(response.body);
      final Map<String, dynamic> newMessage = responseData['data'][0];

      // Update the UI with the new message
      MessageProvider messageProvider = MessageProvider();
      messageProvider.addMessage(newMessage);
    } else {
      // Handle error
      print('Failed to send message. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Customer Support',
          style: TextStyle(color: Color(0xFF232937), fontSize: 24),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            NotificationListener(
              onNotification: (ScrollNotification scrollInfo) {
                if (!_isLoading &&
                    scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                  loadMoreMessages();
                }
                return true;
              },
              child: Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: messages,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final List<Map<String, dynamic>> messageList =
                          snapshot.data ?? [];
                      return ListView.builder(
                        reverse: true,
                        controller: _scrollController,
                        itemCount: messageList.length,
                        itemBuilder: (context, index) {
                          final message = messageList[index];
                          return ListTile(
                            title: Text(message['content']),
                            subtitle: Text(message['createdAt']),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: 'Type your message...',
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                // Handle send button action here
                // You can access the entered text using _textController.text
                String messageContent = _textController.text;
                if (messageContent.isNotEmpty) {
                  sendMessage(messageContent);
                  _textController
                      .clear(); // Clear the text field after sending the message
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Disconnect from the Socket.IO server when the widget is disposed
    socket.disconnect();
    super.dispose();
  }
}
