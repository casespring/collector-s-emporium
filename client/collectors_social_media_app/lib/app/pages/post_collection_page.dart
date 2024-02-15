import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:collectors_social_media_app/app/services/api_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


final Color mainColor = Color(0xFF008080);
final Color lightTeal = Color(0xFF4AB3B4);
final Color darkTeal = Color(0xFF005151);
final Color white = Color(0xFFFFFFFF);
final Color gray = Color.fromARGB(255, 25, 25, 25);
final Color lightGray = Color.fromARGB(255, 68, 68, 68);

class PostPage extends StatefulWidget {
  final String userId;

  const PostPage({Key? key, required this.userId}) : super(key: key);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isSubmitting = false;
  File? _image;
  String? actualUserId;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
    Map<String, dynamic> userData = await ApiService().fetchUserData(widget.userId);
    actualUserId = userData['id'].toString(); // Convert id to String
  }

  void _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }


  void _submitForm() async {
    if (_formKey.currentState!.validate() && _image != null && actualUserId != null) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        // Upload the image to Firebase Storage
        final ref = FirebaseStorage.instanceFor(bucket: 'gs://collector-s-emporium.appspot.com').ref().child('images').child('${DateTime.now().toIso8601String()}.jpg');
        await ref.putFile(_image!);

        // Get the download URL of the uploaded image
        final imageUrl = await ref.getDownloadURL();
        print('Image URL: $imageUrl'); // Debug print

        // Post the submission to your Flask backend
        await ApiService().postSubmission(_titleController.text, _descriptionController.text, imageUrl, actualUserId!);

        setState(() {
          _isSubmitting = false;
          _titleController.clear();
          _descriptionController.clear();
          _image = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: mainColor,
            content: Text('Post submitted successfully!', style: TextStyle(color: white)),
          ),
        );
      } catch (e) {
        print('Error submitting form: $e'); // Debug print
      }
    } else {
      print('Form validation failed or image not selected'); // Debug print
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post a CollectorSnapshot', style: TextStyle(color: white)),
        backgroundColor: mainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: gray),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: lightGray),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: lightTeal),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: gray),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: lightGray),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: lightTeal),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              if (_image != null)
                Image.file(
                  _image!,
                  width: 300, // specify the width
                  height: 300, // specify the height
                  fit: BoxFit.cover, // specify how the image should be inscribed into the box
                ),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick Image', style: TextStyle(color: white)),
                style: ElevatedButton.styleFrom(
                  primary: lightTeal,
                ),
              ),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitForm,
                child: _isSubmitting
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(white),
                      )
                    : Text('Submit', style: TextStyle(color: white)),
                style: ElevatedButton.styleFrom(
                  primary: mainColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}