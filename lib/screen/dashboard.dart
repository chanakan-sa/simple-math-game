import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:math_game/screen/game_screen_new.dart';


class Dashboard extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String playerName;

  Dashboard({required this.playerName});

  void logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  void startGame(BuildContext context, String selectedOperator) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(playerName: playerName, selectedOperator: selectedOperator),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เลือกประเภทการคำนวณ'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('ผู้เล่น: $playerName', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
            SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              children: [
                _buildOperatorButton(context, '+', 'บวก'),
                _buildOperatorButton(context, '-', 'ลบ'),
                _buildOperatorButton(context, '×', 'คูณ'),
                _buildOperatorButton(context, '÷', 'หาร'),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.blue.shade100,
    );
  }

  Widget _buildOperatorButton(BuildContext context, String operator, String label) {
    return ElevatedButton(
      onPressed: () => startGame(context, operator),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        padding: EdgeInsets.symmetric(vertical: 20),
      ),
      child: Text(label, style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }
}