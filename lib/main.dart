import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'splash.dart';
import 'homescreen.dart';
import 'history.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase untuk platform web atau mobile
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCfL1BFQIjPtZHTPmaSrhdcAvXir9E9d80",
        authDomain: "tekber-310ab.firebaseapp.com",
        projectId: "tekber-310ab",
        storageBucket: "tekber-310ab.appspot.com",
        messagingSenderId: "87504152760",
        appId: "1:87504152760:web:7e695484310b2c753b6c4d",
        measurementId: "G-0Z2FMPXH2F",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const BookMateApp());
}

class BookMateApp extends StatelessWidget {
  const BookMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookMate',
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
      backgroundColor: Color(0xFFF5F5EB),
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F5EB),
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'Image/logo BookMate.png', 
              height: 42,
            ),
            const SizedBox(width: 8),
            const Text(
              'BookMate',
              style: TextStyle(
                fontFamily: 'BeVietnamPro',
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFF918673)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddPage()),
              );
            },
          ),
        ],
      ),
      body: Row(
        children: [],
      ),
      debugShowCheckedModeBanner: false,
      title: 'Book Detail App',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: const BookDetailPage(), // Menggunakan halaman BookDetailPage

    );
  }
}
