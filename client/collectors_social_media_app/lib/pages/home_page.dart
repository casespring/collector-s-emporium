import 'package:collectors_social_media_app/pages/feed_page.dart';
import 'package:collectors_social_media_app/pages/notification_page.dart';
import 'package:collectors_social_media_app/pages/profile_page.dart';
import 'package:collectors_social_media_app/pages/settings_page.dart';
import 'package:collectors_social_media_app/pages/post_page.dart';
import 'package:collectors_social_media_app/pages/community_page.dart';
import 'package:collectors_social_media_app/pages/message_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedPageIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  final List _pages = [
    FeedPage(),
    PostPage(),
    CommunityPage(),
    MessagePage(),
  ];

  @override
  Widget build(BuildContext context) {
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
                MaterialPageRoute(builder: (context) => ProfilePage())
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