import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'edit_tugas.dart';
import 'tambah_tugas.dart';

class TugasScreen extends StatelessWidget {
  const TugasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('d MMM yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tugas Kuliah',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal[700],
        elevation: 5,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.grey[100],
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('daftartugas').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final tugasList = snapshot.data!.docs;

          if (tugasList.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada tugas.\nTekan tombol + untuk menambah.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            itemCount: tugasList.length,
            itemBuilder: (context, index) {
              final tugas = tugasList[index];
              final data = tugas.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), // radius lebih kecil
                child: Padding(
                  padding: const EdgeInsets.all(12), // padding dikurangi
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama tugas
                      Text(
                        data['nama_tugas'] ?? '',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal[900],
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Deskripsi tugas
                      Text(
                        data['deskripsi'] ?? '',
                        style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                      ),
                      const SizedBox(height: 10),

                      // Row tanggal mulai dan tenggat
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 18, color: Colors.teal),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Mulai: ${_formatDate(data['tanggal_mulai'], dateFormat)}',
                              style: TextStyle(color: Colors.teal[700]),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(Icons.hourglass_bottom, size: 18, color: Colors.deepOrange),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Tenggat: ${_formatDate(data['tanggal_tenggat'], dateFormat)}',
                              style: TextStyle(color: Colors.deepOrange[700]),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Status dengan warna
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                        decoration: BoxDecoration(
                          color: _getStatusColor(data['status'] ?? '').withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'Status: ${data['status'] ?? '-'}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _getStatusColor(data['status']),
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Tombol edit & hapus di kanan bawah
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.teal[800],
                            ),
                            icon: const Icon(Icons.edit),
                            label: const Text('Edit'),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditTugasPage(tugas: data, tugasId: tugas.id),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          TextButton.icon(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red[700],
                            ),
                            icon: const Icon(Icons.delete),
                            label: const Text('Hapus'),
                            onPressed: () async {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Konfirmasi'),
                                  content: const Text('Yakin ingin menghapus tugas ini?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, false),
                                      child: const Text('Batal'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, true),
                                      child: const Text('Hapus'),
                                    ),
                                  ],
                                ),
                              );
                              if (confirmed == true) {
                                await FirebaseFirestore.instance
                                    .collection('daftartugas')
                                    .doc(tugas.id)
                                    .delete();
                              }
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal[700],
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TambahTugasPage()),
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 28), // warna putih icon +
      ),
    );
  }

  static String _formatDate(dynamic timestamp, DateFormat dateFormat) {
    if (timestamp == null) return '-';
    if (timestamp is Timestamp) {
      return dateFormat.format(timestamp.toDate());
    }
    if (timestamp is String) {
      try {
        return dateFormat.format(DateTime.parse(timestamp));
      } catch (_) {
        return '-';
      }
    }
    return '-';
  }

  static Color _getStatusColor(String status) {
    switch (status) {
      case 'Belum Selesai':
        return Colors.redAccent;
      case 'Sedang Mengerjakan':
        return Colors.orangeAccent;
      case 'Selesai':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
