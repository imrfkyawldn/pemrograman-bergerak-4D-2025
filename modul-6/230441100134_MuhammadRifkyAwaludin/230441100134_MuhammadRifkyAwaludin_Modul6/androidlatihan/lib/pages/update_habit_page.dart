import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

import '../db/db_helper.dart';
import '../models/habit_model.dart';

class UpdateHabitPage extends StatefulWidget {
  final Habit habit;

  const UpdateHabitPage({super.key, required this.habit});

  @override
  State<UpdateHabitPage> createState() => _UpdateHabitPageState();
}

class _UpdateHabitPageState extends State<UpdateHabitPage> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  DateTime? _selectedDate;
  File? _imageFile;
  String? _location;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.habit.tittle);
    _descController = TextEditingController(text: widget.habit.description);
    _selectedDate = DateFormat('yyyy-MM-dd').parse(widget.habit.date);
    _imageFile = File(widget.habit.imagePath);
    _location = widget.habit.location;
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _location =
            "${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}";
      });
    } catch (e) {
      setState(() {
        _location = "Gagal mendapatkan lokasi";
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
        await _getCurrentLocation();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal mengambil gambar")),
      );
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF388E3C), // Hijau tua (AppBar hijau tua)
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Color(0xFF388E3C)),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _removeImage() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text("Apakah Anda yakin ingin menghapus gambar?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );

    if (confirm ?? false) {
      setState(() {
        _imageFile = null;
        _location = null;
      });
    }
  }

  void _updateHabit() async {
    if (_titleController.text.isEmpty ||
        _descController.text.isEmpty ||
        _selectedDate == null ||
        _imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Nama Habit, deskripsi, tanggal, dan gambar harus diisi",
          ),
        ),
      );
      return;
    }

    final updatedHabit = Habit(
      id: widget.habit.id,
      tittle: _titleController.text.trim(),
      description: _descController.text.trim(),
      date: DateFormat('yyyy-MM-dd').format(_selectedDate!),
      imagePath: _imageFile!.path,
      location: _location ?? '',
    );

    await DBHelper.instance.updateHabit(updatedHabit);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Habit berhasil diperbarui")),
    );

    Navigator.pop(context, true);
  }

  Widget _buildInputCard({required Widget child}) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }

  Widget _buildImageSection() {
    if (_imageFile != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.file(_imageFile!, height: 300, fit: BoxFit.cover),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: _removeImage,
              borderRadius: BorderRadius.circular(30),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFF388E3C), // Hijau tua tombol delete
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.photo, color: Colors.white),
            label: const Text("Galeri", style: TextStyle(color: Colors.white)),
            onPressed: () => _pickImage(ImageSource.gallery),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF66BB6A), // Hijau soft
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.camera_alt, color: Colors.white),
            label: const Text("Kamera", style: TextStyle(color: Colors.white)),
            onPressed: () => _pickImage(ImageSource.camera),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF66BB6A), // Hijau soft
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9), // Hijau muda background
      appBar: AppBar(
        title: const Text(
          "Update Habit",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF388E3C), // Hijau tua AppBar
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInputCard(
              child: TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Nama Habit",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            _buildInputCard(
              child: TextField(
                controller: _descController,
                decoration: const InputDecoration(
                  labelText: "Deskripsi",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ),
            _buildInputCard(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? "Tanggal belum dipilih"
                          : DateFormat('dd MMM yyyy').format(_selectedDate!),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _pickDate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF66BB6A), // Hijau soft
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      "Pilih Tanggal",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            _buildInputCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Foto Habit", style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  _buildImageSection(),
                ],
              ),
            ),
            _buildInputCard(
              child: Row(
                children: [
                  const Text("Lokasi: ", style: TextStyle(fontSize: 16)),
                  Expanded(
                    child: Text(
                      _location ?? "Lokasi belum tersedia",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  IconButton(
                    onPressed: _getCurrentLocation,
                    icon: const Icon(Icons.location_on, color: Color(0xFF388E3C)),
                    tooltip: "Perbarui Lokasi",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _updateHabit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32), // Hijau lebih gelap
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                "Update",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
