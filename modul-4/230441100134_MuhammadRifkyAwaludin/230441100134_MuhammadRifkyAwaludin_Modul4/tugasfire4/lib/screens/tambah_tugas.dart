import 'package:flutter/material.dart';
import '../models/tugas_kuliah.dart';
import '../services/tugas_service.dart';

class TambahTugasPage extends StatefulWidget {
  const TambahTugasPage({super.key});

  @override
  _TambahTugasPageState createState() => _TambahTugasPageState();
}

class _TambahTugasPageState extends State<TambahTugasPage> {
  final formKey = GlobalKey<FormState>();
  String nama = '', deskripsi = '', status = 'Belum Selesai';
  DateTime? tanggalMulai, tanggalTenggat;
  final tugasService = TugasService();

  final List<String> statusList = [
    'Belum Selesai',
    'Sedang Mengerjakan',
    'Selesai'
  ];

  Future<void> _selectDate(BuildContext context, DateTime? currentDate,
      ValueChanged<DateTime> onDateSelected) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Tugas"),
        backgroundColor: Colors.lightBlue[300],
      ),
      backgroundColor: Colors.blue[50],
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              buildTextField("Nama Tugas", (val) => nama = val!,
                  validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null),
              buildTextField("Deskripsi", (val) => deskripsi = val!,
                  validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null),
              buildDateField(
                  "Tanggal Mulai", tanggalMulai, (val) => tanggalMulai = val),
              buildDateField("Tanggal Tenggat", tanggalTenggat,
                  (val) => tanggalTenggat = val),
              buildDropdownStatus(),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState?.validate() != true) return;

                  if (tanggalMulai == null || tanggalTenggat == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Pilih tanggal mulai dan tenggat")),
                    );
                    return;
                  }

                  formKey.currentState?.save();

                  final newTugas = TugasKuliah(
                    id: '',
                    namaTugas: nama,
                    deskripsi: deskripsi,
                    tanggalMulai:
                        tanggalMulai!.toIso8601String().substring(0, 10),
                    tanggalTenggat:
                        tanggalTenggat!.toIso8601String().substring(0, 10),
                    status: status,
                  );
                  await tugasService.addTugas(newTugas);
                  Navigator.pop(context, newTugas);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue[300]),
                child: const Text("Simpan"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, Function(String?) onSaved,
      {String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        onSaved: onSaved,
        validator: validator,
      ),
    );
  }

  Widget buildDateField(String label, DateTime? selectedDate,
      ValueChanged<DateTime> onDateSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () => _selectDate(context, selectedDate, (picked) {
          setState(() => onDateSelected(picked));
        }),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          child: Text(selectedDate == null
              ? 'Pilih Tanggal'
              : selectedDate.toLocal().toString().split(' ')[0]),
        ),
      ),
    );
  }

  Widget buildDropdownStatus() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          labelText: "Status",
          border: OutlineInputBorder(),
        ),
        value: status,
        items: statusList
            .map((statusItem) => DropdownMenuItem<String>(
                  value: statusItem,
                  child: Text(statusItem),
                ))
            .toList(),
        onChanged: (newValue) {
          setState(() {
            status = newValue!;
          });
        },
      ),
    );
  }
}
