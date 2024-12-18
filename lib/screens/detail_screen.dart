import 'dart:convert'; // Import for base64 decoding
import 'package:final_project_2/screens/edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:final_project_2/models/wish_item.dart';
import 'package:final_project_2/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DetailScreen extends StatefulWidget {
  WishItem wish;
  final VoidCallback toggleDone;
  final VoidCallback onDelete;

  DetailScreen({
    required this.wish,
    required this.toggleDone,
    required this.onDelete,
  });

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    String formattedPrice = NumberFormat.currency(
      locale: 'id',
      symbol: '',
      decimalDigits: 0,
    ).format(widget.wish.price);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.yellow,
          ),
        ),
        backgroundColor: Colors.blue[900],
        iconTheme: IconThemeData(color: Colors.yellow),
        actions: [
          TextButton(
            onPressed: () async {
              // Perbarui nilai di lokal
              widget.toggleDone();

              // Perbarui nilai di Firebase
              try {
                await FirebaseFirestore.instance
                    .collection('wishlist_2')
                    .doc(widget.wish.id)
                    .update({
                  'isDone': widget.wish.isDone,
                });
              } catch (e) {
                print('Gagal memperbarui data: $e');
              }
              Navigator.pop(context);
            },
            child: Padding(
              padding: EdgeInsets.only(right: 16),
              child: Text(
                widget.wish.isDone ? 'Undone' : 'Done',
                style: TextStyle(
                  color: Colors.yellow,
                  fontFamily: 'Poppins',
                  fontSize: 21,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.wish.title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            SizedBox(
              height: 300,
              child: PageView.builder(
                itemCount: widget.wish.image.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  try {
                    // Extract base64 string after the prefix
                    final base64String =
                        widget.wish.image[index].split('base64,').last;

                    // Decode the base64 string and display the image
                    final imageBytes = base64Decode(base64String);

                    return Image.memory(
                      imageBytes,
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        // Handle errors in loading the image (e.g., invalid base64 data)
                        return Container(
                          color: Colors.grey,
                          child: const Center(
                            child: Icon(Icons.error, color: Colors.white),
                          ),
                        );
                      },
                    );
                  } catch (e) {
                    // Handle errors during base64 decoding
                    return Container(
                      color: Colors.grey,
                      child: const Center(
                        child: Icon(Icons.error, color: Colors.white),
                      ),
                    );
                  }
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.wish.image.length,
                (index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index ? Colors.blue : Colors.grey,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('Note \t \t \t \t ', widget.wish.note),
                  SizedBox(height: 8),
                  _buildDetailRow('Price \t \t \t \t ', 'Rp. $formattedPrice'),
                  SizedBox(height: 8),
                  _buildDetailRow('Link \t \t \t \t \t ', widget.wish.link),
                  SizedBox(height: 8),
                  _buildDetailRow('Category', widget.wish.category),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditItem(
                          wishItem: widget.wish, // Pass the current wish item
                          documentId: widget.wish.id ?? '',
                          onSave: (updatedWishItem) {
                            setState(() {
                              widget.wish =
                                  updatedWishItem; // Update the wish with new data
                            });
                          },
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'EDIT',
                    style:
                        TextStyle(fontFamily: 'Poppins', color: Colors.black),
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => _showDeleteConfirmation(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: Text(
                    'DELETE',
                    style:
                        TextStyle(fontFamily: 'Poppins', color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      children: [
        Text(
          '$label:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 16, fontFamily: 'Poppins'),
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Wishlist',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          content: Text(
            'Are you sure you want to delete this wishlist?',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Delete data from Firebase
                  await FirebaseFirestore.instance
                      .collection('wishlist_2')
                      .doc(widget.wish.id)
                      .delete();

                  // Ensure widget is still mounted before calling callback or showing a SnackBar
                  if (mounted) {
                    widget.onDelete();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Wishlist successfully deleted')),
                    );

                    // Use only one pop to close both the dialog and go back
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  }
                } catch (e) {
                  print('Error deleting wishlist: $e');

                  // Show error message only if the widget is still mounted
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to delete wishlist')),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text(
                'OK',
                style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
