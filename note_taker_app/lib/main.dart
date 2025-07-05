import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';  // Add provider package
import 'firebase_options.dart';
import 'app.dart';
import 'providers/note_provider.dart'; // Import your NotesProvider

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => NotesProvider()..loadNotes(), // Load notes immediately
      child: MyApp(),
    ),
  );
}
