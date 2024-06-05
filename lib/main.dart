import 'package:flutter/material.dart';
import 'package:digi1/screens/Firstpage.dart';
import 'package:digi1/screens/Secondpage.dart';
import 'package:digi1/screens/Thirdpage.dart';

import 'package:digi1/screens/login.dart';
import 'package:digi1/screens/register.dart';
import 'package:digi1/screens/fourthpage.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';// Import Firebase Core

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/main': (context) => MyHomePage(),
        '/first': (context) => Firstpage(userEmail: "Email"),
        '/second': (context) => SecondPage(userEmail: "Email"),
        '/third': (context) => Thirdpage(userEmail: "Email"),

        '/register': (context) => MyRegister(),
        '/login': (context) => MyLogin(),
        '/fourth': (context) => Fourthpage(vehicleNum: "None",userEmail: "Email",),

      },
      title: 'VEHICLE REGISTRATION',
      theme: ThemeData(

        scaffoldBackgroundColor: Colors.transparent,
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.dark,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("VEHICAL"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Home Page',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
                fontFamily: "Tahoma",
                fontWeight: FontWeight.w600,
              ),
            ),

            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 30.0,
                    fontFamily: "Times New Roman",
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}
