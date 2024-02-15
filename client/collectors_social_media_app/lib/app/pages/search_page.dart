import 'package:flutter/material.dart';

class Collection {
  final String title;
  final List<String> tags;

  Collection({required this.title, required this.tags});
}

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Page'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: DataSearch());
            },
          )
        ],
      ),
      body: Center(
        child: Text("Search Under Construction"),
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  final collections = [
    Collection(title: "Collection 1", tags: ["tag1", "tag2"]),
    Collection(title: "Collection 2", tags: ["tag3", "tag4"]),
    // Add more collections here
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null ?? '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final suggestionList = collections
        .where((collection) => collection.title.contains(query) || collection.tags.contains(query))
        .toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        title: Text(suggestionList[index].title),
        subtitle: Text(suggestionList[index].tags.join(', ')),
      ),
      itemCount: suggestionList.length,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? collections
        : collections.where((collection) => collection.title.contains(query) || collection.tags.contains(query)).toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          query = suggestionList[index].title;
          showResults(context);
        },
        title: Text(suggestionList[index].title),
        subtitle: Text(suggestionList[index].tags.join(', ')),
      ),
      itemCount: suggestionList.length,
    );
  }
}