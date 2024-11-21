import 'dart:html' as html;
import 'dart:convert';
import 'package:flutter/material.dart';

// WebDataStorage: To handle saving and retrieving data
class WebDataStorage {
  // Save all data to localStorage
  static void saveData({
    required String title,
    required String note,
    required int price,
    required String link,
    required String category,
    required List<String> imagePaths,
  }) {
    final data = {
      'title': title,
      'note': note,
      'price': price,
      'link': link,
      'category': category,
      'images': imagePaths,
    };
    html.window.localStorage['wishlist_data'] = json.encode(data);
  }

  // Retrieve all data from localStorage
  static Map<String, dynamic> getData() {
    final storedData = html.window.localStorage['wishlist_data'];
    if (storedData != null) {
      return json.decode(storedData);
    }
    return {};  // Return an empty map if no data exists
  }

  // Clear all saved data
  static void clearData() {
    html.window.localStorage.remove('wishlist_data');
  }
}

// WishItem: A model for wish items
class WishItem {
  String title;
  String note;
  int price;
  String link;
  String category;
  List<String> imagePaths;

  WishItem({
    required this.title,
    required this.note,
    required this.price,
    required this.link,
    required this.category,
    required this.imagePaths,
  });
}

// Method to create a new WishItem from the data stored in localStorage
WishItem createWishFromLocalStorage() {
  final data = WebDataStorage.getData();

  if (data.isEmpty) {
    return WishItem(
      title: 'No Data',
      note: 'No Data',
      price: 0,
      link: '',
      category: '',
      imagePaths: [],
    );
  }

  return WishItem(
    title: data['title'] ?? 'Unknown',
    note: data['note'] ?? 'No description',
    price: data['price'] ?? 0,
    link: data['link'] ?? '',
    category: data['category'] ?? 'Uncategorized',
    imagePaths: List<String>.from(data['images'] ?? []),
  );
}