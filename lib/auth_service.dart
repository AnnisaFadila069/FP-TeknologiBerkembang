import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<User?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      log("User created: ${cred.user?.email}");
      return cred.user;
    } on FirebaseAuthException catch (e) {
      log("FirebaseAuthException: ${e.message}");
      throw e.message ?? "Unknown error occurred.";
    } catch (e) {
      log("General Exception: $e");
      throw "An error occurred: $e";
    }
  }

  Future<User?> loginUserWithEmailAndPassword(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
      log("User logged in: ${cred.user?.email}");
      return cred.user;
    } on FirebaseAuthException catch (e) {
      log("FirebaseAuthException: ${e.message}");
      throw e.message ?? "Unknown error occurred.";
    } catch (e) {
      log("General Exception: $e");
      throw "An error occurred: $e";
    }
  }

  Future<void> signout() async {
    try {
      await _auth.signOut();
      log("User signed out.");
    } catch (e) {
      log("Error signing out: $e");
    }
  }

  Future<void> sendpasswordresetemail(String email) async{
    try{
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Error: ${e.toString()}');
      rethrow;
    }
  }
}
