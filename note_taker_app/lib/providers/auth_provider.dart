import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;

  User? get user => _user;

  AuthProvider() {
    _user = FirebaseAuth.instance.currentUser;
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<String?> signUp(String email, String password) async {
    final result = await _authService.signUp(email, password);
    return result;
  }

  Future<String?> login(String email, String password) async {
    final result = await _authService.login(email, password);
    return result;
  }

  Future<void> logout() async {
    await _authService.logout();
  }
}
