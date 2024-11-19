import 'package:flutter/material.dart';
import 'package:final_project_2/screens/detail_screen.dart';
import 'package:final_project_2/screens/profile_screen.dart';
import 'package:final_project_2/models/wish_item.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<WishItem> wishes = [
    WishItem(
      title: 'Jaket Coach KAWS + Warhol',
      note: 'Ukuran S, warna navy',
      price: 499000,
      image: [
        'assets/images/coach_jacket_1.jpg',
        'assets/images/coach_jacket_2.jpg',
      ],
      link: 'uniqlo.com',
      category: 'Fashion',
    ),
    WishItem(
      title: 'New Balance 530 Unisex',
      note: 'Ukuran 41, warna silver',
      price: 1599000,
      image: [
        'assets/images/nb_530.jpg',
      ],
      link: 'footlocker.com',
      category: 'Sport',
    ),
    WishItem(
      title: 'New Balance 530 Unisex',
      note: 'Ukuran 38, warna silver',
      price: 1599000,
      image: [
        'assets/images/nb_530.jpg',
      ],
      link: 'footlocker.com',
      category: 'Sport',
    ),
  ];

  int _currentIndex = 0;
  String _searchQuery = '';
  String _filter = 'All';

  List<String> getFilters() {
    final categories = wishes.map((wish) => wish.category).toSet().toList();
    return ['All', 'Done', 'Undone', ...categories];
  }

  List<WishItem> getFilteredWishes() {
    return wishes.where((wish) {
      final matchesSearchQuery =
          wish.title.toLowerCase().contains(_searchQuery.toLowerCase());

      if (_filter == 'All') return matchesSearchQuery;
      if (_filter == 'Done') return matchesSearchQuery && wish.isDone;
      if (_filter == 'Undone') return matchesSearchQuery && !wish.isDone;
      return matchesSearchQuery && wish.category == _filter;
    }).toList();
  }

  void toggleDone(int index) {
    setState(() {
      final wish = wishes.removeAt(index); // Hapus item dari posisi awal
      wish.isDone = !wish.isDone; // Ubah status
      // Tambahkan kembali ke posisi sesuai status
      if (wish.isDone) {
        wishes.add(wish); // Tambahkan ke bawah
      } else {
        wishes.insert(0, wish); // Tambahkan ke atas
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Wish',
          style: TextStyle(color: Colors.yellow, fontFamily: 'Poppins'),
        ),
        backgroundColor: Colors.blue[900],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0), // Menambahkan space di kiri dan kanan
        child: Column(
          children: [
            // Search and Filter Row
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  // Search Bar
                  Expanded(
                    flex: 2, // Mengatur ukuran relatif search bar
                    child: TextField(
                      onChanged: (query) {
                        setState(() {
                          _searchQuery = query;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search by title...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.search),
                        hintStyle: TextStyle(fontFamily: 'Poppins'),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  // Filter Dropdown
                  Expanded(
                    flex: 1, // Mengatur ukuran relatif filter dropdown
                    child: DropdownButtonFormField<String>(
                      value: _filter,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _filter = value!;
                        });
                      },
                      items: getFilters()
                          .map((filter) => DropdownMenuItem<String>(
                                value: filter,
                                child: Text(filter),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
            // Wish List
            Expanded(
              child: ListView.builder(
                itemCount: getFilteredWishes().length,
                itemBuilder: (context, index) {
                  final wish = getFilteredWishes()[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(
                              wish: wish,
                              toggleDone: () => toggleDone(index),
                              onDelete: () => setState(() => wishes.removeAt(index)),
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              wish.title,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                decoration: wish.isDone
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              wish.note,
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                decoration: wish.isDone
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            SizedBox(height: 8),
                            SizedBox(
                              height: 150,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: wish.image.length,
                                itemBuilder: (context, imageIndex) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        wish.image[imageIndex],
                                        width: 150,
                                        height: 150,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  wish.category,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.blue[900],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          }
        },
      ),
    );
  }
}
