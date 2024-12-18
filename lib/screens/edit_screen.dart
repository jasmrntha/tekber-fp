import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_2/models/wish_item.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditItem extends StatefulWidget {
  final WishItem wishItem; // Receive the current wish item
  final String documentId; // Document ID of the item to update
  final Function(WishItem) onSave; // Callback for saving updated item

  const EditItem(
      {super.key,
      required this.wishItem,
      required this.onSave,
      required this.documentId});

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

  final List<String> categories = [
    'Household Item',
    'Electronics',
    'Clothing',
    'Groceries'
  ];

  @override
  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.wishItem.title);
    noteController = TextEditingController(text: widget.wishItem.note);
    linkController = TextEditingController(text: widget.wishItem.link);
    priceController =
        TextEditingController(text: widget.wishItem.price.toString());

    // Check if the selectedCategory is one of the valid options
    if (categories.contains(widget.wishItem.category)) {
      selectedCategory = widget.wishItem.category;
    } else {
      // If the category is invalid, use a default category
      selectedCategory = categories.first;
    }

    _selectedImages = widget.wishItem.image;
  }

  Future<void> _pickImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles != null) {
      final List<String> base64Images = [];
      for (var pickedFile in pickedFiles) {
        final bytes = await pickedFile.readAsBytes();
        final extension = pickedFile.name.split('.').last.toLowerCase();

        String mimeType = '';
        switch (extension) {
          case 'jpg':
          case 'jpeg':
            mimeType = 'image/jpeg';
            break;
          case 'png':
            mimeType = 'image/png';
            break;
          case 'gif':
            mimeType = 'image/gif';
            break;
          case 'webp':
            mimeType = 'image/webp';
            break;
          default:
            mimeType =
                'image/jpeg'; // Fallback to jpeg if the extension is unsupported
            break;
        }

        final base64Image = 'data:$mimeType;base64,${base64Encode(bytes)}';
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
          .collection(
              'wishlist_2') // Make sure you use the correct collection name
          .doc(widget.documentId) // Update the document using its ID
          .update(updatedItemData);

      // Call the onSave callback after successful Firestore update
      widget.onSave(WishItem(
        id: widget.wishItem.id,
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
              const Text("Categories",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              DropdownButton<String>(
                value: selectedCategory.isNotEmpty
                    ? selectedCategory
                    : categories.first, // Default fallback
                items: categories
                    .map((category) => DropdownMenuItem<String>(
                        value: category, child: Text(category)))
                    .toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedCategory = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text("Upload Images",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: _selectedImages.length,
                          itemBuilder: (context, index) {
                            try {
                              // Decode base64 string to bytes
                              final imageBytes = base64Decode(
                                  _selectedImages[index].split(',').last);

                              return Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.memory(
                                      imageBytes,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.red,
                                          child: const Center(
                                            child: Icon(Icons.error,
                                                color: Colors.white),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () => _removeImage(index),
                                    ),
                                  ),
                                ],
                              );
                            } catch (e) {
                              // Handle any errors that may occur during base64 decoding or image loading
                              return const Center(
                                  child: Icon(Icons.error, color: Colors.red));
                            }
                          },
                        )
                      : const Center(
                          child: Icon(Icons.add_a_photo, color: Colors.yellow)),
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
                child: const Text("SAVE",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
