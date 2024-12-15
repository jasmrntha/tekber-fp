import 'package:cloud_firestore/cloud_firestore.dart';
import 'wish_item.dart';

class WishRepository {
  Future<List<WishItem>> fetchWishes() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('wishlist_2').get();
      print('Total documents found: ${querySnapshot.docs.length}');

      final wishes = querySnapshot.docs.map((doc) {
        print('Document ID: ${doc.id}');
        // print('Document Data: ${doc.data()}');

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
