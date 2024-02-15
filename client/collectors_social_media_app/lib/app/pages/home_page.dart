import 'package:collectors_social_media_app/app/pages/landing_page.dart';
import 'package:collectors_social_media_app/app/pages/post_page.dart';
import 'package:collectors_social_media_app/app/pages/feed_page.dart';
import 'package:collectors_social_media_app/app/pages/notification_page.dart';
import 'package:collectors_social_media_app/app/pages/post_collection_page.dart';
import 'package:collectors_social_media_app/app/pages/profile_page.dart';
import 'package:collectors_social_media_app/app/pages/search_page.dart';
import 'package:collectors_social_media_app/app/pages/settings_page.dart';
import 'package:collectors_social_media_app/app/pages/community_page.dart';
import 'package:collectors_social_media_app/app/pages/message_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedPageIndex = 0;

  Future<String?> getUserId() async {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getUserId(),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loading spinner while waiting for userId
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // Show error message if any error occurs
        } else {
          final userId = snapshot.data;
          if (userId == null) {
            return LandingPage(); // If userId is null, redirect to LandingPage
          } else {
            final _pages = [
              FeedPage(),
              // SearchPage(),
              PostPage(userId: userId),
              CommunityPage(),
              MessagePage(),
            ];
            // If userId is not null, show HomePage with BottomNavigationBar
            return Scaffold(
              appBar: AppBar(
                title: Text("Collectify"),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.notifications),
                    onPressed: () {
                      // Navigate to notifications page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NotificationPage())
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.person),
                    onPressed: () {
                      // Navigate to profile page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage(userId: userId))
                      );
                    },
                  ),
                ],
              ),
              body: _pages[_selectedPageIndex],
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: _selectedPageIndex,
                onTap: _navigateBottomBar,
                selectedItemColor: Colors.teal,
                unselectedItemColor: Colors.grey,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: "Home",
                  ),
                  // BottomNavigationBarItem(
                  //   icon: Icon(Icons.search),
                  //   label: "Search",
                  // ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.post_add),
                    label: "Post",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.people),
                    label: "Community",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.message),
                    label: "Message",
                  ),
                ],
              ),
            );
          }
        }
      },
    );
  }
}