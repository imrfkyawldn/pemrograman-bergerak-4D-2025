import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:typed_data';

class DetailPage extends StatelessWidget {
  final String heroTag;
  final String title;
  final String location;
  final String deskripsi;
  final dynamic image;
  final bool isMemoryImage;
  final String harga;

  const DetailPage({
    Key? key,
    required this.heroTag,
    required this.title,
    required this.location,
    required this.deskripsi,
    required this.image,
    this.isMemoryImage = false,
    required this.harga, // tambahkan ini
  }) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    final String finalDeskripsi =
        title.toLowerCase().contains('national')
            ? 'Lorem ipsum est donec non interdum amet phasellus egestas id dignissim in vestibulum augue ut a lectus '
                'rhoncus sed ullamcorper at vestibulum sed mus neque amet turpis placerat in luctus at a eget egestas '
                'praesent congue semper in facilisis purus dis pharetra odio ullamcorper euismod a donec consectetur '
                'pellentesque pretium sapien proin tincidunt non augue turpis massa euismod quis lorem et feugiat '
                'ornare id cras sed eget adipiscing dolor urna mi sit a a auctor mattis urna fermentum facilisi sed '
                'aliquet odio at suspendisse posuere tellus pellentesque id quis libero fames blandit ullamcorper '
                'interdum eget placerat tortor cras nulla consectetur et duis viverra mattis libero scelerisque gravida '
                'egestas blandit tincidunt ullamcorper auctor aliquam leo urna adipiscing est ut ipsum consectetur id '
                'erat semper fames elementum rhoncus quis varius pellentesque quam neque vitae sit velit leo massa '
                'habitant tellus velit pellentesque cursus laoreet donec etiam id vulputate nisi integer eget gravida '
                'volutpat.'
            : deskripsi;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 235, 235),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Hero(
                  tag: heroTag,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child:
                        isMemoryImage
                            ? Image.memory(
                              image,
                              width: double.infinity,
                              height: 220,
                              fit: BoxFit.cover,
                            )
                            : Image.asset(
                              image,
                              width: double.infinity,
                              height: 220,
                              fit: BoxFit.cover,
                            ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'assets/icon_wisata.png',
                                width: 20,
                                height: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Wisata Alam',
                                style: GoogleFonts.poppins(fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Image.asset(
                                'assets/icon_lokasi.png',
                                width: 20,
                                height: 20,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                location,
                                style: GoogleFonts.poppins(fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'assets/icon_tiket.png',
                          width: 25,
                          height: 25,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          harga,
                          style: GoogleFonts.poppins(fontSize: 24),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13.0),
                child: Text(
                  finalDeskripsi,
                  style: GoogleFonts.poppins(fontSize: 14, height: 1.5),
                  textAlign: TextAlign.justify,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}