import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton( // Add this line
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Settings Page'),
      ),
      body: Center(
        child: Text("setting Page Under Construction"),
      ),
    );
  }
}