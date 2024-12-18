import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountServices {
  final CollectionReference account =
      FirebaseFirestore.instance.collection('account');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addAccount(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await account.add({'email': email, 'password': password});
    } on FirebaseAuthException catch (e) {
      print("Error creating account: ${e.message}");
      rethrow;
    }
  }

  Future<List<DocumentSnapshot>> getAccountInfo(String email) async {
    try {
      QuerySnapshot snapshot =
          await account.where('email', isEqualTo: email).get();
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

class AuthServices {
  final _auth = FirebaseAuth.instance;

  Future sendLinkEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(
        email: email,
      );
    } on FirebaseAuthException catch (_) {
      rethrow;
    }
  }

  Future<void> signUpAccount(String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        await userCredential.user!.sendEmailVerification();
        print(
            'Verification email has been sent to ${userCredential.user!.email}');
      }
    } on FirebaseAuthException catch (_) {
      rethrow;
    }
  }

  Future<String?> userInDatabase(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email';
      } else if (e.code == 'invalid-email') {
        return 'The email address is badly formatted';
      } else if (e.code == 'user-disabled') {
        return 'The user account has been disabled';
      } else if (e.code == 'wrong-password') {
        return 'The password is invalid for the given email';
      } else {
        return 'Email was not registered or password is wrong';
      }
    }
  }
}
