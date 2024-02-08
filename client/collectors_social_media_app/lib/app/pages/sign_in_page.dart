import 'package:flutter/material.dart';
import 'package:collectors_social_media_app/app/services/api_service.dart';

class SignUpPage extends StatefulWidget {

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _email = '';
  String _password = '';

  void _trySignUp() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      try {
        await ApiService().postUser(_username, _email, _password);
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to sign up.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(labelText: 'Username'),
              validator: (value) => value!.isEmpty ? 'Please enter a username' : null,
              onSaved: (value) => _username = value!,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) => value!.isEmpty ? 'Please enter an email' : null,
              onSaved: (value) => _email = value!,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (value) => value!.length < 6 ? 'Password must be at least 6 characters long' : null,
              onSaved: (value) => _password = value!,
            ),
            ElevatedButton(
              child: const Text('Sign Up'),
              onPressed: _trySignUp,
            ),
          ],
        ),
      ),
    );
  }
}