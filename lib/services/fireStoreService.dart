import 'package:cloud_firestore/cloud_firestore.dart';

class Firestoreservice {
  final CollectionReference account =
      FirebaseFirestore.instance.collection('account');

  Future<void> addAccount(String email, password) {
    return account.add({'email': email, 'password': password});
  }

  Future<List<DocumentSnapshot>> getAccountInfo(String email) async {
    QuerySnapshot streams = await account.where('email', isEqualTo: email).get();
    return streams.docs;
  }
}
