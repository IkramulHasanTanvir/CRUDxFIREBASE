import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  final String id;
  final String note;
  final Timestamp timestamp;

  NoteModel({
    required this.id,
    required this.note,
    required this.timestamp,
  });

  factory NoteModel.fromFireStore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NoteModel(
      id: doc.id,
      note: data['note'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }
}
