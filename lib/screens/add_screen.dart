import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'dart:html' as html;
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:final_project_2/models/wish_item.dart';
import 'package:final_project_2/screens/detail_screen.dart';
import 'package:final_project_2/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';

enum Category {
  householdItem,
  electronics,
  clothing,
  groceries;

  String get displayName {
    switch (this) {
      case Category.householdItem:
        return 'Household Item';
      case Category.electronics:
        return 'Electronics';
      case Category.clothing:
        return 'Clothing';
      case Category.groceries:
        return 'Groceries';
      default:
        return '';
    }
  }
}

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
  Category selectedCategory = Category.householdItem; // Default category
  List<dynamic> _selectedImages = []; // List to store selected image files

  // Pick images using the image_picker package for mobile
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

  // Handle image picking for web
  Future<void> _pickImagesWeb() async {
    final html.FileUploadInputElement uploadInput =
        html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.multiple = true;

    uploadInput.click();

    uploadInput.onChange.listen((e) async {
      final files = uploadInput.files;
      if (files!.isNotEmpty) {
        setState(() {
          _selectedImages = files.map((file) => file).toList();
        });
      }
    });
  }

  // Upload images to Firebase Storage and return their download URLs
  Future<List<String>> _uploadImagesToFirebase() async {
    List<String> downloadUrls = [];

    for (var image in _selectedImages) {
      try {
        String fileName;
        Uint8List imageBytes;

        if (kIsWeb) {
          // For web
          html.File webFile = image as html.File;
          fileName = webFile.name;

          // Read file as bytes
          imageBytes = await _readFileAsBytes(webFile);
        } else {
          // For mobile
          File mobileFile = image as File;
          fileName = mobileFile.path.split('/').last;
          imageBytes = await mobileFile.readAsBytes();
        }

        // Create a reference to the location you want to store the file
        final storageRef = FirebaseStorage.instance.ref().child(
            'wishlist_images/${DateTime.now().millisecondsSinceEpoch}_$fileName');

        // Upload the file
        final uploadTask = await storageRef.putData(imageBytes);

        // Get the download URL
        final downloadUrl = await storageRef.getDownloadURL();

        downloadUrls.add(downloadUrl);
      } catch (e) {
        print('Error uploading image: $e');
        // Optionally, you can choose to continue or break the loop
      }
    }

    return downloadUrls;
  }

  // Save item to Firestore
  Future<void> _saveItemToFirestore(List<String> base64Images) async {
    try {
      await FirebaseFirestore.instance.collection('wishlist_2').add({
        'title': title,
        'note': note,
        'link': link,
        'price': price,
        'category': selectedCategory.name,
        'image': base64Images, // Store base64 encoded images
        'createdAt': FieldValue.serverTimestamp(),
        'isDone': false,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Item added successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add item: $e")),
      );
    }
  }

  Future<List<String>> _convertImagesToBase64() async {
    List<String> base64Images = [];

    for (var image in _selectedImages) {
      try {
        Uint8List imageBytes;

        if (kIsWeb) {
          // For web
          html.File webFile = image as html.File;
          imageBytes = await _readFileAsBytes(webFile);
        } else {
          // For mobile
          File mobileFile = image as File;
          imageBytes = await mobileFile.readAsBytes();
        }

        // Convert to base64
        String base64Image = base64Encode(imageBytes);
        base64Images.add(base64Image);
      } catch (e) {
        print('Error converting image: $e');
      }
    }

    return base64Images;
  }

  Future<Uint8List> _readFileAsBytes(html.File file) {
    final completer = Completer<Uint8List>();
    final reader = html.FileReader();

    reader.onLoadEnd.listen((_) {
      final result = reader.result;
      if (result is List<int>) {
        completer.complete(Uint8List.fromList(result));
      } else {
        completer.completeError('Failed to read file');
      }
    });

    reader.readAsArrayBuffer(file);

    return completer.future;
  }

  Widget _buildImageGrid() {
    if (_selectedImages.isEmpty) {
      return const Center(
        child: Icon(Icons.add_a_photo, color: Colors.grey),
      );
    }

    if (kIsWeb) {
      return GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: _selectedImages.length,
        itemBuilder: (context, index) {
          final base64Image = _selectedImages[index];
          final imageBytes = base64Decode(base64Image
              .split(',')
              .last); // Remove the prefix "data:image/jpeg;base64," if it's there

          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(
                  imageBytes,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.red,
                      child: const Center(
                        child: Icon(Icons.error, color: Colors.white),
                      ),
                    );
                  },
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
                  onPressed: () {
                    setState(() {
                      _selectedImages.removeAt(index);
                    });
                  },
                ),
              ),
            ],
          );
        },
      );
    } else {
      // Existing mobile implementation remains the same
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: _selectedImages.length,
        itemBuilder: (context, index) {
          // Decode base64 image string into bytes
          final base64Image = _selectedImages[index];
          final imageBytes = base64Decode(
              base64Image.split(',').last); // Remove the prefix if present

          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(
                  imageBytes,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.red,
                      child: const Center(
                        child: Icon(Icons.error, color: Colors.white),
                      ),
                    );
                  },
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
                  onPressed: () {
                    setState(() {
                      _selectedImages.removeAt(index);
                    });
                  },
                ),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              DropdownButton<Category>(
                value: selectedCategory,
                items: Category.values
                    .map((category) => DropdownMenuItem<Category>(
                          value: category,
                          child: Text(category.displayName),
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
                  child: _buildImageGrid(),
                ),
              ),
              const SizedBox(height: 16),

              // Save Button
              ElevatedButton(
                onPressed: () async {
                  if (_selectedImages.isNotEmpty) {
                    try {
                      // Convert images to base64
                      List<String> base64Images =
                          await _convertImagesToBase64();

                      // Save item to Firestore with base64 images
                      await _saveItemToFirestore(base64Images);

                      // Navigate back or clear the form
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error: $e")),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Please select at least one image")),
                    );
                  }
                },
                child: const Text("Save Item"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
