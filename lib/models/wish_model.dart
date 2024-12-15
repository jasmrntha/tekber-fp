import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_2/models/wish_repository.dart';
import 'package:flutter/material.dart';
import 'wish_item.dart';

class WishModel extends ChangeNotifier {
  List<WishItem> _wishes = [];

  List<WishItem> get wishes => List.unmodifiable(_wishes);

  // Fetch wishes from Firestore
  Future<void> loadWishes() async {
    final repository = WishRepository();
    _wishes = await repository.fetchWishes();
    notifyListeners();  // Notifies listeners after data is fetched
  }

  // Method to add a wish (if needed)
  void addWish(WishItem wish) {
    _wishes.add(wish);
    notifyListeners();
  }

  // Method to update a wish
  void updateWish(WishItem updatedWish) {
    final index = _wishes.indexWhere((wish) => wish.id == updatedWish.id);
    if (index != -1) {
      _wishes[index] = updatedWish;
      notifyListeners();
    }
  }

  // Method to delete a wish
  void deleteWish(String id) {
    _wishes.removeWhere((wish) => wish.id == id);
    notifyListeners();
  }
}
