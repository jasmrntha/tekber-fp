import 'package:flutter/material.dart';

class WishModel with ChangeNotifier {
  List<String> _wishes = []; // Daftar wish Anda

  List<String> get wishes => _wishes;

  void addWish(String wish) {
    _wishes.add(wish);
    notifyListeners(); // Memberitahu UI untuk memperbarui
  }

  void removeWish(String wish) {
    _wishes.remove(wish);
    notifyListeners(); // Memberitahu UI untuk memperbarui
  }
}
