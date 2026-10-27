import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String uid;
  final String name;
  final String fatherName;
  final String email;

  UserModel({
    required this.uid,
    required this.name,
    required this.fatherName,
    required this.email,
  });
}

class AuthService {
  AuthService._privateConstructor();

  static final AuthService instance = AuthService._privateConstructor();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  /// Check if user is currently signed in
  bool get isSignedIn => _auth.currentUser != null;

  /// Registers user with Firebase Authentication and saves profile into Cloud Firestore
  Future<String?> signUp({
    required String name,
    required String fatherName,
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        return 'Registration failed: user object is null.';
      }

      // Update Firebase Auth Display Name
      await user.updateDisplayName(name.trim());

      final newUser = UserModel(
        uid: user.uid,
        name: name.trim(),
        fatherName: fatherName.trim(),
        email: email.trim().toLowerCase(),
      );

      // Save user profile details to Firestore 'users' collection
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': name.trim(),
        'fatherName': fatherName.trim(),
        'email': email.trim().toLowerCase(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      _currentUser = newUser;
      return null;
    } on FirebaseAuthException catch (e) {
      return _handleAuthException(e);
    } catch (e) {
      return 'An error occurred during registration: ${e.toString()}';
    }
  }

  /// Logs in user with Firebase Authentication and fetches profile from Cloud Firestore
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        return 'Login failed: user not found.';
      }

      // Retrieve full user profile from Firestore Database
      final doc = await _firestore.collection('users').doc(user.uid).get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        _currentUser = UserModel(
          uid: user.uid,
          name: data['name'] ?? user.displayName ?? 'User',
          fatherName: data['fatherName'] ?? '',
          email: data['email'] ?? user.email ?? email,
        );
      } else {
        // Fallback to Auth credentials if firestore doc not found
        _currentUser = UserModel(
          uid: user.uid,
          name: user.displayName ?? 'User',
          fatherName: '',
          email: user.email ?? email,
        );
      }

      return null;
    } on FirebaseAuthException catch (e) {
      return _handleAuthException(e);
    } catch (e) {
      return 'An error occurred during login: ${e.toString()}';
    }
  }

  /// Sends password reset email
  Future<String?> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return null;
    } on FirebaseAuthException catch (e) {
      return _handleAuthException(e);
    } catch (e) {
      return 'Failed to send reset email: ${e.toString()}';
    }
  }

  /// Restores session from existing Firebase Auth user if available
  Future<void> reloadUserSession() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists && doc.data() != null) {
          final data = doc.data()!;
          _currentUser = UserModel(
            uid: user.uid,
            name: data['name'] ?? user.displayName ?? 'User',
            fatherName: data['fatherName'] ?? '',
            email: data['email'] ?? user.email ?? '',
          );
        }
      } catch (_) {}
    }
  }

  /// Signs out user from Firebase Auth
  Future<void> logout() async {
    await _auth.signOut();
    _currentUser = null;
  }

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'This email is already registered. Please log in.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'weak-password':
        return 'The password is too weak. Please use at least 6 characters.';
      case 'user-not-found':
        return 'No account found with this email. Please sign up first.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-credential':
        return 'Invalid email or password. Please verify your credentials.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again in a few moments.';
      case 'network-request-failed':
        return 'Network connection failed. Please check your internet connection.';
      default:
        return e.message ?? 'An authentication error occurred (${e.code}).';
    }
  }
}
