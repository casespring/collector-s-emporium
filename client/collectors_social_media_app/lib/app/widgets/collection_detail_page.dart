import 'package:flutter/material.dart';

class CollectionDetailPage extends StatelessWidget {
  final Map<String, dynamic> collection;

  const CollectionDetailPage({Key? key, required this.collection}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(collection['title'] ?? ''),
      ),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 1 / 1, // This makes the aspect ratio 1:1 (square)
            child: Image.network(
              collection['image_url'] ?? '',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Text(collection['description'] ?? '', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 16),
                      Text('Likes: ${collection['likes_count'] ?? 0}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 16),
                      Text('Comments:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ...collection['comments']?.map<Widget>((comment) {
                          return ListTile(
                              title: Text(comment['user']['username'] ?? 'Anonymous'), // Display "Anonymous" if user is null
                              subtitle: Text(comment['comment']['text'] ?? 'No comment text'), // Display "No comment text" if text is null
                          );
                      }) ?? [],
                  ],
              ),
          )
        ],
      ),
    );
  }
}