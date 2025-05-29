import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/habit_model.dart';

class HabitDetailPage extends StatelessWidget {
  final Habit habit;

  const HabitDetailPage({super.key, required this.habit});

  void _openMap(String location) async {
    if (location.isEmpty) return;

    final Uri mapsUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(location)}',
    );

    try {
      if (await canLaunchUrl(mapsUrl)) {
        await launchUrl(mapsUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint("Error membuka Maps: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageFile = File(habit.imagePath);
    final bool hasImage = habit.imagePath.isNotEmpty && imageFile.existsSync();

    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9), // Hijau muda (latar belakang)
      appBar: AppBar(
        title: const Text("Detail Habit"),
        backgroundColor: const Color(0xFF66BB6A), // Hijau soft
        foregroundColor: Colors.white,
        elevation: 2,
        leading: const Icon(Icons.task_alt), // Ikon habit (centang)
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child:
                    hasImage
                        ? Image.file(
                          imageFile,
                          width: double.infinity,
                          height: 220,
                          fit: BoxFit.cover,
                        )
                        : Container(
                          width: double.infinity,
                          height: 220,
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: Text(
                              "Tidak ada gambar",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
              ),
              const SizedBox(height: 16),

              // Judul
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    habit.tittle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32), // Hijau gelap
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Divider(height: 1, color: Colors.grey.shade300),

              // Deskripsi
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                leading: const Icon(Icons.notes, color: Color(0xFF2E7D32)),
                title: const Text(
                  "Deskripsi Habit",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  habit.description,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ),
              Divider(height: 1, color: Colors.grey.shade300),

              // Tanggal
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                leading: const Icon(
                  Icons.calendar_today,
                  color: Color(0xFF2E7D32),
                ),
                title: const Text(
                  "Tanggal",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  habit.date,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Divider(height: 1, color: Colors.grey.shade300),

              // Lokasi
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                leading: const Icon(
                  Icons.location_on,
                  color: Color(0xFF2E7D32),
                ),
                title: const Text(
                  "Lokasi",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle:
                    habit.location.isNotEmpty
                        ? GestureDetector(
                          onTap: () => _openMap(habit.location),
                          child: Text(
                            habit.location,
                            style: const TextStyle(
                              color: Color(0xFF2E7D32),
                              decoration: TextDecoration.underline,
                              fontSize: 16,
                            ),
                          ),
                        )
                        : const Text(
                          "Tidak tersedia",
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
