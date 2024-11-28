import 'package:flutter/material.dart';
import 'package:fp_kelompok3/add_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'detail_edit.dart';

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
        backgroundColor: const Color(0xFFF5F5EB),
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'Image/logo_bookmate.png',
              width: 48,
              height: 48,
            ),
            const SizedBox(width: 8),
            const Text(
              'BookMate',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6D4C41),
              ),
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
                  itemCount: 3, // Number of items in the PageView
                  itemBuilder: (context, index) {
                    final featuredBooks = [
                      {'title': 'Bumi Manusia', 'image': 'Image/bumi_manusia.jpg'},
                      {'title': 'Gadis Pantai', 'image': 'Image/gadis_pantai.jpg'},
                      {'title': 'Mangir', 'image': 'Image/mangir.jpg'},
                    ];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookDetailPage(
                              bookTitle: featuredBooks[index]['title']!,
                              bookImagePath: featuredBooks[index]['image']!,
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
                                    image: DecorationImage(
                                      image: AssetImage(featuredBooks[index]['image']!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        featuredBooks[index]['title']!,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.brown),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
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
                {'title': 'Bumi Manusia', 'image': 'Image/bumi_manusia.jpg'},
                {'title': 'Gadis Pantai', 'image': 'Image/gadis_pantai.jpg'},
                {'title': 'Mangir', 'image': 'Image/mangir.jpg'},
                {'title': 'Bumi Manusia', 'image': 'Image/bumi_manusia.jpg'},
                {'title': 'Gadis Pantai', 'image': 'Image/gadis_pantai.jpg'},
                {'title': 'Mangir', 'image': 'Image/mangir.jpg'},
              ]),
              const SizedBox(height: 16),
              const SectionTitle(title: 'Historical Fiction'),
              const HorizontalBookList(books: [
                {'title': 'Jejak Langkah', 'image': 'Image/jejak_langkah.jpg'},
                {'title': 'Anak Semua Bangsa', 'image': 'Image/anak_semua_bangsa_cover.jpg'},
                {'title': 'Arus Balik', 'image': 'Image/arus_balik.jpg'},
                {'title': 'Jejak Langkah', 'image': 'Image/jejak_langkah.jpg'},
                {'title': 'Anak Semua Bangsa', 'image': 'Image/anak_semua_bangsa_cover.jpg'},
                {'title': 'Arus Balik', 'image': 'Image/arus_balik.jpg'},
              ]),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPage()),
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
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: books.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookDetailPage(
                    bookTitle: books[index]['title']!,
                    bookImagePath: books[index]['image']!,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                width: 100,
                child: Column(
                  children: [
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
                    SizedBox(
                      height: 40,
                      child: Text(
                        books[index]['title']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.brown,
                        ),
                        maxLines: 2,
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