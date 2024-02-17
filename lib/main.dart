import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('WebSocket Example')),
        body: ChatScreen(),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final WebSocketChannel _channel = WebSocketChannel.connect(
    Uri.parse('ws://localhost:8080'),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: StreamBuilder(
            stream: _channel.stream,
            builder: (context, snapshot) {
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(snapshot.hasData ? '${snapshot.data}' : ''),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _controller,
            onSubmitted: _sendMessage,
            decoration: InputDecoration(labelText: 'Send a message'),
          ),
        ),
      ],
    );
  }

  void _sendMessage(String message) {
    if (message.isNotEmpty) {
      _channel.sink.add(message);
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }
}
