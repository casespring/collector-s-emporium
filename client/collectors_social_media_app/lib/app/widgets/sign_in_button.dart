import "package:flutter/material.dart";

class SignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  SignInButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text('Sign In'),
      onPressed: onPressed,
    );
  }
}