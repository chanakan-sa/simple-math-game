import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math';
import 'firebase_service.dart';
import 'score_screen.dart';

class GameScreen extends StatefulWidget {
  final String playerName;
  final String selectedOperator;

  GameScreen({required this.playerName, required this.selectedOperator});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int num1 = 0, num2 = 0, correctAnswer = 0;
  List<int> options = [];
  int score = 0;
  int stars = 0;
  int questionCount = 0;
  Timer? timer;
  int totalTime = 20; // เปลี่ยนเป็นเวลารวมสำหรับ 10 ข้อ

  @override
  void initState() {
    super.initState();
    generateQuestion();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (totalTime > 0) {
        setState(() => totalTime--);
      } else {
        timer.cancel();
        showResultPopup();
      }
    });
  }

  void generateQuestion() {
    Random random = Random();
    num1 = random.nextInt(10) + 1;
    num2 = random.nextInt(10) + 1;
    String operator = widget.selectedOperator;
    
    switch (operator) {
      case '+':
        correctAnswer = num1 + num2;
        break;
      case '-':
        if (num1 < num2) {
          int temp = num1;
          num1 = num2;
          num2 = temp;
        }
        correctAnswer = num1 - num2;
        break;
      case '×':
        correctAnswer = num1 * num2;
        break;
      case '÷':
        num2 = (num2 == 0) ? 1 : num2;
        num1 = num2 * (random.nextInt(5) + 1);
        correctAnswer = num1 ~/ num2;
        break;
    }
    
    options = [correctAnswer, correctAnswer + 1, correctAnswer - 1];
    options.shuffle();
    setState(() {});
  }

  void checkAnswer(int selectedAnswer) {
    if (selectedAnswer == correctAnswer) {
      setState(() {
        score++;
        stars = score;
      });
      FirebaseService.saveScore(widget.playerName, score, stars);
    }

    questionCount++;

    if (questionCount >= 10 || totalTime <= 0) {
      showResultPopup();
    } else {
      generateQuestion();
    }
  }

  void showResultPopup() {
    timer?.cancel();
    String message = score >= 7 ? "สุดยอด! 🎉" : "ลองใหม่ได้นะ! 😊";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("หมดเวลา!! ผลลัพธ์ของคุณ", textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(stars, (index) => Icon(Icons.star, color: Colors.amber, size: 30)),
            )
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ScoreScreen(playerName: widget.playerName, score: score, stars: stars),
                ),
              );
            },
            child: Text("ดูคะแนน", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Math Challenge', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 5,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.blueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('ผู้เล่น: ${widget.playerName}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(height: 10),
              Text('เวลาที่เหลือ: $totalTime วินาที', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.redAccent)),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                ),
                child: Column(
                  children: [
                    Text('$num1 ${widget.selectedOperator} $num2 = ?', style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: options.map((option) => ElevatedButton(
                        onPressed: () => checkAnswer(option),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                        ),
                        child: Text(option.toString(), style: TextStyle(fontSize: 24, color: Colors.white)),
                      )).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
