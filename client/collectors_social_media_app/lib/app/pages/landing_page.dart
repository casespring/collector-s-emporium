import 'package:collectors_social_media_app/app/pages/Login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:collectors_social_media_app/app/pages/home_page.dart';
import 'package:collectors_social_media_app/widgets/sign_in_button.dart';


class LandingPage extends StatelessWidget {


  @override 
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SignInButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage())
                        );
                      },
                    ), 
                    TextButton(
                      child: Text('Continue without signing in'),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          } else {
            return HomePage();  // return the home page here
          }
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}