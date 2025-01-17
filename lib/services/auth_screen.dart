import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Register new user and add user-specific data
  Future<User?> registerUser(String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'email': email,
          'role': "users",
          'createdAt': FieldValue.serverTimestamp(),
        });

        await _firestore.collection('userProfiles').doc(user.uid).set({
          'age': 0,
          'bio': '',
          'profilePicUrl': '',
        });

        // Store valid_user in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('valid_user', true);
      }
      return user;
    } catch (e) {
      print("Registration failed: $e");
      return null;
    }
  }

  // Sign in user
  Future<User?> signInUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        // Store valid_user in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('valid_user', true);
      }
      return user;
    } catch (e) {
      print("Sign-in failed: $e");
      return null;
    }
  }

  // Get user role
  Future<String?> getUserRole(String uid) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return doc['role'];
    }
    return null;
  }

  // Get user profile data (like username, age, etc.)
  Future<Map<String, dynamic>> getUserProfile(String uid) async {
    DocumentSnapshot doc =
        await _firestore.collection('userProfiles').doc(uid).get();
    if (doc.exists) {
      return doc.data() as Map<String, dynamic>;
    }
    return {};
  }

  // Update user profile data
  Future<void> updateUserProfile(
      String uid, String username, int age, String bio) async {
    try {
      await _firestore.collection('userProfiles').doc(uid).update({
        'username': username,
        'age': age,
        'bio': bio,
      });
    } catch (e) {
      print("Profile update failed: $e");
    }
  }

  // Sign out user and clear SharedPreferences
  Future<void> signOut() async {
    await _auth.signOut();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(
        'valid_user', false); // Set valid_user to false on logout
  }
}
