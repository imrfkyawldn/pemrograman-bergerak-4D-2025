import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/tugas_kuliah.dart';
import '../services/tugas_service.dart';

class TambahTugasPage extends StatefulWidget {
  const TambahTugasPage({super.key});

  @override
  State<TambahTugasPage> createState() => _TambahTugasPageState();
}

class _TambahTugasPageState extends State<TambahTugasPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _statusController = TextEditingController();
  DateTime? _tanggalMulai;
  DateTime? _tanggalTenggat;

  final tugasService = TugasService();

  Future<void> _pickDate(BuildContext context, bool isMulai) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (newDate != null) {
      setState(() {
        if (isMulai) {
          _tanggalMulai = newDate;
        } else {
          _tanggalTenggat = newDate;
        }
      });
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate() && _tanggalMulai != null && _tanggalTenggat != null) {
      final tugas = TugasKuliah(
        namaTugas: _namaController.text,
        deskripsi: _deskripsiController.text,
        status: _statusController.text,
        tanggalMulai: _tanggalMulai!.toIso8601String(),
        tanggalTenggat: _tanggalTenggat!.toIso8601String(),
      );

      try {
        await tugasService.addTugas(tugas);
        if (mounted) {
          Navigator.pop(context, true);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menambah tugas: $e")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mohon isi semua data dengan benar")),
      );
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('d MMM yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Tugas"),
        backgroundColor: Colors.lightBlue[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: "Nama Tugas"),
                validator: (value) => value == null || value.isEmpty ? "Nama tugas wajib diisi" : null,
              ),
              TextFormField(
                controller: _deskripsiController,
                decoration: const InputDecoration(labelText: "Deskripsi"),
                validator: (value) => value == null || value.isEmpty ? "Deskripsi wajib diisi" : null,
              ),
              TextFormField(
                controller: _statusController,
                decoration: const InputDecoration(labelText: "Status"),
                validator: (value) => value == null || value.isEmpty ? "Status wajib diisi" : null,
              ),
              const SizedBox(height: 20),
              Text("Tanggal Mulai: ${_tanggalMulai != null ? dateFormat.format(_tanggalMulai!) : '-'}"),
              ElevatedButton(
                onPressed: () => _pickDate(context, true),
                child: const Text("Pilih Tanggal Mulai"),
              ),
              const SizedBox(height: 20),
              Text("Tanggal Tenggat: ${_tanggalTenggat != null ? dateFormat.format(_tanggalTenggat!) : '-'}"),
              ElevatedButton(
                onPressed: () => _pickDate(context, false),
                child: const Text("Pilih Tanggal Tenggat"),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _submit,
                child: const Text("Simpan"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue[300],
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
