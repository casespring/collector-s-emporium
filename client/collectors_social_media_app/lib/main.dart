import 'package:flutter/material.dart';
import 'package:collectors_social_media_app/pages/community_page.dart';
import 'package:collectors_social_media_app/pages/message_page.dart';
import 'package:collectors_social_media_app/pages/post_page.dart';
import 'package:collectors_social_media_app/pages/home_page.dart'; 
import 'package:collectors_social_media_app/pages/search_page.dart';
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
      initialRoute: '/', // the initial route
      routes: {
        '/': (context) => const HomePage(), 
        '/feed': (context) => const FeedPage(), 
        '/search': (context) => const SearchPage(),
        '/post': (context) => const PostPage(),
        '/community': (context) => const CommunityPage(),
        '/message': (context) => const MessagePage(),
        '/profile': (context) => const ProfilePage(),
        '/notification': (context) => const NotificationPage(),
        '/settings': (context) => const SettingsPage(),
      },
    );
  }
}