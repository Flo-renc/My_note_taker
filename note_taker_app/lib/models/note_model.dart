class NoteModel {
  final String id;
  final String text;

  NoteModel({required this.id, required this.text});

  // Convert Firestore document to NoteModel
  factory NoteModel.fromMap(String id, Map<String, dynamic> data) {
    return NoteModel(
      id: id,
      text: data['text'] ?? '',
    );
  }

  // Convert NoteModel to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'text': text,
    };
  }
}
