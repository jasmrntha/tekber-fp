import 'dart:convert';
import 'package:final_project_2/models/wish_item.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditItem extends StatefulWidget {
  final WishItem wishItem; // Receive the current wish item
  final Function(WishItem) onSave; // Callback for saving updated item

  const EditItem({super.key, required this.wishItem, required this.onSave});

  @override
  State<EditItem> createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  // Initialize fields with current wish item values
  String title = '';
  String note = '';
  String link = '';
  double price = 0;
  String selectedCategory = '';
  List<String> _selectedImages = []; // Store images as base64 strings

  // List of categories to choose from
  final List<String> categories = [
    'Household Item',
    'Fashion',
    'Sport',
    'Books'
  ];

  @override
  void initState() {
    super.initState();
    // Initialize fields with current wish item's values
    title = widget.wishItem.title;
    note = widget.wishItem.note;
    link = widget.wishItem.link;
    price = widget.wishItem.price;
    selectedCategory = widget.wishItem.category;
    _selectedImages = widget.wishItem.image; // Assume images are already base64 strings
  }

  // Pick images and convert to base64
  Future<void> _pickImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles != null) {
      final List<String> base64Images = [];
      for (var pickedFile in pickedFiles) {
        // Read bytes and convert to base64
        final bytes = await pickedFile.readAsBytes();
        final base64Image = 'data:image/jpeg;base64,${base64Encode(bytes)}';
        base64Images.add(base64Image);
      }
      setState(() {
        _selectedImages.addAll(base64Images);
      });
    }
  }

  // Remove an image from the selected list
  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
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
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Input
              TextField(
                controller: TextEditingController(text: title),
                onChanged: (value) {
                  setState(() {
                    title = value;
                  });
                },
                decoration: const InputDecoration(labelText: "Item Name"),
              ),
              const SizedBox(height: 16),
              // Note Input
              TextField(
                controller: TextEditingController(text: note),
                onChanged: (value) {
                  setState(() {
                    note = value;
                  });
                },
                decoration: const InputDecoration(labelText: "Note"),
              ),
              const SizedBox(height: 16),
              // Price Input
              TextField(
                controller: TextEditingController(text: price.toString()),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    price = double.tryParse(value) ?? 0;
                  });
                },
                decoration: const InputDecoration(labelText: "Price"),
              ),
              const SizedBox(height: 16),
              // Link Input
              TextField(
                controller: TextEditingController(text: link),
                onChanged: (value) {
                  setState(() {
                    link = value;
                  });
                },
                decoration: const InputDecoration(labelText: "Link"),
              ),
              const SizedBox(height: 16),
              // Category Dropdown
              const Text(
                "Categories",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                value: selectedCategory,
                items: categories
                    .map((category) => DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedCategory = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text(
                "Upload Images",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
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
                                  child: Image.network(
                                    _selectedImages[index],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => _removeImage(index),
                                  ),
                                ),
                              ],
                            );
                          },
                        )
                      : const Center(
                          child: Icon(Icons.add_a_photo, color: Colors.yellow),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              // Save Button
              ElevatedButton(
                onPressed: () {
                  // Create a new updated WishItem
                  WishItem updatedItem = WishItem(
                    title: title,
                    note: note,
                    image: _selectedImages, // Store base64 images directly
                    price: price,
                    link: link,
                    category: selectedCategory,
                    isDone: widget.wishItem.isDone, // Maintain isDone state
                  );

                  // Call the onSave callback to pass updated item back
                  widget.onSave(updatedItem);

                  // Pop the Edit screen and return to the previous screen
                  Navigator.pop(context);
                },
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
