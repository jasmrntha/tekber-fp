class WishItem {
  final String title;
  final String note;
  final int price;
  final List<String> image;
  final String link;
  final String category;
  bool isDone;

  WishItem({
    required this.title,
    required this.note,
    required this.price,
    required this.image,
    required this.link,
    required this.category,
    this.isDone = false,
  });
}
