import 'package:flutter/material.dart';
import 'package:signalr_netcore/signalr_client.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Message> _messages = [];

  late HubConnection _connection;

  @override
  void initState() {
    super.initState();

    _connection = HubConnectionBuilder()
        .withUrl('http://10.0.2.2:5228/hubs/chatbot')
        .build();

    _connection.on('ReceiveMessage', _handleReceivedMessage);

    _connection.start();
  }

  void _handleReceivedMessage(List<Object?>? args) {
    final response = args!.first as String;
    setState(() {
      _messages.add(Message(sender: 'Bot', text: response));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with Bot'),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height -
              AppBar().preferredSize.height -
              MediaQuery.of(context).padding.top,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return ListTile(
                      title: Text(
                        message.sender + ': ' + message.text,
                        style: TextStyle(
                          fontWeight:
                              message.sender == 'You' ? FontWeight.bold : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: 'Type your message...',
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendMessage() {
    final messageText = _messageController.text;

    if (messageText.isNotEmpty) {
      setState(() {
        _messages.add(Message(sender: 'You', text: messageText));
      });

      // Check connection state before sending message
      if (_connection.state == HubConnectionState.Connected) {
        _connection.invoke('SendMessage', args: [messageText]);
      } else {
        // Attempt to start the connection again if it is not connected
        _connection.start()!.then((value) {
          _connection.invoke('SendMessage', args: [messageText]);
        });
      }

      _messageController.clear();
    }
  }
}

class Message {
  final String sender;
  final String text;

  Message({required this.sender, required this.text});
}
