import 'package:cloud_firestore/cloud_firestore.dart';

class Firestoreservice {
  final CollectionReference account =
      FirebaseFirestore.instance.collection('account');

  Future<void> addAccount(String email, password) {
    return account.add({'email': email, 'password': password});
  }

  Stream<QuerySnapshot> getAccountInfo() {
    final accountInfo = account.orderBy('email', descending: true).snapshots();
    return accountInfo;
  }
}
