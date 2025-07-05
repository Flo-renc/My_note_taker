import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';
import '../providers/auth_provider.dart';
import '../core/utils/snackbar.dart';
import 'note_dialog.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoadingInitial = true;
  bool _isProcessing = false; // for add/update/delete

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    try {
      final noteProvider = Provider.of<NotesProvider>(context, listen: false);
      await noteProvider.loadNotes();
    } catch (e) {
      showSnackBar(context, "Failed to load notes.");
    } finally {
      setState(() {
        _isLoadingInitial = false;
      });
    }
  }

  void _logout() async {
    await Provider.of<AuthProvider>(context, listen: false).logout();
  }

  void _openNoteDialog({String? id, String? existingText}) {
    showDialog(
      context: context,
      builder: (_) => NoteDialog(
        noteId: id,
        initialText: existingText,
      ),
    );
  }

  Future<void> _deleteNote(String id) async {
    setState(() {
      _isProcessing = true;
    });

    try {
      final noteProvider = Provider.of<NotesProvider>(context, listen: false);
      await noteProvider.deleteNote(id);
      showSnackBar(context, "Note deleted.");
    } catch (e) {
      showSnackBar(context, "Failed to delete note.");
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NotesProvider>(context);
    final notes = noteProvider.notes;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Notes'),
        actions: [
          IconButton(onPressed: _logout, icon: Icon(Icons.logout)),
        ],
      ),
      body: _isLoadingInitial
          ? Center(child: CircularProgressIndicator())
          : notes.isEmpty
              ? Center(
                  child: Text(
                    'Nothing here yet—tap ➕ to add a note.',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return ListTile(
                      title: Text(note.text),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: _isProcessing
                                ? null
                                : () => _openNoteDialog(id: note.id, existingText: note.text),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: _isProcessing
                                ? null
                                : () => _deleteNote(note.id),
                          ),
                        ],
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isProcessing ? null : () => _openNoteDialog(),
        child: _isProcessing
            ? CircularProgressIndicator(color: Colors.white)
            : Icon(Icons.add),
      ),
    );
  }
}
