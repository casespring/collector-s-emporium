import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:collectors_social_media_app/app/pages/home_page.dart';

class LoginPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF), // White
      appBar: AppBar(
        backgroundColor: Color(0xFF008080), // Teal
        title: Text('Sign In', style: TextStyle(color: Color(0xFFFFFFFF))), // White
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildLoginForm(context),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return ListView(
      children: <Widget>[
        _buildEmailField(),
        SizedBox(height: 16),
        _buildPasswordField(),
        SizedBox(height: 16),
        _buildSignInButton(context),
      ],
    );
  }

  Widget _buildEmailField() {
    return TextField(
      controller: emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(color: Color(0xFFA0A0A0)), // Gray
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFA0A0A0)), // Gray
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF4AB3B4)), // Light Teal
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(color: Color(0xFFA0A0A0)), // Gray
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFA0A0A0)), // Gray
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF4AB3B4)), // Light Teal
        ),
      ),
      obscureText: true,
    );
  }

   Widget _buildSignInButton(BuildContext context) {
    return ElevatedButton(
      child: const Text('Sign In'),
      style: ElevatedButton.styleFrom(
        primary: Color(0xFF4AB3B4), // Light Teal
        onPrimary: Color(0xFFFFFFFF), // White
      ),
      onPressed: () async {
        try {
          UserCredential userCredential = await _auth.signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to sign in with email and password.'),
              ),
            );
        }
      },
    );
  }
}