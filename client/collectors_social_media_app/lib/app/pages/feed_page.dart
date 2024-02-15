import 'package:collectors_social_media_app/app/pages/search_page.dart';
import 'package:collectors_social_media_app/app/pages/user_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:collectors_social_media_app/app/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';


class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  Future<List<dynamic>>? _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = ApiService().fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEAEAEA), // Light Gray
      appBar: AppBar(
        backgroundColor: Color(0xFF008080), // Teal
        title: Text('Timeline', style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))), // Gray
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search, color: Color.fromARGB(255, 19, 19, 19)), // Gray
            onPressed: () {
              showSearch(context: context, delegate: DataSearch());
            },
          )
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _futureData,
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            List<dynamic> reversedData = snapshot.data!.reversed.toList();
            return ListView.builder(
              itemCount: reversedData.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Color(0xFFFFFFFF), // White
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: <Widget>[
                      Image.network(
                        reversedData[index]['image_url'],
                        fit: BoxFit.cover,
                        height: 400,
                        width: double.infinity,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Item ${reversedData[index]['title']}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF005151), // Dark Teal
                              ),
                            ),
                            Text(
                              '${reversedData[index]['description']}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF636551), // Gray
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserProfilePage(username: reversedData[index]['user']['username']),
                                  ),
                                );
                              },
                              child: Text(
                                'Posted by ${reversedData[index]['user']['username']}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFA0A0A0), // Gray
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    (reversedData[index]['user_has_liked'] ?? false) ? Icons.favorite : Icons.favorite_border,
                                    color: Color(0xFF005151), // Dark Teal
                                  ),
                                  onPressed: () async {
                                    // Get the Firebase UID.
                                    final user = FirebaseAuth.instance.currentUser;
                                    if (user == null) {
                                      // Handle the case where the user is not signed in.
                                      print('No user signed in.');
                                      return;
                                    }
                                    final firebaseUid = user.uid;

                                    // Fetch the user ID from the backend.
                                    var userResponse = await http.get(Uri.parse('http://127.0.0.1:5565/users/$firebaseUid'));
                                    if (userResponse.statusCode != 200) {
                                      // Handle the case where the request failed.
                                      print('Failed to fetch user ID.');
                                      return;
                                    }
                                    var userData = jsonDecode(userResponse.body);
                                    var userId = userData['id'].toString();

                                    // check if 'user_has_liked' is null
                                    bool userHasLiked = reversedData[index]['user_has_liked'] ?? false;
                                    
                                    userHasLiked = !userHasLiked;
                                    reversedData[index]['user_has_liked'] = userHasLiked;
                                    if (userHasLiked) {
                                      reversedData[index]['likes_count']++;
                                      var response = await http.post(
                                        Uri.parse('http://127.0.0.1:5565/likes'),
                                        body: {
                                          'collection_id': reversedData[index]['id'].toString(),
                                          'user_id': userId, // Use the user ID from the backend
                                        },
                                      );
                                      if (response.statusCode == 200) {
                                        var data = jsonDecode(response.body);
                                        reversedData[index]['like_id'] = data['id'];
                                      }
                                    } else {
                                      reversedData[index]['likes_count']--;
                                      var response = await http.delete(
                                        Uri.parse('http://127.0.0.1:5565/likes/${reversedData[index]['like_id']}'),
                                      );
                                      if (response.statusCode == 200) {
                                        reversedData[index]['like_id'] = null;
                                      }
                                    }
                                    setState(() {});
                                  },
                                ),
                                Text(
                                  '${reversedData[index]['likes_count']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF005151), // Dark Teal
                                  ),         
                                ),
                                TextButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Container(
                                          child: Column(
                                            children: <Widget>[
                                              TextField(
                                                onSubmitted: (value) {
                                                  // This is where you would handle the new comment.
                                                  // Since you mentioned it doesn't need to persist, we'll just print it.
                                                  print(' New comment: $value');
                                                },
                                                decoration: InputDecoration(
                                                  labelText: " Enter your comment",
                                                ),
                                              ),
                                              Expanded(
                                                child: ListView.separated(
                                                  itemCount: reversedData[index]['comments'].length,
                                                  separatorBuilder: (context, commentIndex) => Divider(color: Color(0xFFA0A0A0)), // Gray
                                                  itemBuilder: (context, commentIndex) {
                                                    return ListTile(
                                                      title: Text(reversedData[index]['comments'][commentIndex]['comment']['text']),
                                                      subtitle: Text(
                                                        'Comment by ${reversedData[index]['comments'][commentIndex]['user']?['username'] ?? 'Unknown'}',
                                                        style: TextStyle(
                                                          color: Color(0xFF4AB3B4), // Light Teal
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Text(
                                    'Show Comments',
                                    style: TextStyle(
                                      color: Color(0xFF4AB3B4), // Light Teal
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // ...
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          // By default, show a loading spinner.
          return CircularProgressIndicator();
        },
      ),
    );
  }
}