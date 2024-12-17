import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'wish_item.dart';

class WishRepository {
  Stream<List<WishItem>> fetchWishesStream() {
    // Get the current logged-in user's UID
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User is not logged in');
      return Stream.value([]); // Return an empty stream if no user
    }

    // Use snapshots() to create a stream of real-time updates
    return FirebaseFirestore.instance
        .collection('wishlist_2')
        .where('uid', isEqualTo: user.uid) // Filter by UID
        .snapshots()
        .map((querySnapshot) {
      print('Total documents found: ${querySnapshot.docs.length}');

      // Convert Firestore documents to WishItem objects
      final wishes = querySnapshot.docs.map((doc) {
        print('Document ID: ${doc.id}');
        return WishItem.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      print('Total wishes converted: ${wishes.length}');
      return wishes;
    });
  }

  Future<List<WishItem>> fetchWishes() async {
    try {
      // Get the current logged-in user's UID
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('User is not logged in');
        return [];
      }
      print('Logged in user UID: ${user.uid}');
      // Query Firestore for items that belong to the logged-in user
      final querySnapshot = await FirebaseFirestore.instance
          .collection('wishlist_2')
          .where('uid', isEqualTo: user.uid) // Filter by UID
          .get();

      print('Total documents found: ${querySnapshot.docs.length}');

      // Convert Firestore documents to WishItem objects
      final wishes = querySnapshot.docs.map((doc) {
        print('Document ID: ${doc.id}');
        return WishItem.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      print('Total wishes converted: ${wishes.length}');
      return wishes;
    } catch (error) {
      print('Detailed error fetching wishes: $error');
      return [];
    }
  }
}
