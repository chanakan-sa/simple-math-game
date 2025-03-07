import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScoreScreen extends StatelessWidget {
   final String playerName;
  final int score;
  final int stars;

  ScoreScreen({required this.playerName, required this.score, required this.stars});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('High Scores')),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('scores').orderBy('score', descending: true).limit(10).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          var scores = snapshot.data!.docs;
          return ListView.builder(
            itemCount: scores.length,
            itemBuilder: (context, index) {
              var data = scores[index];
              return ListTile(
                title: Text('${data['name']} - ${data['score']} points'),
                subtitle: Text('${data['stars']} ⭐'),
              );
            },
          );
        },
      ),
    );
  }
}