import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

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

    Future<Map<String, dynamic>> fetchUserData(String uid) async {
    final response = await http.get(Uri.parse('http://127.0.0.1:5565/users/$uid'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load user data');
    }
  }

    Future<List<dynamic>> fetchUserCollections(String uid) async {
    final response = await http.get(Uri.parse('http://127.0.0.1:5565/users/$uid/collections'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List;
    } else {
      throw Exception('Failed to load user collections');
    }
  }

  Future<void> postCollection(String title, String description, String imageUrl, userId) async {
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

  Future<void> postUser(String username, String firstName, String lastName, String email, String password, String uid) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5565/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': password,
        'uid': uid,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to post user');
    }
  }

  Future<void> postSubmission(String title, String description, String imageUrl, String userId) async {
    var request = http.MultipartRequest('POST', Uri.parse('http://127.0.0.1:5565/collections'));
    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['userId'] = userId;
    request.fields['image'] = imageUrl; // Send the image URL
    var response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('Failed to post submission');
    }
  }

  Future<List<dynamic>> fetchUserCollectionsByUsername(String username) async {
    final response = await http.get(Uri.parse('http://127.0.0.1:5565/users/info/$username/collections'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List;
    } else {
      throw Exception('Failed to load user collections');
    }
  }

  Future<Map<String, dynamic>> fetchUserDataByUsername(String username) async {
    final response = await http.get(Uri.parse('http://127.0.0.1:5565/users/info/$username'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load user data');
    }
  }
}