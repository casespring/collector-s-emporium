import 'package:flutter/material.dart';
import 'package:collectors_social_media_app/pages/home_page.dart'; // This is now your main navigation page
import 'package:collectors_social_media_app/pages/feed_page.dart'; // This is your new feed page
import 'package:collectors_social_media_app/pages/profile_page.dart';
import 'package:collectors_social_media_app/pages/settings_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(), // Changed from RoutePage to HomePage
      routes: {
        '/home': (context) => HomePage(), // This route now corresponds to your main navigation page
        '/feed': (context) => FeedPage(), // This is your new feed page route
        '/profile': (context) => ProfilePage(),
        '/settings': (context) => SettingsPage(),
      },
    );
  }
}