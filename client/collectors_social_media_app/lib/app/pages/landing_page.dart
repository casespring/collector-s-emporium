import 'package:collectors_social_media_app/app/pages/login_page.dart';
import 'package:collectors_social_media_app/app/pages/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:collectors_social_media_app/app/pages/home_page.dart';
import 'package:collectors_social_media_app/app/widgets/sign_in_button.dart';

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
              backgroundColor: Color.fromARGB(255, 84, 254, 254), // Dark Teal
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Welcome to Collectify',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(212, 255, 255, 255), // Gray
                      ),
                    ),
                    SizedBox(height: 16),
                    SignInButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage())
                        );
                      },
                    ), 
                    ElevatedButton(
                      child: Text('don\'t have an account? Sign up'),
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 255, 255, 255), // Light Teal
                        onPrimary: Color.fromARGB(255, 26, 180, 167), // Gray
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (contex) => SignUpPage()),
                        );
                      },
                    ),
                    // TextButton(
                    //   child: Text('Continue without an account'),
                    //   style: TextButton.styleFrom(
                    //     primary: Color(0xFFA0A0A0), // Gray
                    //   ),
                    //   onPressed: () {
                    //     Navigator.pushReplacement(
                    //       context,
                    //       MaterialPageRoute(builder: (context) => HomePage()),
                    //     );
                    //   },
                    // ),
                  ],
                ),
              ),
            );
          } else {
            return HomePage();  // return the home page here
          }
        } else {
          return Scaffold(
            backgroundColor: Color(0xFF005151), // Dark Teal
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4AB3B4)), // Light Teal
              ),
            ),
          );
        }
      },
    );
  }
}