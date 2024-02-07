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
      body: Column(
        children: [
          Image.network(
            collection['image_url'] ?? '',
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height * 0.6, // 60% of the screen height
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(collection['description'] ?? ''),
          ),
        ],
      ),
    );
  }
}