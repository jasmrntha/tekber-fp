import 'package:final_project_2/screens/add_screen.dart';
import 'package:final_project_2/screens/guide_screen.dart';
import 'package:final_project_2/screens/home_screen.dart';
import 'package:final_project_2/screens/profile_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_project_2/models/wish_model.dart';
import 'package:final_project_2/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
     await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDdbrK2GMJ3aIxuoJjSg2VWtvVy0tDLVDU",
            authDomain: "tekberd4makeawish.firebaseapp.com",
            projectId: "tekberd4makeawish",
            storageBucket: "tekberd4makeawish.firebasestorage.app",
            appId: "1:48801867552:web:82e0ec1a5c8a60b9ff1945",
            messagingSenderId: "48801867552",
            measurementId: "G-0FKBJLL3VF"));
  } else {
    await Firebase.initializeApp();
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => WishModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    AddItem(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        key: GlobalKey(),
        currentIndex: _currentIndex,
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
        },
      ),
    );
  }
}
