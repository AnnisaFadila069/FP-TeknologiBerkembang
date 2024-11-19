import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'; // For page indicator
import 'detailpagescreen.dart';
import 'addpagescreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F5EE),
appBar: AppBar(
  backgroundColor: const Color(0xffff5f5eb), // Warna latar AppBar
  elevation: 0, // Hilangkan bayangan
  title: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Image.asset(
            'assets/logo_bookmate.png',
            width: 48, // Lebar logo
            height: 48, // Tinggi logo
          ),
          const SizedBox(width: 8),
          const Text(
            'BookMate',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6D4C41), // Warna teks
            ),
          ),
        ],
      ),
    ],
  ),
),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFD9C6AB),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: Colors.brown),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Featured Section
              SizedBox(
                height: 220,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: 3, // Number of items
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DetailPageScreen(
                              bookTitle: 'Bumi Manusia',
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: const Color(0xFFD9C6AB),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Container(
                                  height: 150,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: const DecorationImage(
                                      image: AssetImage('assets/bumi_manusia.jpg'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Bumi Manusia',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.brown),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. In tempus egestas velit.',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Page Indicator
              Center(
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: 3,
                  effect: const ExpandingDotsEffect(
                    activeDotColor: Colors.brown,
                    dotColor: Color(0xFFD9C6AB),
                    dotHeight: 8,
                    dotWidth: 8,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Categories
              const SectionTitle(title: 'Horror'),
              const HorizontalBookList(books: [
                {'title': 'Bumi Manusia', 'image': 'assets/bumi_manusia.jpg'},
                {'title': 'Gadis Pantai', 'image': 'assets/gadis_pantai.jpg'},
                {'title': 'Mangir', 'image': 'assets/mangir.jpg'},
                {'title': 'Bumi Manusia', 'image': 'assets/bumi_manusia.jpg'},
                {'title': 'Gadis Pantai', 'image': 'assets/gadis_pantai.jpg'},
                {'title': 'Mangir', 'image': 'assets/mangir.jpg'},
              ]),
              const SizedBox(height: 16),
              const SectionTitle(title: 'Historical Fiction'),
              const HorizontalBookList(books: [
                {'title': 'Jejak Langkah', 'image': 'assets/jejak_langkah.jpg'},
                {'title': 'Anak Semua Bangsa', 'image': 'assets/anak_semua_bangsa.jpg'},
                {'title': 'Arus Balik', 'image': 'assets/arus_balik.jpg'},
                {'title': 'Jejak Langkah', 'image': 'assets/jejak_langkah.jpg'},
                {'title': 'Anak Semua Bangsa', 'image': 'assets/anak_semua_bangsa.jpg'},
                {'title': 'Arus Balik', 'image': 'assets/arus_balik.jpg'},
              ]),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPageScreen()),
          );
        },
        backgroundColor: Colors.brown,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.brown,
        ),
      ),
    );
  }
}

class HorizontalBookList extends StatelessWidget {
  final List<Map<String, String>> books;

  const HorizontalBookList({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200, // Pastikan cukup untuk gambar dan teks
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: books.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPageScreen(
                    bookTitle: books[index]['title']!,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                width: 100, // Lebar tetap
                child: Column(
                  children: [
                    // Buku tetap di atas
                    Container(
                      height: 120,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: AssetImage(books[index]['image']!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Bungkus judul, tanpa memengaruhi posisi buku
                    SizedBox(
                      height: 40, // Tetapkan tinggi tetap untuk teks
                      child: Text(
                        books[index]['title']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.brown,
                        ),
                        maxLines: 2, // Bungkus hingga 2 baris
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}