import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'splash.dart';
import 'homescreen.dart';
import 'history.dart';
import 'loginpage.dart';
import 'package:firebase_core/firebase_core.dart';

void main(){
  if (kIsWeb){
    Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyCfL1BFQIjPtZHTPmaSrhdcAvXir9E9d80", authDomain: "tekber-310ab.firebaseapp.com",
        projectId: "tekber-310ab",
        storageBucket: "tekber-310ab.firebasestorage.app",
        messagingSenderId: "87504152760",
        appId: "1:87504152760:web:7e695484310b2c753b6c4d",
        measurementId: "G-0Z2FMPXH2F"));
  }
  
  runApp(const BookMateApp());
}

class BookMateApp extends StatelessWidget {
  const BookMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.beVietnamProTextTheme(),
        primarySwatch: Colors.brown,
      ),
      home: const SplashScreen(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const HistoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.brown,
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFFF9F5EE),
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }
}
