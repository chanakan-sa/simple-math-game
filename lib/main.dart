import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screen/dashboard.dart';
import 'screen/login.dart';
import 'screen/register.dart';
import 'screen/game_screen_new.dart';
import 'screen/score_screen_new.dart';

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
      initialRoute: 'register',
      routes: {
        'register': (context) => RegisterScreen(),
        'login': (context) => LoginScreen(),
        'dashboard': (context) => Dashboard(playerName: ''),
        'gamescreen': (context) => GameScreen(
              playerName: '', 
              selectedOperator: '+',
            ),
        'scorescreen': (context) => ScoreScreen(
              playerName: '', 
              score: 0, 
              stars: 0,
            ),
      },
    );
  }
}
