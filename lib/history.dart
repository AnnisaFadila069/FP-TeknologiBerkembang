import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fp_kelompok3/detail_edit.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final int _selectedBottomNavIndex = 0; // Untuk kontrol BottomNavigationBar

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Menghilangkan tombol back
        backgroundColor: const Color(0xFFFDF6EC), // Warna latar AppBar
        elevation: 0, // Hilangkan bayangan
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  'Image/logo_bookmate.png',
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
            const SizedBox(height: 4), // Jarak sebelum garis
            const Divider(
              color: Color(0xfffc1b6a3), // Warna garis
              thickness: 0.5, // Ketebalan garis
              height: 1, // Tinggi Divider
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(68),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFD9C6AB), // Warna latar belakang tab
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: const Color(0xffff5f5eb), // Warna untuk tab aktif
                  borderRadius: BorderRadius.circular(15),
                ),
                labelColor: const Color(0xfffb3907a), // Warna teks tab aktif
                unselectedLabelColor:
                    const Color(0xffff5f5eb), // Warna teks tab tidak aktif
                tabs: [
                  Container(
                    width: 60, // Lebar setiap tab
                    alignment: Alignment.center,
                    child: const Text('WishList'),
                  ),
                  Container(
                    width: 60,
                    alignment: Alignment.center,
                    child: const Text('Readed'),
                  ),
                  Container(
                    width: 60,
                    alignment: Alignment.center,
                    child: const Text('Favorite'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF9F6F1),
      body: IndexedStack(
        index: _selectedBottomNavIndex,
        children: [
          TabBarView(
            controller: _tabController,
            children: [
              _buildWishlistTab(), // Halaman WishList
              _buildReadedTab(), // Halaman Readed
              _buildFavoriteTab(), // Halaman Favorite
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('books')
          .where('status', isEqualTo: 'Haven’t Read')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error loading data.'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No books in WishList.'));
        }

        final books = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: books.length,
          itemBuilder: (context, index) {
            final book = books[index].data() as Map<String, dynamic>;
            final imagePath = book['imagePath'] ?? ''; // Ambil path gambar
            final title = book['title'] ?? 'No Title';
            final description = book['description'] ?? 'No Description';

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
              child: Card(
                color: const Color(0xFFC1B6A3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          bottomLeft: Radius.circular(8.0),
                        ),
                      ),
                      child: imagePath.isNotEmpty
                          ? ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                bottomLeft: Radius.circular(8.0),
                              ),
                              child: Image.network(
                                imagePath, // Path gambar dari Firestore
                                fit: BoxFit.cover,
                                width: 100,
                                height: 150,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image, size: 50),
                              ),
                            )
                          : const Center(
                              child: Icon(Icons.book, size: 50),
                            ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              description,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildReadedTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('books')
          .where('status', whereIn: ['Finished', 'Reading']).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error loading data.'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No readed books.'));
        }

        final books = snapshot.data!.docs;
        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: books.length,
          itemBuilder: (context, index) {
            final book = books[index].data() as Map<String, dynamic>;
            final imagePath = book['imagePath'] ?? ''; // Ambil path gambar
            final title = book['title'] ?? 'No Title';
            final description = book['description'] ?? 'No Description';

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
              child: Card(
                color: const Color(0xFFC1B6A3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          bottomLeft: Radius.circular(8.0),
                        ),
                      ),
                      child: imagePath.isNotEmpty
                          ? ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                bottomLeft: Radius.circular(8.0),
                              ),
                              child: Image.network(
                                imagePath, // Path gambar dari Firestore
                                fit: BoxFit.cover,
                                width: 100,
                                height: 150,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image, size: 50),
                              ),
                            )
                          : const Center(
                              child: Icon(Icons.book, size: 50),
                            ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              description,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFavoriteTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('books')
          .where('notes.isFavorite', isEqualTo: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error loading data.'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No favorite books.'));
        }

        final books = snapshot.data!.docs;
        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: books.length,
          itemBuilder: (context, index) {
            final book = books[index].data() as Map<String, dynamic>;
            final imagePath = book['imagePath'] ?? ''; // Ambil path gambar
            final title = book['title'] ?? 'No Title';
            final description = book['description'] ?? 'No Description';

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
              child: Card(
                color: const Color(0xFFC1B6A3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          bottomLeft: Radius.circular(8.0),
                        ),
                      ),
                      child: imagePath.isNotEmpty
                          ? ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                bottomLeft: Radius.circular(8.0),
                              ),
                              child: Image.network(
                                imagePath, // Path gambar dari Firestore
                                fit: BoxFit.cover,
                                width: 100,
                                height: 150,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image, size: 50),
                              ),
                            )
                          : const Center(
                              child: Icon(Icons.book, size: 50),
                            ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              description,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBookGrid(List<QueryDocumentSnapshot> books) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.70,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index].data() as Map<String, dynamic>;
          return Column(
            children: [
              Container(
                width: 156,
                height: 210,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(book['coverUrl'] ?? ''),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                book['title'] ?? 'No Title',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBookList(List<QueryDocumentSnapshot> books) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index].data() as Map<String, dynamic>;
        return Card(
          color: const Color(0xFFC1B6A3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  width: 100,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(book['coverUrl'] ?? ''),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book['title'] ?? 'No Title',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        book['author'] ?? 'Unknown Author',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}