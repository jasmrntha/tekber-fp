import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountServices {
  final CollectionReference account =
      FirebaseFirestore.instance.collection('account');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addAccount(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await account.add({'email': email, 'password': password});
    } on FirebaseAuthException catch (e) {
      print("Error creating account: ${e.message}");
      rethrow;
    }
  }

  Future<List<DocumentSnapshot>> getAccountInfo(String email) async {
    try {
      QuerySnapshot snapshot = await account.where('email', isEqualTo: email).get();
      return snapshot.docs;
    } catch (e) {
      print("Error fetching account info: $e");
      rethrow;
    }
  }

  Future<void> sendResetPasswordLink(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      print("Error sending password reset email: ${e.message}");
      rethrow;
    }
  }
}
