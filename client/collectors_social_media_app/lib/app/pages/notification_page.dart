import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  NotificationPage({Key? key}) : super(key: key);

  final List<Map<String, String>> notifications = [
    {'title': 'New Follower', 'details': 'Brian88 started following you.'},
    {'title': 'Post Liked', 'details': 'Aya liked your post: "My new blog post".'},
    {'title': 'Comment', 'details': 'Alex commented: "Great post!" on your post.'},
    {'title': 'New Message', 'details': 'You received a new message from Sarah.'},
    {'title': 'Post Shared', 'details': 'Your post was shared by 5 people.'},
    // Add more notifications here
  ];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: Color(0xFF008080),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Color.fromARGB(255, 30, 70, 71)),
        scaffoldBackgroundColor: Color(0xFFFFFFFF),
        cardColor: Color(0xFFEAEAEA),
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Color.fromARGB(255, 37, 37, 37)),
          bodyText2: TextStyle(color: Color(0xFF005151)),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('Notifications'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: Icon(Icons.notifications, color: Theme.of(context).colorScheme.secondary),
                  title: Text(
                    notifications[index]['title']!,
                    style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyText2?.color),
                  ),
                  subtitle: Text(
                    notifications[index]['details']!,
                    style: TextStyle(color: Theme.of(context).textTheme.bodyText1?.color),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            notifications[index]['title']!,
                            style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyText2?.color),
                          ),
                          content: Text(
                            notifications[index]['details']!,
                            style: TextStyle(color: Theme.of(context).textTheme.bodyText1?.color),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Close', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}