import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';
import '../providers/auth_provider.dart';
import '../core/utils/snackbar.dart';
import 'note_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoadingInitial = true;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    try {
      final noteProvider = Provider.of<NotesProvider>(context, listen: false);
      await noteProvider.loadNotes();
      if (!mounted) return;
    } catch (e) {
      if (!mounted) return;
      showSnackBar(context, "Failed to load notes.");
    } finally {
      // ignore: control_flow_in_finally
      if (!mounted) return;
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
      if (!mounted) return;
      showSnackBar(context, "Note deleted.");
    } catch (e) {
      if (!mounted) return;
      showSnackBar(context, "Failed to delete note.");
    } finally {
      // ignore: control_flow_in_finally
      if (!mounted) return;
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
        title: const Text('My Notes'),
        actions: [
          IconButton(onPressed: _logout, icon: const Icon(Icons.logout)),
        ],
      ),
      body: _isLoadingInitial
          ? const Center(child: CircularProgressIndicator())
          : notes.isEmpty
              ? const Center(
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
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: _isProcessing
                                ? null
                                : () => _openNoteDialog(
                                      id: note.id,
                                      existingText: note.text,
                                    ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
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
            ? const CircularProgressIndicator(color: Colors.white)
            : const Icon(Icons.add),
      ),
    );
  }
}
