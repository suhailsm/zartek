import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zartektest/home.dart';
import 'package:zartektest/login.dart';
import 'package:zartektest/signinpage.dart';
import 'package:zartektest/tasks.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.purple,
        primarySwatch: Colors.purple,
        accentColor: Colors.purple,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseUser>(
      future: FirebaseAuth.instance.currentUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          FirebaseUser user = snapshot.data;
          return TasksPage(uid: user.uid);
        } else {
          return SignUpScreen();
        }
      },
    );
  }
}