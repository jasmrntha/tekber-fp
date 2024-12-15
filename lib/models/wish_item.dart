import 'dart:convert';
import 'dart:typed_data';

class WishItem {
  final String? id;
  final String title;
  final String note;
  final List<String> image;  // Base64 encoded strings
  final double price;
  final String link;
  final String category;
  bool isDone;

  WishItem({
    this.id,
    required this.title,
    required this.note,
    required this.image,
    required this.price,
    required this.link,
    required this.category,
    this.isDone = false,
  });

  // Factory method to create a WishItem from Firestore data
  factory WishItem.fromFirestore(Map<String, dynamic> data, String id) {
    return WishItem(
      id: id,
      title: data['title'] ?? 'No Title',
      note: data['note'] ?? 'No Note',
      image: data['image'] is List ? List<String>.from(data['image']) : [],
      price: data['price'] is num ? (data['price'] as num).toDouble() : 0.0,
      link: data['link'] ?? '',
      category: data['category'] ?? 'Uncategorized',
      isDone: data['isDone'] ?? false,
    );
  }

  // Decode images into a list of Uint8List
  List<Uint8List> get decodedImages {
    return image.map((img) {
      try {
        // Extract the base64 part after the prefix
        final base64String = img.split('base64,').last;
        return base64Decode(base64String);
      } catch (e) {
        print('Error decoding image: $e');
        return Uint8List(0);  // Return empty list if decoding fails
      }
    }).toList();
  }

  void toggleDone() {
    isDone = !isDone;
  }
}
