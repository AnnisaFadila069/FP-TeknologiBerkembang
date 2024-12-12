import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'detail_edit.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  List<QueryDocumentSnapshot> _filteredBooks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFE7DA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEFE7DA),
        elevation: 0,
        title: const Text(
          'Search Books',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6D4C41),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF6D4C41)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              onChanged: (query) => _searchBooks(query),
              decoration: InputDecoration(
                hintText: 'Search for books...',
                filled: true,
                fillColor: const Color(0xFFC1B6A3),
                prefixIcon: const Icon(Icons.search, color: Colors.brown),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            // Search Results
            Expanded(
              child: _filteredBooks.isEmpty
                  ? const Center(child: Text('No results found.'))
                  : ListView.builder(
                      itemCount: _filteredBooks.length,
                      itemBuilder: (context, index) {
                        final book = _filteredBooks[index].data()
                            as Map<String, dynamic>;
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookDetailPage(
                                    bookId: _filteredBooks[index].id),
                              ),
                            );
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            color: const Color(0xFFC1B6A3),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  // Book Image
                                  Container(
                                    width: 80,
                                    height: 100,
                                    margin: const EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(8.0),
                                      image: book['imagePath'] != null &&
                                              book['imagePath'].isNotEmpty
                                          ? DecorationImage(
                                              image: NetworkImage(
                                                  book['imagePath']),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                    ),
                                    child: book['imagePath'] == null ||
                                            book['imagePath'].isEmpty
                                        ? const Center(
                                            child: Icon(Icons.book,
                                                size: 50, color: Colors.brown),
                                          )
                                        : null,
                                  ),
                                  // Book Details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                          book['description'] ??
                                              'No Description',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
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
      ),
    );
  }

  void _searchBooks(String query) async {
    final books = await _firestore.collection('books').get();
    final filteredBooks = books.docs.where((doc) {
      final title = (doc.data() as Map<String, dynamic>)['title'] ?? '';
      return title.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      _filteredBooks = filteredBooks;
    });
  }
}
