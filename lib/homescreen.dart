import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'detail_edit.dart';
import 'loginpage.dart';
import 'add_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _searchController = TextEditingController(); // Controller for search input
  List<QueryDocumentSnapshot> _filteredBooks = []; // List to store filtered books

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFE7DA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEFE7DA),
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 60,
        title: Row(
          children: [
            if (_searchController.text.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF6D4C41)),
                onPressed: () {
                  setState(() {
                    _searchController.clear(); // Clear search input
                  });
                },
              ),
            if (_searchController.text.isEmpty)
              Image.asset(
                'Image/logo_bookmate.png',
                width: 48,
                height: 48,
              ),
            if (_searchController.text.isEmpty)
              const SizedBox(width: 8.0),
            if (_searchController.text.isEmpty)
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
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFF6D4C41)),
            onPressed: () async {
              try {
                await _auth.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false,
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Logout failed: $e")),
                );
              }
            },
            padding: const EdgeInsets.only(right: 16.0),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('books').orderBy('created_at', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('An error occurred. Please try again.'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No books available.'));
          }

          final books = snapshot.data!.docs;
          final latestBooks = books.take(3).toList();
          final booksByCategory = _groupBooksByCategory(books);

          // Filter books based on search input
          _filteredBooks = books.where((book) {
            final title = (book.data() as Map<String, dynamic>)['title'] ?? '';
            return title.toLowerCase().contains(_searchController.text.toLowerCase());
          }).toList();

          return ListView(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: (query) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    hintText: 'Search',
                    filled: true,
                    fillColor: const Color(0xFFC1B6A3),
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              // Display filtered books for search results if search query is not empty
              if (_searchController.text.isNotEmpty && _filteredBooks.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Search Results',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      for (var book in _filteredBooks)
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookDetailPage(bookId: book.id),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              (book.data() as Map<String, dynamic>)['title'] ?? 'No Title',
                              style: const TextStyle(fontSize: 16.0, color: Colors.brown),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              // Display latest books and categories only if no search query
              if (_searchController.text.isEmpty) _buildLatestBooksSlider(latestBooks),
              if (_searchController.text.isEmpty)
                ...booksByCategory.entries.map((entry) {
                  final category = entry.key;
                  final categoryBooks = entry.value;
                  return _buildCategorySection(category, categoryBooks);
                }).toList(),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPage()),
          );
        },
        backgroundColor: const Color(0xFFC1B6A3),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildLatestBooksSlider(List<QueryDocumentSnapshot> books) {
    return SizedBox(
      height: 250,
      child: PageView.builder(
        itemCount: books.length,
        controller: PageController(viewportFraction: 0.9),
        itemBuilder: (context, index) {
          final book = books[index].data() as Map<String, dynamic>;

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookDetailPage(bookId: books[index].id),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFC1B6A3),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 100,
                      margin: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const Center(
                        child: Icon(Icons.book, size: 50, color: Colors.brown),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              book['title'] ?? 'No Title',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              book['description'] ?? 'No Description',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.black54,
                              ),
                            ),
                          ],
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
    );
  }

  Widget _buildCategorySection(String category, List<QueryDocumentSnapshot> books) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index].data() as Map<String, dynamic>;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailPage(bookId: books[index].id),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: const Center(
                            child: Icon(Icons.book, size: 40),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          book['title'] ?? 'No Title',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12.0),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Map<String, List<QueryDocumentSnapshot>> _groupBooksByCategory(List<QueryDocumentSnapshot> books) {
    final Map<String, List<QueryDocumentSnapshot>> booksByCategory = {};

    for (var book in books) {
      final data = book.data() as Map<String, dynamic>;
      final category = data['categories'] ?? 'Uncategorized';

      if (!booksByCategory.containsKey(category)) {
        booksByCategory[category] = [];
      }
      booksByCategory[category]!.add(book);
    }

    return booksByCategory;
  }
}
