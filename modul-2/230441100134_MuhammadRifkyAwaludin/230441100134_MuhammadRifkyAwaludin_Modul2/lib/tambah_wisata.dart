import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class TambahWisata extends StatefulWidget {
  @override
  _TambahWisataState createState() => _TambahWisataState();
}

class _TambahWisataState extends State<TambahWisata> {
  final _formKey = GlobalKey<FormState>();
  String? selectedJenisWisata;
  File? selectedImage;
  Uint8List? selectedImageBytes;

  final TextEditingController namaController = TextEditingController();
  final TextEditingController lokasiController = TextEditingController();
  final TextEditingController hargaController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();

  final List<String> jenisWisataList = [
    'Pantai',
    'Pegunungan',
    'Kota',
    'Taman',
    'Sejarah',
  ];

  void resetForm() {
    _formKey.currentState?.reset();
    namaController.clear();
    lokasiController.clear();
    hargaController.clear();
    deskripsiController.clear();
    setState(() {
      selectedJenisWisata = null;
      selectedImage = null;
      selectedImageBytes = null;
    });
  }

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          selectedImageBytes = bytes;
        });
      } else {
        setState(() {
          selectedImage = File(pickedFile.path);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E0E0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        centerTitle: true,
        title: Text(
          'Tambah Wisata',
          style: GoogleFonts.poppins(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: pickImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.deepPurple, width: 1),
                  ),
                  child:
                      (kIsWeb && selectedImageBytes != null)
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.memory(
                              selectedImageBytes!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          )
                          : (!kIsWeb && selectedImage != null)
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              selectedImage!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          )
                          : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.add_photo_alternate_outlined,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Klik untuk memilih gambar",
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: pickImage,
                child: Text("Upload Image", style: GoogleFonts.poppins()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 49, 29, 204),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 40),
                ),
              ),
              const SizedBox(height: 20),

              buildLabel("Nama Wisata :"),
              buildInputField(namaController, "Masukkan Nama Wisata Disini"),

              buildLabel("Lokasi Wisata :"),
              buildInputField(
                lokasiController,
                "Masukkan Lokasi Wisata Disini",
              ),

              buildLabel("Jenis Wisata :"),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(border: InputBorder.none),
                  hint: Text(
                    "Pilih Jenis Wisata",
                    style: GoogleFonts.poppins(),
                  ),
                  value: selectedJenisWisata,
                  onChanged: (newValue) {
                    setState(() {
                      selectedJenisWisata = newValue;
                    });
                  },
                  items:
                      jenisWisataList.map((String jenis) {
                        return DropdownMenuItem<String>(
                          value: jenis,
                          child: Text(jenis, style: GoogleFonts.poppins()),
                        );
                      }).toList(),
                ),
              ),
              const SizedBox(height: 10),

              buildLabel("Harga Tiket :"),
              buildInputField(
                hargaController,
                "Masukkan Harga Tiket Disini",
                keyboardType: TextInputType.number,
              ),

              buildLabel("Deskripsi :"),
              buildInputField(
                deskripsiController,
                "Masukkan Deskripsi Disini",
                maxLines: 3,
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final wisataData = {
                      'nama': namaController.text,
                      'lokasi': lokasiController.text,
                      'harga': hargaController.text,
                      'deskripsi': deskripsiController.text,
                      'jenis': selectedJenisWisata ?? '',
                      'gambar':
                          kIsWeb
                              ? selectedImageBytes
                              : selectedImage?.readAsBytesSync(),
                    };

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Data berhasil disimpan!")),
                    );

                    Navigator.pop(
                      context,
                      wisataData,
                    ); // kirim data ke HomePage
                  }
                },
                child: Text("Simpan", style: GoogleFonts.poppins()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 40),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: resetForm,
                child: Text(
                  "Reset",
                  style: GoogleFonts.poppins(color: Colors.deepPurple),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget buildInputField(
    TextEditingController controller,
    String hintText, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 12,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      validator:
          (value) =>
              value == null || value.isEmpty
                  ? 'Field ini tidak boleh kosong'
                  : null,
    );
  }
}
