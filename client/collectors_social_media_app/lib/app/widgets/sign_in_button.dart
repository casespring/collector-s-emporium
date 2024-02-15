import "package:flutter/material.dart";

class SignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  SignInButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text('Sign In'),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 255, 255, 255), // Light Teal
                        onPrimary: Color.fromARGB(255, 26, 180, 167), // Gray
                      ),
    );
  }
}