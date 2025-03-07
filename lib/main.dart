import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // นำเข้า firebase_core
// import 'package:math_game/RegisterScreen.dart';
import 'package:math_game/sceen/dashboard.dart';
import 'package:math_game/sceen/login.dart';
import 'package:math_game/sceen/register.dart';
import 'firebase_options.dart'; // ใช้การตั้งค่าจาก firebase_options.dart
// import 'package:firebase_auth/firebase_auth.dart'; // ใช้ Firebase Authentication

// หน้าแอปต่างๆ
// import 'package:weektwo/screen/login.dart';
// import 'package:weektwo/screen/dashboard.dart';
// import 'package:weektwo/screen/register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ให้แน่ใจว่า Firebase ถูก initialize ก่อน
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // ใช้การตั้งค่าจาก firebase_options.dart
  );

  runApp(MyApp()); // เรียกใช้แอปหลังจากที่ Firebase ถูก initialize
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase App',
      theme: ThemeData(
        primaryColor: Colors.blue,
        secondaryHeaderColor: Colors.blueAccent,
      ),
      home: Dashboard(), // หน้าเริ่มต้นคือ LoginScreen
      routes: {
        'dashboard': (context) => Dashboard(), // หน้า Dashboard
        'register': (context) => RegisterScreen(), // หน้า Register
      },
    );
  }
}
