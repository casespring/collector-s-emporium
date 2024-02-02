import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton( 
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Profile Page'),
      ),
      body: Center(
        child: Text("Profile Page"),
      ),
    );
  }
}