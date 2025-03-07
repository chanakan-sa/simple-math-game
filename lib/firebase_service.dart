import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> saveScore(String playerName, int score, int stars) async {
    await _db.collection('scores').add({
      'name': playerName,
      'score': score,
      'stars': stars,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
