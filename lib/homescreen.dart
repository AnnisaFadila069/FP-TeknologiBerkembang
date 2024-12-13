import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'detail_edit.dart';
import 'loginpage.dart';
import 'add_page.dart';
import 'search.dart';
import 'profilemenu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F6F1),
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 50, // Atur tinggi AppBar
        title: Padding(
          padding: const EdgeInsets.only(top: 16.0), // Menurunkan elemen
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'Image/logo_bookmate.png',
                width: 48, // Perbesar logo jika diperlukan
                height: 48,
              ),
              const SizedBox(width: 8.0),
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(
                right: 16.0, top: 12.0), // Menurunkan ikon
            child: SizedBox(
              width: 48,
              height: 48,
              child: IconButton(
                icon: const Icon(Icons.person,
                    size: 34, color: Color(0xFF6D4C41)),
                onPressed: () {
                  final currentUser = _auth.currentUser;
                  final username = currentUser?.displayName ?? 'Unknown';
                  final email = currentUser?.email ?? 'Unknown';

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Profilemenu(username: username, email: email),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SearchPage()),
                  );
                },
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC1B6A3),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: const [
                      Icon(Icons.search, color: Colors.brown),
                      SizedBox(width: 8.0),
                      Text(
                        'Search for books...',
                        style: TextStyle(color: Colors.brown, fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('books')
                .orderBy('created_at', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SliverToBoxAdapter(
                  child: const Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError) {
                return SliverToBoxAdapter(
                  child: const Center(
                      child: Text('An error occurred. Please try again.')),
                );
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return SliverToBoxAdapter(
                  child: const Center(child: Text('No books available.')),
                );
              }

              final books = snapshot.data!.docs;
              final latestBooks = books.take(3).toList();
              final booksByCategory = _groupBooksByCategory(books);

              return SliverList(
                delegate: SliverChildListDelegate([
                  _buildLatestBooksSlider(latestBooks),
                  ...booksByCategory.entries.map((entry) {
                    final category = entry.key;
                    final categoryBooks = entry.value;
                    return _buildCategorySection(category, categoryBooks);
                  }).toList(),
                ]),
              );
            },
          ),
        ],
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

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
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
              child: const Text('Logout'),
            ),
          ],
        );
      },
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
                      width: 150,
                      height: 225,
                      margin: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8.0),
                        image: book['imagePath'] != null &&
                                book['imagePath'].isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(book['imagePath']),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child:
                          book['imagePath'] == null || book['imagePath'].isEmpty
                              ? const Center(
                                  child: Icon(Icons.book,
                                      size: 50, color: Colors.brown),
                                )
                              : null,
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

  Widget _buildCategorySection(
      String category, List<QueryDocumentSnapshot> books) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul Kategori
          Text(
            category,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          // Daftar Buku
          SizedBox(
            height: 200, // Tinggi total item (termasuk gambar dan teks)
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
                        builder: (context) =>
                            BookDetailPage(bookId: books[index].id),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Gambar Buku
                        Container(
                          width: 115,
                          height: 165,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8.0),
                            image: book['imagePath'] != null &&
                                    book['imagePath'].isNotEmpty
                                ? DecorationImage(
                                    image: NetworkImage(book['imagePath']),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: book['imagePath'] == null ||
                                  book['imagePath'].isEmpty
                              ? const Center(
                                  child: Icon(Icons.book, size: 40),
                                )
                              : null,
                        ),
                        const SizedBox(height: 8.0),
                        // Judul Buku
                        SizedBox(
                          width: 100, // Menyesuaikan lebar teks dengan gambar
                          child: Text(
                            book['title'] ?? 'No Title',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12.0),
                            textAlign: TextAlign.center,
                          ),
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

  Map<String, List<QueryDocumentSnapshot>> _groupBooksByCategory(
      List<QueryDocumentSnapshot> books) {
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
