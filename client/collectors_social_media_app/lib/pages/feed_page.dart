import 'package:flutter/material.dart';
import 'package:collectors_social_media_app/app/services/api_service.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feed'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: ApiService().fetchData(),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: <Widget>[
                      Image.network(
                        snapshot.data?[index]['image_url'],
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
                              'Item ${snapshot.data?[index]['title']}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF080202),
                              ),
                            ),
                            Text(
                              '${snapshot.data?[index]['description']}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF244446),
                              ),
                            ),
                            Text(
                              'Posted by ${snapshot.data?[index]['user']['username']}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF244446),
                              ),
                            ),
                            Text(
                              '♡  ${snapshot.data?[index]['likes_count']}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 6, 36, 33),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      child: ListView.builder(
                                        itemCount: snapshot.data?[index]['comments'].length,
                                        itemBuilder: (context, commentIndex) {
                                          return ListTile(
                                            title: Text(snapshot.data?[index]['comments'][commentIndex]['text']),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Text(
                                'Show Comments',
                                style: TextStyle(
                                  color: Colors.teal,
                                ),
                              ), 
                            ),
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