import 'package:flutter/material.dart';
import 'screens/Login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/Signup.dart';
import 'screens/Menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      routes: {
        '/Login': (context) => Login(),
        '/Signup': (context) => Signup(),
        '/Menu': (context) => Menu(),
      },
      home: Login()
    )
  );
}