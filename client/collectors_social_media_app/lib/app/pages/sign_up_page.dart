import 'package:flutter/material.dart';
import 'package:collectors_social_media_app/app/services/api_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _password = '';

  Future<void> _trySignUp() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      try {
        await _signUpUser();
        Navigator.of(context).pop();
      } catch (e) {
        // _showSignUpError();
      }
    }
  }

  Future<void> _signUpUser() async {
    final auth.UserCredential userCredential = await auth.FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _email,
      password: _password,
    );
    final auth.User? user = userCredential.user;
    if (user != null) {
      final String uid = user.uid;
      await ApiService().postUser(_username, _firstName, _lastName, _email, _password, uid);
    } else {
      // Handle the case where user creation failed
    }
  }

  // void _showSignUpError() {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(
  //       content: Text('Failed to sign up.'),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Color(0xFFEAEAEA), // White
      appBar: AppBar(
        backgroundColor: Color(0xFF008080), // Teal
        title: const Text('Sign Up', style: TextStyle(color: Color(0xFFFFFFFF))), // White
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildSignUpForm(),
      ),
    );
  }

  Widget _buildSignUpForm() {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          _buildUsernameField(),
          SizedBox(height: 16),
          _buildFirstNameField(),
          SizedBox(height: 16),
          _buildLastNameField(),
          SizedBox(height: 16),
          _buildEmailField(),
          SizedBox(height: 16),
          _buildPasswordField(),
          SizedBox(height: 16),
          _buildSignUpButton(),
        ],
      ),
    );
  }

  Widget _buildUsernameField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Username',
        labelStyle: TextStyle(color: Color.fromARGB(255, 74, 74, 74)), // Gray
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFA0A0A0)), // Gray
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF4AB3B4)), // Light Teal
        ),
      ),
      validator: (value) => value!.isEmpty ? 'Please enter a username' : null,
      onSaved: (value) => _username = value!,
    );
  }

  Widget _buildFirstNameField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'First Name',
        labelStyle: TextStyle(color: Color.fromARGB(255, 74, 74, 74)), // Gray
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFA0A0A0)), // Gray
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF4AB3B4)), // Light Teal
        ),
      ),
      validator: (value) => value!.isEmpty ? 'Please enter a first name' : null,
      onSaved: (value) => _firstName = value!,
    );
  }

  Widget _buildLastNameField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Last Name',
        labelStyle: TextStyle(color: Color.fromARGB(255, 74, 74, 74)), // Gray  
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFA0A0A0)), // Gray
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF4AB3B4)), // Light Teal
        ),
      ),
      validator: (value) => value!.isEmpty ? 'Please enter a last name' : null,
      onSaved: (value) => _lastName = value!,
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(color: Color.fromARGB(255, 74, 74, 74)), // Gray
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFA0A0A0)), // Gray
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF4AB3B4)), // Light Teal
        ),
      ),
      validator: (value) => value!.isEmpty ? 'Please enter an email' : null,
      onSaved: (value) => _email = value!,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(color: Color.fromARGB(255, 74, 74, 74)), // Gray
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFA0A0A0)), // Gray
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF4AB3B4)), // Light Teal
        ),
      ),
      obscureText: true,
      validator: (value) => value!.length < 6 ? 'Password must be at least 6 characters long' : null,
      onSaved: (value) => _password = value!,
    );
  }

  Widget _buildSignUpButton() {
    return ElevatedButton(
      child: const Text('Sign Up'),
      style: ElevatedButton.styleFrom(
        primary: Color(0xFF4AB3B4), // Light Teal
        onPrimary: Color(0xFFFFFFFF), // White
      ),
      onPressed: _trySignUp,
    );
  }
}