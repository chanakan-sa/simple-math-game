import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'game_screen_new.dart';

class Dashboard extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String playerName;

  Dashboard({required this.playerName});

  void logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, 'login');
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
        title: Center(child: Text("Simple Math Game")),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.blueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('ยินดีต้อนรับ, $playerName!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(height: 20),
              _buildGameModeCard(context, 'บวก', '+', Icons.add),
              _buildGameModeCard(context, 'ลบ', '-', Icons.remove),
              _buildGameModeCard(context, 'คูณ', '×', Icons.close),
              _buildGameModeCard(context, 'หาร', '÷', Icons.horizontal_split),
              SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () => logout(context),
                style: _logoutButtonStyle(),
                icon: Icon(Icons.exit_to_app, color: Colors.white),
                label: Text('ออกจากระบบ', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameModeCard(BuildContext context, String title, String operator, IconData icon) {
    return GestureDetector(
      onTap: () => startGame(context, operator),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.blueAccent),
              SizedBox(width: 15),
              Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
            ],
          ),
        ),
      ),
    );
  }

  ButtonStyle _logoutButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.redAccent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      elevation: 5,
    );
  }
}
