import 'package:flutter/material.dart';
import 'detail_page.dart';
import 'tambah_wisata.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:typed_data';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> newWisataList = [];

  final List<String> hotelList = List.generate(
    8,
    (index) => 'National Park Yosemite',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 214, 214, 214),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 7),
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hi, User',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CircleAvatar(
                  backgroundImage: AssetImage('assets/avatar.jpg'),
                  radius: 20,
                ),
              ],
            ),

            SizedBox(height: 20),

            // Hot Places Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hot Places',
                    style: GoogleFonts.poppins(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'See All',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),

            // Hot Places List
            SizedBox(
              height: 90,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ...List.generate(6, (index) {
                    String tag = 'hotplace_$index';
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => DetailPage(
                                  heroTag: tag,
                                  title: 'National Park Yosemite',
                                  location: 'California',
                                  deskripsi: 'Lorem ipsum dolor sit amet...',
                                  image: 'assets/gambar.jpg',
                                  isMemoryImage: false,
                                  harga: '30.000,00', // <- tambahkan ini
                                ),
                          ),
                        );
                      },
                      child: buildHotPlaceCard(
                        tag,
                        'National Park Yosemite',
                        'California',
                        'assets/gambar.jpg',
                      ),
                    );
                  }),
                  ...newWisataList.map((data) {
                    String tag = 'hotplace_new_${data['nama']}';
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => DetailPage(
                                  heroTag: tag,
                                  title: data['nama'],
                                  location: data['lokasi'],
                                  deskripsi: data['deskripsi'],
                                  image: data['gambar'],
                                  isMemoryImage: true,
                                  harga: data['harga'], // <- pastikan ada key 'harga'
                                ),
                          ),
                        );
                      },
                      child: buildHotPlaceCard(
                        tag,
                        data['nama'],
                        data['lokasi'],
                        data['gambar'],
                        isMemoryImage: true,
                      ),
                    );
                  }),
                ],
              ),
            ),

            SizedBox(height: 10),

            // Best Hotels Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Best Hotels',
                    style: GoogleFonts.poppins(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'See All',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),

            // Best Hotels List
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                ...List.generate(hotelList.length, (index) {
                  String tag = 'besthotel_$index';
                  return buildHotelCard(
                    tag,
                    hotelList[index],
                    'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Quis, doloribus. Eos, accusantium doloremque! Tenetur, sed.',
                    'assets/gambar.jpg',
                  );
                }),
                ...newWisataList.map((data) {
                  String tag = 'besthotel_new_${data['nama']}';
                  return buildHotelCard(
                    tag,
                    data['nama'],
                    data['deskripsi'],
                    data['gambar'],
                    isMemoryImage: true,
                  );
                }),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TambahWisata()),
          );
          if (result != null && result is Map<String, dynamic>) {
            setState(() {
              newWisataList.add(result);
            });
          }
        },
        backgroundColor: const Color.fromARGB(255, 49, 29, 204),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
        shape: const CircleBorder(),
      ),
    );
  }

  Widget buildHotPlaceCard(
    String tag,
    String title,
    String location,
    dynamic image, {
    bool isMemoryImage = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      width: 290,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Hero(
                tag: tag,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child:
                      isMemoryImage
                          ? Image.memory(
                            image,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          )
                          : Image.asset(
                            image,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: Colors.grey[700],
                        ),
                        SizedBox(width: 4),
                        Text(
                          location,
                          style: GoogleFonts.poppins(
                            color: Colors.grey[700],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHotelCard(
    String tag,
    String title,
    String desc,
    dynamic image, {
    bool isMemoryImage = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: 450,
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Hero(
                      tag: tag,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child:
                            isMemoryImage
                                ? Image.memory(
                                  image,
                                  width: 128,
                                  height: 128,
                                  fit: BoxFit.cover,
                                )
                                : Image.asset(
                                  image,
                                  width: 128,
                                  height: 128,
                                  fit: BoxFit.cover,
                                ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          desc,
                          style: GoogleFonts.poppins(fontSize: 13),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
