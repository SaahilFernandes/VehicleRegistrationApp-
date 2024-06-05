import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserProfile {
  final String email;
  final String name;
  final String bio;
  final Uint8List image; // Add this line

  UserProfile({
    required this.email,
    required this.name,
    required this.bio,
    required this.image,
  });
}

class Firstpage extends StatefulWidget {
  final String userEmail;

  const Firstpage({Key? key, required this.userEmail}) : super(key: key);

  @override
  _FirstpageState createState() => _FirstpageState();
}

class _FirstpageState extends State<Firstpage> {
  Uint8List? _image;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  Future<Uint8List?> pickImage(ImageSource source) async {
    try {
      final ImagePicker imagePicker = ImagePicker();
      XFile? file = await imagePicker.pickImage(source: source);

      if (file != null) {
        return await file.readAsBytes();
      } else {
        print('No image selected');
        return null;
      }
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  void saveProfile() async {
    try {
      String email = widget.userEmail;
      String name = nameController.text;
      String bio = bioController.text;

      Uint8List image = _image ?? Uint8List(0);

      UserProfile userProfile = UserProfile(
        email: email,
        name: name,
        bio: bio,
        image: image,
      );

      // Save the user profile to Firestore
      await FirebaseFirestore.instance.collection('userProfiles').doc(email).set({
        'email': userProfile.email,
        'name': userProfile.name,
        'bio': userProfile.bio,
        // Convert Uint8List to base64 string for storage in Firestore
        'image': base64Encode(userProfile.image),
      });

      // Success message or navigation logic
    } catch (e) {
      print('Error saving profile: $e');
      // Handle error
    }
  }

  void selectImage() async {
    Uint8List? img = await pickImage(ImageSource.gallery);
    if (img != null) {
      setState(() {
        _image = img;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Navigations"),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'First Page',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30.0,
                  fontFamily: "Tahoma",
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Stack(
                children: [
                  if (_image != null)
                    CircleAvatar(
                      radius: 64,
                      backgroundImage: MemoryImage(_image!),
                    )
                  else
                    const CircleAvatar(
                      radius: 64,
                      backgroundImage: NetworkImage(
                          'https://yt3.googleusercontent.com/BvZJpmpRDkdLNm9kumQ6cZqA6FKvsV5nR2RX_uO1QXIYej6htGkNRBz2gDV2kNTy6E0II5sNfQ4=s900-c-k-c0x00ffffff-no-rj'),
                    ),
                  Positioned(
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(Icons.add_a_photo),
                      color: Colors.white,
                    ),
                    left: 80,
                    bottom: -10,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextField(
                controller: TextEditingController(text: widget.userEmail),
                decoration: InputDecoration(
                  hintText: 'Email',
                  contentPadding: EdgeInsets.all(10),
                  border: OutlineInputBorder(),
                  hintStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Enter Name',
                  contentPadding: EdgeInsets.all(10),
                  border: OutlineInputBorder(),
                  hintStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: bioController,
                decoration: InputDecoration(
                  hintText: 'Enter Bio',
                  contentPadding: EdgeInsets.all(10),
                  border: OutlineInputBorder(),
                  hintStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(
                height: 24,
              ),
              ElevatedButton(
                onPressed: () {
                  saveProfile();
                  Navigator.pushNamed(context, '/login');
                },
                child: Text("Save Profile"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Replace 'primary' with 'backgroundColor'
                  foregroundColor: Colors.black, // Replace 'onPrimary' with 'foregroundColor'
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
