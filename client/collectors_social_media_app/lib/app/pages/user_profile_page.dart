import 'package:collectors_social_media_app/app/pages/edit_profile_page.dart';
import 'package:collectors_social_media_app/app/widgets/collection_detail_page.dart';
import 'package:collectors_social_media_app/app/pages/notification_page.dart';
import 'package:collectors_social_media_app/app/pages/settings_page.dart';
import 'package:collectors_social_media_app/app/services/api_service.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  final String username;

  const UserProfilePage({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton( 
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Profile Page'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Navigate to notifications page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationPage())
              );
            }
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage())
              );
            }
          ),
        ]
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: ApiService().fetchUserDataByUsername(username),
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (snapshot.data?['user_image'] != null)
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(snapshot.data?['user_image']),
                    ),
                  SizedBox(height: 16),
                  Text('${snapshot.data?['username']}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Bio: ${snapshot.data?['user_bio']}', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 16),
                  Text('Collections:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  FutureBuilder<List<dynamic>>(
                    future: ApiService().fetchUserCollectionsByUsername(username),
                    builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Expanded(
                          child: GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, // Adjust number of items per row
                              crossAxisSpacing: 2,
                              mainAxisSpacing: 2,
                            ),
                            itemCount: snapshot.data?.length ?? 0,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CollectionDetailPage(
                                        collection: snapshot.data?[index],
                                      ),
                                    ),
                                  );
                                },
                                child: AspectRatio(
                                  aspectRatio: 1 / 1, // This makes the aspect ratio 1:1 (square)
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(snapshot.data?[index]['image_url'] ?? ''),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}