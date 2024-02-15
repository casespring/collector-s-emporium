import 'package:flutter/material.dart';

class EditProfilePage extends StatelessWidget {
  final String userId;

  const EditProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: 'Bio',
              ),
              // Add code to update the user's bio...
            ),
            ElevatedButton(
              child: Text('Add Collection'),
              onPressed: () {
                // Add code to add a collection...
              },
            ),
            ElevatedButton(
              child: Text('Delete Collection'),
              onPressed: () {
                // Add code to delete a collection...
              },
            ),
          ],
        ),
      ),
    );
  }
}

