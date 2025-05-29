import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class EditTugasPage extends StatefulWidget {
  final Map<String, dynamic> tugas;
  final String tugasId;
  const EditTugasPage({Key? key, required this.tugas, required this.tugasId}) : super(key: key);

  @override
  _EditTugasPageState createState() => _EditTugasPageState();
}

class _EditTugasPageState extends State<EditTugasPage> {
  final _formKey = GlobalKey<FormState>();
  late String nama, deskripsi, status;
  DateTime? tanggalMulai, tanggalTenggat;
  final List<String> statusOptions = ['Belum Selesai', 'Sedang Mengerjakan', 'Selesai'];

  @override
  void initState() {
    super.initState();
    nama = widget.tugas['nama_tugas'] ?? '';
    deskripsi = widget.tugas['deskripsi'] ?? '';

    final tMulai = widget.tugas['tanggal_mulai'];
    if (tMulai is Timestamp) {
      tanggalMulai = tMulai.toDate();
    } else if (tMulai is String) {
      tanggalMulai = DateTime.tryParse(tMulai);
    }

    final tTenggat = widget.tugas['tanggal_tenggat'];
    if (tTenggat is Timestamp) {
      tanggalTenggat = tTenggat.toDate();
    } else if (tTenggat is String) {
      tanggalTenggat = DateTime.tryParse(tTenggat);
    }

    status = widget.tugas['status'] ?? statusOptions[0];
  }

  Future<void> selectDate(BuildContext context, DateTime? initialDate, Function(DateTime) onPicked) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.teal,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.teal,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) onPicked(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Tugas'),
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
                initialValue: nama,
                decoration: const InputDecoration(
                  labelText: 'Nama Tugas',
                  border: OutlineInputBorder(),
                ),
                onSaved: (val) => nama = val ?? '',
                validator: (val) => (val == null || val.isEmpty) ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: deskripsi,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onSaved: (val) => deskripsi = val ?? '',
                validator: (val) => (val == null || val.isEmpty) ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                tileColor: Colors.white,
                title: Text(
                  tanggalMulai != null
                      ? 'Tanggal Mulai: ${DateFormat('yyyy-MM-dd').format(tanggalMulai!)}'
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
                      ? 'Tanggal Tenggat: ${DateFormat('yyyy-MM-dd').format(tanggalTenggat!)}'
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
                items: statusOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => status = val ?? statusOptions[0]),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[700],
                  foregroundColor: Colors.white, // tulisan putih
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

                  await FirebaseFirestore.instance
                      .collection('daftartugas')
                      .doc(widget.tugasId)
                      .update({
                    'nama_tugas': nama,
                    'deskripsi': deskripsi,
                    'tanggal_mulai': Timestamp.fromDate(tanggalMulai!),
                    'tanggal_tenggat': Timestamp.fromDate(tanggalTenggat!),
                    'status': status,
                  });

                  Navigator.pop(context, true);
                },
                child: const Text('Simpan Perubahan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
