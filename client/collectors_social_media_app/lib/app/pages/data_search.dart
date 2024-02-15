import 'package:flutter/material.dart';

class DataSearch extends SearchDelegate<String> {
  final List<String> collections; // List of collections
  final List<String> tags; // List of tags

  DataSearch(this.collections, this.tags);

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
        close(context, null as String);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // This method will show the result based on selection
    final suggestionList = query.isEmpty
        ? collections
        : collections.where((p) => p.startsWith(query)).toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        title: Text(suggestionList[index]),
      ),
      itemCount: suggestionList.length,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // This method will show the suggestions while typing
    final suggestionList = query.isEmpty
        ? tags
        : tags.where((p) => p.startsWith(query)).toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        title: Text(suggestionList[index]),
      ),
      itemCount: suggestionList.length,
    );
  }
}