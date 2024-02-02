import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton( // Add this line
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Notification Page'),
      ),
      body: Center(
        child: Text("Notification Page"),
      ),
    );
  }
}