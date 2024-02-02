// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class ApiService {
//   static Future<List<dynamic>> fetchUserPictures() async {
//     final response = await http.get(Uri.parse(''));

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception('Failed to load user pictures');
//     }
//   }
// }