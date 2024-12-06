import 'package:final_project_2/screens/add_screen.dart';
import 'package:flutter/material.dart';
import 'package:final_project_2/screens/detail_screen.dart';
import 'package:final_project_2/models/wish_item.dart';
import 'package:final_project_2/screens/profile_screen.dart';
import 'package:final_project_2/screens/guide_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<WishItem> wishes = [
    WishItem(
      id: '1',
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
      id: '2',
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
      id: '3',
      title: 'New Balance 530 Kids',
      note: 'Ukuran 20, warna putih',
      price: 1599000,
      image: [
        'assets/images/nb_530.jpg',
      ],
      link: 'footlocker.com',
      category: 'Sport',
    ),
  ];

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

  void toggleDone(String id) {
    setState(() {
      final index = wishes.indexWhere((wish) => wish.id == id);
      if (index != -1) {
        final wish = wishes.removeAt(index);
        wish.isDone = !wish.isDone;
        if (wish.isDone) {
          wishes.add(wish);
        } else {
          wishes.insert(0, wish);
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
  void initState() {
    super.initState();
    _firstLoginCheck(context);
  }

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
            debugPrint('Keys: ${_navbarkeys.map((key) => key.currentContext)}');
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          _currentIndex == 0
              ? 'Your Wish' // Judul untuk tab Home
              : _currentIndex == 1
                  ? 'Add Wish' // Judul untuk tab Add (jika ada)
                  : 'Profile', // Judul untuk tab Profile
          style: TextStyle(color: Colors.yellow, fontFamily: 'Poppins'),
        ),
        backgroundColor: Colors.blue[900],
      ),
      body: PageView(
        controller: _pageController, // Hubungkan PageController
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index; // Sinkronkan indeks dengan PageView
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
                          Expanded(
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
                                toggleDone: () => toggleDone(wish.id),
                                onDelete: () => deleteWish(wish.id),
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
                      ),
                    );
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
