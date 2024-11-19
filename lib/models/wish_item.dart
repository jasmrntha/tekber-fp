import 'package:uuid/uuid.dart';

class WishItem {
  final String id;
  final String title;
  final String note;
  final int price;
  final List<String> image;
  final String link;
  final String category;
  bool isDone;

  WishItem({
    String? id,
    required this.title,
    required this.note,
    required this.price,
    required this.image,
    required this.link,
    required this.category,
    this.isDone = false,
  }) : id = id ?? const Uuid().v4(); // Buat ID unik jika tidak disediakan
}
