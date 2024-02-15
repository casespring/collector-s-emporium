import 'package:flutter/material.dart';

final Color mainColor = Color(0xFF008080);
final Color lightTeal = Color(0xFF4AB3B4);
final Color darkTeal = Color(0xFF005151);
final Color white = Color(0xFFFFFFFF);
final Color gray = Color(0xFFA0A0A0);
final Color lightGray = Color(0xFFEAEAEA);

class MessagePage extends StatelessWidget {
  MessagePage({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> messages = [
    {'user': 'John Doe', 'message': 'Hey, how are you?', 'time': '12:00 PM'},
    {'user': 'Jane Smith', 'message': 'Hello, this is a message', 'time': '1:15 PM'},
    {'user': 'Bob Johnson', 'message': 'What\'s up?', 'time': '2:30 PM'},
    {'user': 'Alice Williams', 'message': 'Good morning!', 'time': '10:45 AM'},
    {'user': 'Charlie Brown', 'message': 'Are you free this weekend?', 'time': '4:00 PM'},
    {'user': 'Megan Davis', 'message': 'Happy Birthday!', 'time': '5:15 PM'},
    {'user': 'David Miller', 'message': 'Check this out...', 'time': '6:30 PM'},
    {'user': 'Sarah Wilson', 'message': 'I love this app!', 'time': '7:45 PM'},
    {'user': 'Brian Moore', 'message': 'See you soon', 'time': '8:00 PM'},
    {'user': 'Jessica Taylor', 'message': 'Thanks for the help', 'time': '9:15 PM'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Direct Messages', style: TextStyle(color: white)),
        backgroundColor: mainColor,
      ),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: darkTeal,
              child: Icon(Icons.person, color: white),
            ),
            title: Text(messages[index]['user'], style: TextStyle(color: darkTeal)),
            subtitle: Text(messages[index]['message'], style: TextStyle(color: gray)),
            trailing: Text(messages[index]['time'], style: TextStyle(color: darkTeal)),
            onTap: () {
              // Navigate to chat screen
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: lightTeal,
        child: Icon(Icons.message, color: white),
        onPressed: () {
          // Navigate to new message screen
        },
      ),
    );
  }
}