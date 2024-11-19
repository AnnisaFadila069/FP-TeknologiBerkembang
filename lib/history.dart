import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _BookMateHomeState();
}

class _BookMateHomeState extends State<HistoryPage>
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
      unselectedLabelColor: const Color(0xffff5f5eb), // Warna teks tab tidak aktif
      tabs: [
        Container(
          width: 60, // Lebar setiap tab
          alignment: Alignment.center,
          child: const Text('WishList'),
        ),
        Container(
          width: 60,
          alignment: Alignment.center,
          child: const Text('Unread'),
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
              buildBookGrid(), // Halaman WishList
              buildUnreadGrid(), // Halaman Unread
              buildFavoriteList(), // Halaman Favorite
            ],
          ),
         // Halaman History
        ],
      ),
    );
  }
Widget buildBookGrid() {
  List<String> bookTitles = [
    'Gadis Pantai',
    'Laut Bercerita',
    'Rumah Kaca',
    'Laskar Pelangi',
    'Hujan',
    'Tujuh Kelana'
  ];
  List<String> bookCovers = [
    'assets/gadis_pantai_cover.jpg',
    'assets/laut_bercerita_cover.jpg',
    'assets/rumah_kaca_cover.jpg',
    'assets/laskar_pelangi_cover.jpg',
    'assets/hujan_cover.jpg',
    'assets/tujuh_kelana_cover.jpg',
  ];

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 18.0), // Jarak di sekitar grid
    child: GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.70, // Proporsi lebar dan tinggi kotak
        crossAxisSpacing: 12, // Jarak horizontal antar elemen
        mainAxisSpacing: 4, // Jarak vertikal antar elemen
      ),
      itemCount: bookTitles.length,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Pusatkan semua elemen secara horizontal
          children: [
            Container(
              width: 156, // Lebar kotak
              height: 210, // Tinggi kotak
              decoration: BoxDecoration(
                color: const Color(0xfffc1b6a4), // Warna latar belakang kotak
                borderRadius: BorderRadius.circular(12), // Membulatkan sudut
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12, // Warna bayangan
                    blurRadius: 6, // Tingkat blur bayangan
                    offset: Offset(0, 4), // Offset bayangan
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0), // Ruang dalam kotak
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8), // curved pojok gambar
                  child: Image.asset(
                    bookCovers[index],
                    width: 140, // Lebar gambar
                    height: 190, // Tinggi gambar
                    fit: BoxFit.cover, // Menyesuaikan ukuran gambar
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8), // Jarak antara kotak dan teks
            Text(
              bookTitles[index],
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xfff918674) // Warna teks
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
    ),
  );
}

Widget buildUnreadGrid() {
  List<String> unreadTitles = [
    'Bumi Manusia',
    'Mangir',
    'Filosofi Teras',
    'Tentang Kamu',
    'Negara 5 Menara',
    'Sihir Perempuan'
  ];
 List<String> unreadCovers = [
    'assets/bumi_manusia_cover.jpg',
    'assets/mangir_cover.jpg',
    'assets/filosofi_teras_cover.jpg',
    'assets/tentang_kamu_cover.jpg',
    'assets/negara_5_menara_cover.jpg',
    'assets/sihir_perempuan_cover.jpg',
  ];

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 18.0), // Jarak di sekitar grid
    child: GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.70, // Proporsi lebar dan tinggi kotak
        crossAxisSpacing: 12, // Jarak horizontal antar elemen
        mainAxisSpacing: 4, // Jarak vertikal antar elemen
      ),
      itemCount: unreadTitles.length,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 156,
              height: 210,
              decoration: BoxDecoration(
                color: const Color(0xfffc1b6a4), // Warna latar belakang untuk Unread
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    unreadCovers[index],
                    width: 140,
                    height: 190,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              unreadTitles[index],
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xfff918674) // Warna teks
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
    ),
  );
}

Widget buildFavoriteList() {
  List<Map<String, String>> favoriteBooks = [
    {
      'title': 'Anak Semua Bangsa',
      'description': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'cover': 'assets/anak_semua_bangsa_cover.jpg',
    },
    {
      'title': 'Cantik Itu Luka',
      'description': 'In tempus egestas velit sed maximus vehicula.',
      'cover': 'assets/cantik_itu_luka_cover.jpg',
    },
    {
      'title': 'Sang Pemimpi',
      'description': 'ini deskripsi dari novel sang pemimpi, cm nyoba.',
      'cover': 'assets/sang_pemimpi_cover.jpg',
    },
    {
      'title': 'Gadis Kretek',
      'description': 'ini deskripsi dari gadis kretek yang dijadiin film.',
      'cover': 'assets/gadis_kretek_cover.jpg',
    },
  ];

  return ListView.builder(
    padding: const EdgeInsets.all(8.0),
    itemCount: favoriteBooks.length,
    itemBuilder: (context, index) {
      return Card(
        color: const Color(0xfffc1b6a4), // Warna untuk background card
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), 
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              // Gambar buku
              Container(
                width: 100, // Lebar gambar
                height: 150, // Tinggi gambar
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: AssetImage(favoriteBooks[index]['cover']!), // Gambar sesuai indeks
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12), // Jarak antara gambar dan teks
              // Teks di sebelah kanan
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      favoriteBooks[index]['title']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Warna teks
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      favoriteBooks[index]['description']!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70, // Warna teks deskripsi
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