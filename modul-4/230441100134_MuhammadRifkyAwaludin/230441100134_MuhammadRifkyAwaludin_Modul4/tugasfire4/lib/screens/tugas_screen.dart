import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/tugas_kuliah.dart';
import '../services/tugas_service.dart';
import 'tambah_tugas.dart';
import 'edit_tugas.dart';

class TugasScreen extends StatefulWidget {
  const TugasScreen({super.key});

  @override
  State<TugasScreen> createState() => _TugasScreenState();
}

class _TugasScreenState extends State<TugasScreen> {
  final TugasService tugasService = TugasService();
  List<TugasKuliah> tugasList = [];
  final dateFormat = DateFormat('d MMM yyyy');

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final data = await tugasService.fetchTugas();
      setState(() {
        tugasList = data;
      });
    } catch (e) {
      print("Error fetching tugas: $e");
    }
  }

  Future<void> navigateToTambah() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TambahTugasPage()),
    );
    if (result != null) fetchData();
  }

  Future<void> navigateToEdit(TugasKuliah tugas) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditTugasPage(tugas: tugas)),
    );
    if (result == true) fetchData();
  }

  Future<void> confirmDelete(TugasKuliah tugas) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text("Yakin ingin menghapus tugas ini?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Batal")),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Hapus")),
        ],
      ),
    );
    if (confirm == true) {
      await tugasService.deleteTugas(tugas.id);
      fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text("Tugas Kuliah"),
        backgroundColor: Colors.lightBlue[300],
      ),
      body: tugasList.isEmpty
          ? const Center(
              child: Text(
                "Belum ada tugas.\nTekan tombol + untuk menambah.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: tugasList.length,
              itemBuilder: (context, index) {
                final tugas = tugasList[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Card(
                    color: Colors.lightBlue[100],
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(
                        tugas.namaTugas,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Deskripsi: ${tugas.deskripsi}"),
                          Text(
                              "Mulai: ${dateFormat.format(DateTime.parse(tugas.tanggalMulai))}"),
                          Text(
                              "Tenggat: ${dateFormat.format(DateTime.parse(tugas.tanggalTenggat))}"),
                          Text("Status: ${tugas.status}"),
                        ],
                      ),
                      isThreeLine: true,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue[900]),
                            onPressed: () => navigateToEdit(tugas),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red[900]),
                            onPressed: () => confirmDelete(tugas),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToTambah,
        backgroundColor: Colors.lightBlue[300],
        child: const Icon(Icons.add),
      ),
    );
  }
}
