import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert'; // Add this import for base64Encode

class Thirdpage extends StatefulWidget {
  final String userEmail;

  const Thirdpage({Key? key, required this.userEmail}) : super(key: key);

  @override
  _ThirdpageState createState() => _ThirdpageState();
}

class UserProfile {
  final String email;
  final String vehicleName;
  final String number;
  final Uint8List image;

  UserProfile({
    required this.email,
    required this.vehicleName,
    required this.number,
    required this.image,
  });
}

class _ThirdpageState extends State<Thirdpage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numController = TextEditingController();
  Uint8List? _image;
  String selectedVehicleType = 'Select'; // Default value

  Future<void> selectImage() async {
    Uint8List? img = await pickImage(ImageSource.gallery);
    if (img != null) {
      setState(() {
        _image = img;
      });
    }
  }

  void saveProfile() async {
    try {
      String email = widget.userEmail;
      String vehicleName = nameController.text;
      String number = numController.text;

      Uint8List vehicleImage = _image ?? Uint8List(0);

      UserProfile userProfile = UserProfile(
        email: email,
        vehicleName: vehicleName,
        number: number,
        image: vehicleImage,
      );

      // Save user profile in 'userProfiles' collection

      // Save vehicle information as a document with the vehicle number as the ID
      await FirebaseFirestore.instance
          .collection('userProfiles')
          .doc(email)
          .collection('vehicles')
          .doc(number) // Use the vehicle number as the document ID
          .set({
        'vehicleName': userProfile.vehicleName,
        'vehicleNumber': userProfile.number,
        'vehicleImage': base64Encode(userProfile.image),
        // You can add more vehicle details as needed
      });

      // Success message or navigation logic
    } catch (e) {
      print('Error saving profile: $e');
      // Handle error
    }
  }

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

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;



return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          children: [
            DropdownButton<String>(
              value: selectedVehicleType,
              onChanged: (String? newValue) {
                setState(() {
                  selectedVehicleType = newValue ?? 'Select';
                });
              },
              items: <String>[
                'Select',
                '2 Wheeler',
                '4 Wheeler',
                'Anomalous',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: screenHeight * 0.3,
            child: Stack(
              children: [
                if (_image != null)
                  Image.memory(
                    _image!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  )
                else
                  Image.network(
                    selectedVehicleType == '2 Wheeler'
                        ? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRsuwpPj4JKNlWoNF27V5BJD8VN3nO-ufc3Kg&usqp=CAU'
                        : selectedVehicleType == '4 Wheeler'
                        ? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR4HPOkzUx9C2QakDN4yfsFf_s0DP_ml3O6xw&usqp=CAU'
                        : selectedVehicleType == 'Anomalous'
                        ? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSVfjWZw2UCwI_pyog4CZGo6YDtNn5bliXkbQ&usqp=CAU'
                        : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRUxSODCEElpiYsmmZzApFH8gQIxkQ6P3K2vg&usqp=CAU',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                Positioned(
                  child: ElevatedButton(
                    onPressed: selectImage,
                    child: Icon(
                      Icons.arrow_upward,
                      color: Colors.cyan,
                      size: 80,
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(16),
                      backgroundColor: Colors.black,
                    ),
                  ),
                  left: 80,
                  bottom: -40, // Adjusted to place it below the image
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Selected Vehicle Type: $selectedVehicleType',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontFamily: "Tahoma",
                      fontWeight: FontWeight.w600,
                    ),
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
                      hintText: 'Vehicle Name',
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
                    controller: numController,
                    decoration: InputDecoration(
                      hintText: 'Vehicle Number',
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
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/main');
                      },
                      child: Text(
                        "Home Screen",
                        style: TextStyle(
                          fontSize: 30.0,
                          fontFamily: "Times New Roman",
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      saveProfile();
                      Navigator.pop(context);
                    },
                    child: Text("Save Profile"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Back"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
