import 'package:collectors_social_media_app/app/pages/landing_page.dart';
import 'package:collectors_social_media_app/app/splash_screen/splash_screen.dart';
import 'package:collectors_social_media_app/app/widgets/loading.dart';
import 'package:collectors_social_media_app/app/widgets/something_went_wrong.dart';
import 'package:flutter/material.dart';
import 'package:collectors_social_media_app/app/pages/community_page.dart';
import 'package:collectors_social_media_app/app/pages/message_page.dart';
import 'package:collectors_social_media_app/app/pages/post_collection_page.dart';
import 'package:collectors_social_media_app/app/pages/home_page.dart'; 
import 'package:collectors_social_media_app/app/pages/search_page.dart';
import 'package:collectors_social_media_app/app/pages/feed_page.dart'; 
import 'package:collectors_social_media_app/app/pages/profile_page.dart';
import 'package:collectors_social_media_app/app/pages/notification_page.dart';
import 'package:collectors_social_media_app/app/pages/settings_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return SomethingWentWrong(errorMessage: snapshot.error.toString());
        }
        if (snapshot.connectionState == ConnectionState.done) {
          final userId = FirebaseAuth.instance.currentUser?.uid;
          if (userId == null) {
            // Redirect to login page
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute: '/login', // the initial route
              routes: {
                '/login': (context) =>  LandingPage(), 
              },
            );
          }
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: '/splash', // the initial route
            routes: {
              '/splash': (context) => SplashScreen(),
              '/login': (context) =>  LandingPage(), 
              '/': (context) => HomePage(),
              '/feed': (context) => const FeedPage(), 
              '/search': (context) => const SearchPage(),
              '/post': (context) => PostPage(userId: userId),
              '/community': (context) => const CommunityPage(),
              '/message': (context) =>  MessagePage(),
              '/profile': (context) => ProfilePage(userId: userId),
              '/notification': (context) =>  NotificationPage(),
              '/settings': (context) => const SettingsPage(),
            },
          );
        }
        // Otherwise, show something whilst waiting for initialization to complete
        return Loading();
      },
    );
  }
}