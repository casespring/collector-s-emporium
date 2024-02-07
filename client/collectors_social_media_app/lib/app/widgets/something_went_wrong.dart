import 'package:flutter/material.dart';

class SomethingWentWrong extends StatelessWidget {
  final String errorMessage;

  SomethingWentWrong({required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Something went wrong: $errorMessage'),
        ),
      ),
    );
  }
}