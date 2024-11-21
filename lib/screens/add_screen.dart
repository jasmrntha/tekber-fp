import 'dart:html' as html;
import 'dart:convert';
import 'package:final_project_2/models/wish_item.dart';
import 'package:final_project_2/screens/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddItem extends StatefulWidget {
  const AddItem({super.key});

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  // Variables to hold user input
  String title = '';
  String note = '';
  String link = '';
  double price = 0;
  String selectedCategory = 'Household Item'; // Default category
  List<String> _selectedImages = []; // List to store base64 images

  // List of categories to choose from
  final List<String> categories = [
    'Household Item',
    'Fashion',
    'Sport',
    'Books'
  ];

  // Pick images using the image_picker package
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

  // Save images to localStorage
  void _saveImagesToLocalStorage() {
    html.window.localStorage['wishlist_images'] = json.encode(_selectedImages);
  }

  // Load images from localStorage
  void _loadImagesFromLocalStorage() {
    final storedImages = html.window.localStorage['wishlist_images'];
    if (storedImages != null) {
      setState(() {
        _selectedImages = List<String>.from(json.decode(storedImages));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadImagesFromLocalStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Wish',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.yellow,
            )),
        backgroundColor: Colors.blue[900],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Input
              TextField(
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

              // Image Upload Section
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
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: _selectedImages.length,
                          itemBuilder: (context, index) {
                            // Strip the prefix before decoding
                            final base64String =
                                _selectedImages[index].split(',').last;

                            return Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.memory(
                                    base64Decode(
                                        base64String), // Decode and display
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
                          child: Icon(Icons.add_a_photo, color: Colors.grey),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // Add Button
              ElevatedButton(
                onPressed: () {
                  // Create WishItem from user input
                  WishItem newItem = WishItem(
                    title: title,
                    note: note,
                    image: _selectedImages, // Store base64 images directly
                    price: price,
                    link: link,
                    category: selectedCategory,
                    isDone: false,
                  );

                  // Show a snackbar message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Item added successfully!")),
                  );

                  // Navigate to DetailScreen with the created WishItem
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(
                        wish: newItem,
                        toggleDone: () {},
                        onDelete: () {},
                      ),
                    ),
                  );
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
                child: const Text("ADD",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
