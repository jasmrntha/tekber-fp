import 'package:final_project_2/models/wish_repository.dart';
import 'package:final_project_2/screens/add_screen.dart';
import 'package:flutter/material.dart';
import 'package:final_project_2/screens/detail_screen.dart';
import 'package:final_project_2/models/wish_item.dart';
import 'package:final_project_2/screens/profile_screen.dart';
import 'package:final_project_2/screens/guide_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WishRepository _wishRepository = WishRepository();
  late Future<List<WishItem>> _wishesFuture;
  List<WishItem> wishes = [];

  String _searchQuery = '';
  String _filter = 'All';

  @override
  void initState() {
    super.initState();

    // Fetch the wishes and update the state
    _wishesFuture = _wishRepository.fetchWishes().then((fetchedWishes) {
      setState(() {
        wishes = fetchedWishes; // Update the wish list
      });
      return fetchedWishes; // Ensure a value is always returned
    });
  }

  List<String> getFilters() {
    final categories = wishes
        .where((wish) => wish.category != null && wish.category!.isNotEmpty)
        .map((wish) => wish.category!)
        .toSet()
        .toList();

    debugPrint("Categories extracted: $categories");

    final filters = ['All', 'Done', 'Undone'];
    debugPrint("Complete filter list: $filters");

    return filters;
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

  void toggleDone(String id) {
    setState(() {
      final index = wishes.indexWhere((wish) => wish.id == id);
      if (index != -1) {
        final wish = wishes[index];
        wish.toggleDone(); // Toggle the 'isDone' state using the method in WishItem

        // Reorder the list based on whether the wish is done or not
        if (wish.isDone) {
          wishes.removeAt(index);
          wishes.add(wish); // Move the item to the bottom if it's done
        } else {
          wishes.removeAt(index);
          wishes.insert(0, wish); // Move the item to the top if it's undone
        }
      }
    });
  }

  void deleteWish(String id) {
    setState(() {
      wishes.removeWhere((wish) => wish.id == id);
    });
  }

  int _currentIndex = 0;
  final PageController _pageController =
      PageController(); // Tambahkan PageControlle

  final GlobalKey _bottomnavbarkeys = GlobalKey();
  final List<GlobalKey> _navbarkeys = [GlobalKey(), GlobalKey(), GlobalKey()];

  Future<void> _firstLoginCheck(BuildContext context) async {
    SharedPreferences userPref = await SharedPreferences.getInstance();
    bool firstLogin = userPref.getBool('firstLogin') ?? true;

    if (firstLogin) {
      await userPref.setBool('firstLogin', false);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              debugPrint(
                  'Keys: ${_navbarkeys.map((key) => key.currentContext)}');
              return FirstGuide(bottomnavbarkeys: _navbarkeys);
            },
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _pageController
        .dispose(); // Jangan lupa dispose untuk mencegah memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filters = getFilters();
    debugPrint("Filters used in build: $filters");

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          _currentIndex == 0
              ? 'Your Wish'
              : _currentIndex == 1
                  ? 'Add Wish'
                  : 'Profile',
          style: TextStyle(color: Colors.yellow, fontFamily: 'Poppins'),
        ),
        backgroundColor: Colors.blue[900],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          // Halaman Home
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  children: [
                    // Search and Filter Row
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Flexible(
                            flex: 2,
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
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                prefixIcon: Icon(Icons.search),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            flex: 1,
                            child: DropdownButtonFormField<String>(
                              value: _filter,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
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
                  ],
                ),
              ),
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
                                  toggleDone: () => toggleDone(wish.id!),
                                  onDelete: () => deleteWish(wish.id!),
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
                                  height:
                                      150, // Set a fixed height for the image container
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: wish.image.length,
                                    itemBuilder: (context, imageIndex) {
                                      try {
                                        // Extract the base64 string after the prefix
                                        final base64String = wish
                                            .image[imageIndex]
                                            .split('base64,')
                                            .last;

                                        // Decode the base64 string
                                        final imageBytes =
                                            base64Decode(base64String);

                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.memory(
                                              imageBytes,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                // Handle errors in loading the image
                                                return Container(
                                                  color: Colors.grey,
                                                  child: const Center(
                                                    child: Icon(Icons.error,
                                                        color: Colors.white),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        );
                                      } catch (e) {
                                        // Handle any errors during decoding
                                        return Container(
                                          color: Colors.grey,
                                          child: const Center(
                                            child: Icon(Icons.error,
                                                color: Colors.white),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
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
                        ));
                  },
                ),
              ),
            ],
          ),
          // Halaman Add
          AddItem(),
          // Halaman Profile
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        key: _bottomnavbarkeys,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue[900],
        items: [
          BottomNavigationBarItem(
            icon: Builder(
                key: _navbarkeys[0],
                builder: (context) {
                  return Icon(Icons.home);
                }),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Builder(
                key: _navbarkeys[1],
                builder: (context) {
                  return Icon(Icons.add);
                }),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Builder(
                key: _navbarkeys[2],
                builder: (context) {
                  return Icon(Icons.person);
                }),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Ubah indeks navigasi
            _pageController
                .jumpToPage(index); // Pindahkan PageView ke halaman yang sesuai
          });
        },
      ),
    );
  }
}
