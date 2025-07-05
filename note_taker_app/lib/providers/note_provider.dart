import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../services/notes_service.dart';

class NotesProvider with ChangeNotifier {
  final NotesService _notesService = NotesService();

  List<NoteModel> _notes = [];
  bool _isLoading = false;
  String? _error;

  List<NoteModel> get notes => _notes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadNotes() async {
    _setLoading(true);
    _setError(null);
    try {
      _notes = await _notesService.fetchNotes();
    } catch (e) {
      debugPrint('Failed to load notes: $e');
      _setError('Failed to load notes.');
    }
    _setLoading(false);
  }

  Future<void> addNote(String text) async {
    _setLoading(true);
    _setError(null);
    try {
      await _notesService.addNote(text);
      await loadNotes(); // reload from server
    } catch (e) {
      debugPrint('Failed to add note: $e');
      _setError('Failed to add note.');
    }
    _setLoading(false);
  }

  Future<void> updateNote(String id, String text) async {
    _setLoading(true);
    _setError(null);
    try {
      await _notesService.updateNote(id, text);
      await loadNotes();
    } catch (e) {
      debugPrint('Failed to update note: $e');
      _setError('Failed to update note.');
    }
    _setLoading(false);
  }

  Future<void> deleteNote(String id) async {
    _setLoading(true);
    _setError(null);
    try {
      await _notesService.deleteNote(id);
      await loadNotes();
    } catch (e) {
      debugPrint('Failed to delete note: $e');
      _setError('Failed to delete note.');
    }
    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _error = message;
    notifyListeners();
  }
}
