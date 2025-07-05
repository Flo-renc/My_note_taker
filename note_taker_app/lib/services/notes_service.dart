import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/note_model.dart';

class NotesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _userNotesCollection {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw FirebaseAuthException(
        code: 'NO_USER',
        message: 'No authenticated user found.',
      );
    }
    return _firestore.collection('users').doc(userId).collection('notes');
  }

  Future<List<NoteModel>> fetchNotes() async {
    final snapshot = await _userNotesCollection.orderBy('createdAt', descending: true).get();
    return snapshot.docs
        .map((doc) => NoteModel.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<void> addNote(String text) async {
    await _userNotesCollection.add({
      'text': text,
      'createdAt': FieldValue.serverTimestamp(), // for ordering
    });
  }

  Future<void> updateNote(String id, String text) async {
    await _userNotesCollection.doc(id).update({
      'text': text,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteNote(String id) async {
    await _userNotesCollection.doc(id).delete();
  }
}
