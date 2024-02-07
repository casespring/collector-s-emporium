import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  Future<List<dynamic>> fetchData() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:5565/collections'));

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON.
      return jsonDecode(response.body) as List; // Parse the response as a list
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to load data');
    }
  }

    Future<Map<String, dynamic>> fetchUserData(int userId) async {
    final response = await http.get(Uri.parse('http://127.0.0.1:5565/users/$userId'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load user data');
    }
  }

    Future<List<dynamic>> fetchUserCollections(int userId) async {
    final response = await http.get(Uri.parse('http://127.0.0.1:5565/users/$userId/collections'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List;
    } else {
      throw Exception('Failed to load user collections');
    }
  }

  Future<void> postCollection(String title, String description, String imageUrl, int userId) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5565/collections'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'title': title,
        'user_id': userId,
        'description': description,
        'image_url': imageUrl,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to post collection');
    }
  }
}