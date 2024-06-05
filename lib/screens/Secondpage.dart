import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:digi1/screens/Thirdpage.dart';
import 'package:digi1/screens/fourthpage.dart';

class SecondPage extends StatefulWidget {
  final String userEmail;

  const SecondPage({Key? key, required this.userEmail}) : super(key: key);

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  void _logout() {
    Navigator.pushNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Profile"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.purple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('userProfiles')
                          .doc(widget.userEmail)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                              'https://via.placeholder.com/150', // Placeholder image
                            ),
                          );
                        }

                        var client = snapshot.data!;
                        if (client['image'] != null) {
                          Uint8List imageBytes = base64Decode(client['image']);
                          return CircleAvatar(
                            radius: 50,
                            backgroundImage: MemoryImage(imageBytes),
                          );
                        } else {
                          return CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                              'https://via.placeholder.com/150', // Placeholder image
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 10),
                    Text(
                      widget.userEmail,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('userProfiles')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }

                  final clients = snapshot.data!.docs.reversed.toList();
                  for (var client in clients) {
                    if (client['email'] == widget.userEmail) {
                      return Column(
                        children: [

                          SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                title: Text(
                                  'Name: ${client['name']}',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                title: Text(
                                  'Email: ${client['email']}',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                title: Text(
                                  'Bio: ${client['bio']}',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Vehicles:",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24.0,
                              fontFamily: "Tahoma",
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          MyTable(userEmail: client['email']),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Thirdpage(
                                    userEmail: widget.userEmail,
                                  ),
                                ),
                              );
                            },
                            child: Text("Add Vehicles"),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.blue,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      );
                    }
                  }

                  return Center(
                    child: Text(
                      'No data available.',
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyTable extends StatelessWidget {
  final String userEmail;

  MyTable({required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('userProfiles')
          .doc(userEmail)
          .collection('vehicles')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        List<Widget> vehicleTiles = [];
        final vehicles = snapshot.data!.docs;

        for (var vehicle in vehicles) {
          bool check = false;

          DateTime? pucDateTime;
          DateTime? insuranceDateTime;

          final vehicleData = vehicle.data() as Map<String, dynamic>;

          if (vehicleData.containsKey('PUC')) {
            if (vehicleData['PUC'] is Timestamp) {
              pucDateTime = (vehicleData['PUC'] as Timestamp).toDate();
            } else if (vehicleData['PUC'] is String) {
              pucDateTime = DateTime.parse(vehicleData['PUC']);
            }
          }

          if (vehicleData.containsKey('insurance')) {
            if (vehicleData['insurance'] is Timestamp) {
              insuranceDateTime = (vehicleData['insurance'] as Timestamp).toDate();
            } else if (vehicleData['insurance'] is String) {
              insuranceDateTime = DateTime.parse(vehicleData['insurance']);
            }
          }

          if ((pucDateTime != null && pucDateTime.isBefore(DateTime.now())) ||
              (insuranceDateTime != null && insuranceDateTime.isBefore(DateTime.now()))) {
            check = true;
          }

          vehicleTiles.add(
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: check ? Colors.red : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(
                    '${vehicleData['vehicleName']} - ${vehicleData['vehicleNumber']}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: "Tahoma",
                      fontWeight: FontWeight.w600,
                      color: check ? Colors.white : Colors.black,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Fourthpage(
                          vehicleNum: vehicleData['vehicleNumber'],
                          userEmail: userEmail,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        }

        return Column(
          children: vehicleTiles,
        );
      },
    );
  }
}
