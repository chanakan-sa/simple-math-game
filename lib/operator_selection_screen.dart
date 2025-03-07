import 'package:flutter/material.dart';
import 'game_screen.dart';
import 'main.dart';

class OperatorSelectionScreen extends StatelessWidget {
  final String playerName;
  OperatorSelectionScreen({required this.playerName});

  void startGame(BuildContext context, String selectedOperator) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(playerName: playerName, selectedOperator: selectedOperator),
      ),
    );
  }

  void _showExitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(
            'ออกจากหน้านี้?',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          ),
          content: Text(
            'คุณต้องการกลับไปที่หน้าแรกใช่หรือไม่?',
            style: TextStyle(fontSize: 18),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              child: Text('ไม่', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SimpleMathGame()),
                  (Route<dynamic> route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              child: Text('ใช่', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เลือกประเภทการคำนวณ', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () => _showExitConfirmationDialog(context),
        ),
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
