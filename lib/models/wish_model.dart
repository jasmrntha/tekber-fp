import 'package:flutter/material.dart';
import 'wish_item.dart';

class WishModel extends ChangeNotifier {
  final List<WishItem> _wishes = [];

  List<WishItem> get wishes => List.unmodifiable(_wishes);

  void addWish(WishItem wish) {
    _wishes.add(wish);
    notifyListeners();
  }

  void updateWish(WishItem updatedWish) {
    final index = _wishes.indexWhere((wish) => wish.id == updatedWish.id);
    if (index != -1) {
      _wishes[index] = updatedWish;
      notifyListeners();
    }
  }

  void deleteWish(String id) {
    _wishes.removeWhere((wish) => wish.id == id);
    notifyListeners();
  }
}
