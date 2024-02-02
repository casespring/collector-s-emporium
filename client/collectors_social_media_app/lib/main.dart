import 'package:flutter/material.dart';
import 'package:collectors_social_media_app/pages/community_page.dart';
import 'package:collectors_social_media_app/pages/message_page.dart';
import 'package:collectors_social_media_app/pages/post_page.dart';
import 'package:collectors_social_media_app/pages/home_page.dart'; 
import 'package:collectors_social_media_app/pages/feed_page.dart'; 
import 'package:collectors_social_media_app/pages/profile_page.dart';
import 'package:collectors_social_media_app/pages/notification_page.dart';
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
      initialRoute: '/', // Set the initial route
      routes: {
        '/': (context) => HomePage(), 
        '/feed': (context) => FeedPage(), 
        '/post': (context) => PostPage(),
        '/community': (context) => CommunityPage(),
        '/message': (context) => MessagePage(),
        '/profile': (context) => ProfilePage(),
        '/notification': (context) => NotificationPage(),
        '/settings': (context) => SettingsPage(),
      },
    );
  }
}