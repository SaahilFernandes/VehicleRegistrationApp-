import 'dart:convert';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Fourthpage extends StatefulWidget {
  final String userEmail;
  final String vehicleNum;

  const Fourthpage({
    Key? key,
    required this.userEmail,
    required this.vehicleNum,
  }) : super(key: key);

  @override
  _FourthpageState createState() => _FourthpageState();
}

class _FourthpageState extends State<Fourthpage> {
  late Future<void> _fetchVehicleInfo;

  Uint8List? _image;
  TextEditingController vehicleNameController = TextEditingController();
  TextEditingController vehicleNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pucController = TextEditingController();
  TextEditingController insurenceController = TextEditingController();


  DateTime _datepuc = DateTime.now();

  DateTime _dateins = DateTime.now();

  void _showDatePuc() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    ).then((value) {
      if (value != null) {
        setState(() {
          _datepuc = value;
          String formattedDate = DateFormat('yyyy-MM-dd').format(_datepuc);
          pucController.text = formattedDate;
        });
      }
    });
  }
  void _showDateins() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    ).then((value) {
      if (value != null) {
        setState(() {
          _dateins = value;
          String formattedDate = DateFormat('yyyy-MM-dd').format(_dateins);
          insurenceController.text = formattedDate;
        });
      }
    });
  }
  void saveProfile() async {
    try {

      // Get the DocumentReference for the document to update
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('userProfiles')
          .doc(widget.userEmail)
          .collection('vehicles')
          .doc(widget.vehicleNum);

      // Now, you can use the update method on the DocumentReference
      await documentReference.update({
        'PUC': pucController.text,
        'insurance': insurenceController.text,

        // You can add more vehicle details as needed
      });

      // Success message or navigation logic
    } catch (e) {
      print('Error saving profile: $e');
      // Handle error
    }
  }


  @override
  void initState() {
    super.initState();
    // Initialize the future in initState
    _fetchVehicleInfo = fetchVehicleInfo();
  }


  Future<void> fetchVehicleInfo() async {
    try {
      // Use widget.userEmail to access the userEmail parameter
      String userEmail = widget.userEmail;

      // Query the 'vehicles' collection for the specific vehicle number
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('userProfiles')
          .doc(userEmail)
          .collection('vehicles')
          .where('vehicleNumber', isEqualTo: widget.vehicleNum)
          .get();

      // Check if any documents match the query
      if (querySnapshot.docs.isNotEmpty) {
        // Assuming there's only one document with the provided vehicle number
        var vehicleData = querySnapshot.docs.first.data()
        as Map<String, dynamic>;

        // Populate the text controllers with the retrieved data
        vehicleNameController.text =
            vehicleData['vehicleName'] as String? ?? '';
        vehicleNumberController.text =
            vehicleData['vehicleNumber'] as String? ?? '';
        emailController.text = widget.userEmail;
        pucController.text =
            vehicleData['PUC'] as String? ?? '';
        insurenceController.text =
            vehicleData['insurance'] as String? ?? '';

        // Check if the 'vehicleImage' field exists in the document
        if (vehicleData['vehicleImage'] != null) {
          // Assuming the 'vehicleImage' field contains a base64-encoded string
          String base64Image = vehicleData['vehicleImage'] as String;
          _image = base64Decode(base64Image);

          // Debugging: Print the length of the decoded image
          print('Decoded image length: ${_image!.length}');
        }
      } else {
        // No matching document found
        print('Vehicle not found for number: ${widget.vehicleNum}');
      }
    } catch (e) {
      print('Error fetching vehicle info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double boxHeight = screenHeight * 0.3;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Vehicle Details"),
      ),
      body: FutureBuilder(
        // Use the FutureBuilder to handle asynchronous fetching
        future: _fetchVehicleInfo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for the data, show a loading indicator
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Handle errors
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Once data is available, build the UI
            return Center(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: boxHeight,
                    decoration: BoxDecoration(
                      image: _image != null
                          ? DecorationImage(
                        image: MemoryImage(_image!),
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                    child: _image == null
                        ? Center(
                      child: Text(
                        'Image not available',
                        style: TextStyle(color: Colors.blue),
                      ),
                    )
                        : null,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: emailController,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: "Email",
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
                  TextFormField(
                    readOnly: true,
                    controller: vehicleNameController,
                    decoration: InputDecoration(
                      hintText: "Vehicle Name",
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
                  TextFormField(
                    readOnly: true,
                    controller: vehicleNumberController,
                    decoration: InputDecoration(
                      hintText: "Vehicle Number",
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
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            readOnly:true,
                            controller: pucController,
                            decoration: InputDecoration(
                              hintText: pucController.text,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 25,
                              ),
                              border: OutlineInputBorder(),
                              hintStyle: TextStyle(color: Colors.white),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 1), // Add some space between the TextFormField and the ElevatedButton
                        ElevatedButton(
                          onPressed: () {
                            _showDatePuc();
                          },
                          child: Text("PUC"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),


                  const SizedBox(height: 2),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: insurenceController,
                            decoration: InputDecoration(
                              hintText:insurenceController.text,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 25,
                              ),
                              border: OutlineInputBorder(),
                              hintStyle: TextStyle(color: Colors.white),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 1), // Add some space between the TextFormField and the ElevatedButton
                        ElevatedButton(
                          onPressed: () {
                            _showDateins();
                          },
                          child: Text("Insurence"),
                          style: ElevatedButton.styleFrom(

                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  ElevatedButton(
                    onPressed: () {
                      saveProfile();
                      Navigator.pop(context);


                    },
                    child: Text("Save"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
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
            );
          }
        },
      ),
    );
  }
}
