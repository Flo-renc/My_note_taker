import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';
import '../core/utils/snackbar.dart';

class NoteDialog extends StatefulWidget {
  final String? noteId;
  final String? initialText;

  const NoteDialog({this.noteId, this.initialText, Key? key}) : super(key: key);

  @override
  State<NoteDialog> createState() => _NoteDialogState();
}

class _NoteDialogState extends State<NoteDialog> {
  late TextEditingController _controller;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _saveNote() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      if (mounted) showSnackBar(context, "Note cannot be empty.");
      return;
    }

    setState(() => _isLoading = true);

    final noteProvider = Provider.of<NotesProvider>(context, listen: false);

    try {
      if (widget.noteId == null) {
        await noteProvider.addNote(text);
        if (mounted) showSnackBar(context, "Note added.");
      } else {
        await noteProvider.updateNote(widget.noteId!, text);
        if (mounted) showSnackBar(context, "Note updated.");
      }
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) showSnackBar(context, "Error saving note.");
      // Optional: print for debugging
      // print('Error in _saveNote: $e\n$stack');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.noteId == null ? 'Add Note' : 'Edit Note'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        maxLines: 5,
        enabled: !_isLoading,
        decoration: const InputDecoration(
          hintText: 'Enter your note here',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          )
        else ...[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: _saveNote,
            child: Text(widget.noteId == null ? 'Add' : 'Update'),
          ),
        ]
      ],
    );
  }
}
