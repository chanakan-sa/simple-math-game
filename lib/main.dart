import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screen/name_input_screen.dart'; // ✅ Import
import 'screen/dashboard.dart';
import 'screen/login.dart';
import 'screen/register.dart';

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
      title: 'Math_App',
      theme: ThemeData(
        primaryColor: Colors.blue,
        secondaryHeaderColor: Colors.blueAccent,
      ),
      initialRoute: 'register', // ✅ เริ่มที่หน้า Register
      routes: {
        'register': (context) => RegisterScreen(),
        'login': (context) => LoginScreen(),
        'nameInput': (context) => NameInputScreen(),
        'dashboard': (context) => Dashboard(playerName: ''),
      },
    );
  }
}
