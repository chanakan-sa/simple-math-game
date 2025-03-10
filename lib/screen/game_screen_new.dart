import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  final String playerName;
  final String selectedOperator;

  GameScreen({required this.playerName, required this.selectedOperator});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int level = 1;
  int questionCount = 0;
  int score = 0;
  int timeLeft = 30;
  Timer? timer;
  int num1 = 0, num2 = 0, correctAnswer = 0;
  List<int> options = [];
  bool isButtonPressed = false;

  @override
  void initState() {
    super.initState();
    generateQuestion();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() => timeLeft--);
      } else {
        timer.cancel();
        showResultPopup();
      }
    });
  }

  void generateQuestion() {
    Random random = Random();
    num1 = random.nextInt(10 * level) + 1;
    num2 = random.nextInt(10 * level) + 1;
    switch (widget.selectedOperator) {
      case '+':
        correctAnswer = num1 + num2;
        break;
      case '-':
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
    setState(() => isButtonPressed = true);
    Future.delayed(Duration(milliseconds: 200), () => setState(() => isButtonPressed = false));

    if (selectedAnswer == correctAnswer) {
      setState(() => score++);
    }
    questionCount++;

    if (questionCount >= 10) {
      showResultPopup();
    } else {
      generateQuestion();
    }
  }

  void showResultPopup() {
    timer?.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("เลเวล $level จบแล้ว!", textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("คะแนนของคุณ: $score", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            if (level < 5)
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    level++;
                    questionCount = 0;
                    score = 0;
                    timeLeft = 30;
                    generateQuestion();
                    startTimer();
                  });
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
                child: Text("ไปเลเวลถัดไป", style: TextStyle(fontSize: 18, color: Colors.white)),
              )
            else
              Text("คุณเล่นครบทุกเลเวลแล้ว! 🎉", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.redAccent)),
          ],
        ),
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
        title: Text('Math Challenge - เลเวล $level', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 5,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade100, Colors.blueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('ผู้เล่น: ${widget.playerName}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(height: 10),
              
              LinearProgressIndicator(
                value: timeLeft / 30,
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
                minHeight: 10,
              ),
              SizedBox(height: 20),
              
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 5,
                child: Padding(
                  padding: EdgeInsets.all(25),
                  child: Column(
                    children: [
                      Text('$num1 ${widget.selectedOperator} $num2 = ?', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: options.map((option) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: ElevatedButton(
                              onPressed: () => checkAnswer(option),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), elevation: 5),
                              child: Text(option.toString(), style: TextStyle(fontSize: 22, color: Colors.white)),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}