import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_2/models/wish_item.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditItem extends StatefulWidget {
  final WishItem wishItem; // Receive the current wish item
  final String documentId; // Document ID of the item to update
  final Function(WishItem) onSave; // Callback for saving updated item

  const EditItem({super.key, required this.wishItem, required this.onSave, required this.documentId});

  @override
  State<EditItem> createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  late TextEditingController titleController;
  late TextEditingController noteController;
  late TextEditingController linkController;
  late TextEditingController priceController;

  String selectedCategory = '';
  List<String> _selectedImages = []; // Store images as base64 strings

  final List<String> categories = ['Household Item', 'Fashion', 'Sport', 'Books'];

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.wishItem.title);
    noteController = TextEditingController(text: widget.wishItem.note);
    linkController = TextEditingController(text: widget.wishItem.link);
    priceController = TextEditingController(text: widget.wishItem.price.toString());

    selectedCategory = widget.wishItem.category;
    _selectedImages = widget.wishItem.image;
  }

  Future<void> _pickImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles != null) {
      final List<String> base64Images = [];
      for (var pickedFile in pickedFiles) {
        final bytes = await pickedFile.readAsBytes();
        final base64Image = 'data:image/jpeg;base64,${base64Encode(bytes)}';
        base64Images.add(base64Image);
      }
      setState(() {
        _selectedImages.addAll(base64Images);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    noteController.dispose();
    linkController.dispose();
    priceController.dispose();
    super.dispose();
  }

  Future<void> _updateItemInFirestore() async {
    try {
      // Create a map to store the updated data
      Map<String, dynamic> updatedItemData = {
        'title': titleController.text,
        'note': noteController.text,
        'price': double.tryParse(priceController.text) ?? 0,
        'link': linkController.text,
        'category': selectedCategory,
        'image': _selectedImages,
        'isDone': widget.wishItem.isDone, // Retain the "isDone" state
      };

      // Update the document in Firestore using the document ID
      await FirebaseFirestore.instance
          .collection('wish_items') // Make sure you use the correct collection name
          .doc(widget.documentId) // Update the document using its ID
          .update(updatedItemData);

      // Call the onSave callback after successful Firestore update
      widget.onSave(WishItem(
        title: titleController.text,
        note: noteController.text,
        image: _selectedImages,
        price: double.tryParse(priceController.text) ?? 0,
        link: linkController.text,
        category: selectedCategory,
        isDone: widget.wishItem.isDone, // Retain the "isDone" state
      ));

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item updated successfully!')),
      );

      // Pop the Edit screen and return to the previous screen
      Navigator.pop(context);
    } catch (e) {
      // Handle error during the update process
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating item: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Wish',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.yellow,
          ),
        ),
        backgroundColor: Colors.blue[900],
        iconTheme: IconThemeData(color: Colors.yellow),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Item Name"),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: noteController,
                decoration: const InputDecoration(labelText: "Note"),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Price"),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: linkController,
                decoration: const InputDecoration(labelText: "Link"),
              ),
              const SizedBox(height: 16),
              const Text("Categories", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              DropdownButton<String>(
                value: selectedCategory,
                items: categories
                    .map((category) => DropdownMenuItem<String>(value: category, child: Text(category)))
                    .toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedCategory = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text("Upload Images", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickImages,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[400]!),
                  ),
                  child: _selectedImages.isNotEmpty
                      ? GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: _selectedImages.length,
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(_selectedImages[index], fit: BoxFit.cover),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _removeImage(index),
                                  ),
                                ),
                              ],
                            );
                          },
                        )
                      : const Center(child: Icon(Icons.add_a_photo, color: Colors.yellow)),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _updateItemInFirestore,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue[900],
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: BorderSide(color: Colors.blue[200]!),
                ),
                child: const Text("SAVE", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
