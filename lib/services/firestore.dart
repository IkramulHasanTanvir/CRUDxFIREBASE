import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud/models/note_model.dart';


class FireStoreService {
  final CollectionReference notes =
  FirebaseFirestore.instance.collection('notes');

  // create notes.
  Future<void> addNote(String note) {
    return notes.add({
      'note': note,
      'timestamp': Timestamp.now(),
    });
  }

  // get notes.
  void getNote(
      QuerySnapshot<Map<String, dynamic>>? snapshot, List<NoteModel> noteList) {
    noteList.clear();
    for (DocumentSnapshot doc in snapshot?.docs ?? []) {
      noteList.add(NoteModel.fromFireStore(doc));
    }
  }

  //update notes
  Future<void> updateNotes(String docId, String newNote) {
    return notes.doc(docId).update({
      'note': newNote,
      'timestamp': Timestamp.now(),
    });
  }

  // delete notes
  Future<void> deleteNotes(docId) {
    return notes.doc(docId).delete();
  }
}
