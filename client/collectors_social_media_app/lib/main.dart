import 'package:collectors_social_media_app/app/splash_screen/splash_screen.dart';
import 'package:collectors_social_media_app/app/widgets/loading.dart';
import 'package:collectors_social_media_app/app/widgets/something_went_wrong.dart';
import 'package:flutter/material.dart';
import 'package:collectors_social_media_app/app/pages/landing_page.dart';
import 'package:collectors_social_media_app/app/pages/community_page.dart';
import 'package:collectors_social_media_app/app/pages/message_page.dart';
import 'package:collectors_social_media_app/app/pages/post_page.dart';
import 'package:collectors_social_media_app/app/pages/home_page.dart'; 
import 'package:collectors_social_media_app/app/pages/search_page.dart';
import 'package:collectors_social_media_app/app/pages/feed_page.dart'; 
import 'package:collectors_social_media_app/app/pages/profile_page.dart';
import 'package:collectors_social_media_app/app/pages/notification_page.dart';
import 'package:collectors_social_media_app/app/pages/settings_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  runApp(MyApp(
    initialization: _initialization,
  ));
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> initialization;

  const MyApp({
    Key? key,
    required this.initialization,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return SomethingWentWrong(errorMessage: snapshot.error.toString());
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: '/splash', // the initial route
            routes: {
              '/splash': (context) =>  SplashScreen(),
              '/': (context) => LandingPage(), 
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

        // Otherwise, show something whilst waiting for initialization to complete
        return Loading();
      },
    );
  }
}