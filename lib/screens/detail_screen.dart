import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:final_project_2/models/wish_item.dart';

class DetailScreen extends StatefulWidget {
  final WishItem wish;
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
            onPressed: () {
              widget.toggleDone(); // Toggle status wishlist
              Navigator.pop(context);// Perbarui tampilan DetailScreen
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
                  return Image.asset(
                    widget.wish.image[index],
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                  );
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
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 169, 199, 243),
                  ),
                  child: Text(
                    'EDIT',
                    style: TextStyle(fontFamily: 'Poppins', color: Colors.black),
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => _showDeleteConfirmation(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 169, 199, 243),
                  ),
                  child: Text(
                    'DELETE',
                    style: TextStyle(fontFamily: 'Poppins', color: Colors.black),
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
                Navigator.of(context).pop(); // Tutup dialog
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
              onPressed: () {
                widget.onDelete(); // Panggil fungsi hapus
                Navigator.of(context).pop(); // Tutup dialog
                Navigator.of(context).pop(); // Kembali ke HomeScreen
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
