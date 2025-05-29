import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TambahTugasPage extends StatefulWidget {
  const TambahTugasPage({Key? key}) : super(key: key);

  @override
  _TambahTugasPageState createState() => _TambahTugasPageState();
}

class _TambahTugasPageState extends State<TambahTugasPage> {
  final _formKey = GlobalKey<FormState>();
  String nama = '', deskripsi = '', status = 'Belum Selesai';
  DateTime? tanggalMulai, tanggalTenggat;
  final List<String> statusList = ['Belum Selesai', 'Sedang Mengerjakan', 'Selesai'];
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  Future<void> selectDate(BuildContext context, DateTime? currentDate, Function(DateTime) onSelected) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: currentDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.teal, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black, // Body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.teal, // Button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) onSelected(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Tugas'),
        centerTitle: true,
        backgroundColor: Colors.teal[700],
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nama Tugas',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => (val == null || val.isEmpty) ? 'Wajib diisi' : null,
                onSaved: (val) => nama = val ?? '',
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (val) => (val == null || val.isEmpty) ? 'Wajib diisi' : null,
                onSaved: (val) => deskripsi = val ?? '',
              ),
              const SizedBox(height: 16),
              ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                tileColor: Colors.white,
                title: Text(
                  tanggalMulai != null
                      ? 'Tanggal Mulai: ${dateFormat.format(tanggalMulai!)}'
                      : 'Pilih Tanggal Mulai',
                  style: const TextStyle(fontSize: 16),
                ),
                trailing: const Icon(Icons.calendar_today, color: Colors.teal),
                onTap: () => selectDate(context, tanggalMulai, (d) => setState(() => tanggalMulai = d)),
              ),
              const SizedBox(height: 12),
              ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                tileColor: Colors.white,
                title: Text(
                  tanggalTenggat != null
                      ? 'Tanggal Tenggat: ${dateFormat.format(tanggalTenggat!)}'
                      : 'Pilih Tanggal Tenggat',
                  style: const TextStyle(fontSize: 16),
                ),
                trailing: const Icon(Icons.calendar_today, color: Colors.teal),
                onTap: () => selectDate(context, tanggalTenggat, (d) => setState(() => tanggalTenggat = d)),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Status',
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                value: status,
                items: statusList.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => status = val ?? statusList[0]),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[700],
                  foregroundColor: Colors.white, // teks putih
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  if (tanggalMulai == null || tanggalTenggat == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pilih tanggal mulai dan tenggat')),
                    );
                    return;
                  }
                  _formKey.currentState!.save();

                  await FirebaseFirestore.instance.collection('daftartugas').add({
                    'nama_tugas': nama,
                    'deskripsi': deskripsi,
                    'tanggal_mulai': tanggalMulai,
                    'tanggal_tenggat': tanggalTenggat,
                    'status': status,
                  });

                  Navigator.pop(context);
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
