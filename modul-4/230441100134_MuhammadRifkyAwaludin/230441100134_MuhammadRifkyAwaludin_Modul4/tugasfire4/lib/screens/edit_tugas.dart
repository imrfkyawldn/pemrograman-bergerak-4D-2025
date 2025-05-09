import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/tugas_kuliah.dart';
import '../services/tugas_service.dart';

class EditTugasPage extends StatefulWidget {
  final TugasKuliah tugas;
  const EditTugasPage({super.key, required this.tugas});

  @override
  State<EditTugasPage> createState() => _EditTugasPageState();
}

class _EditTugasPageState extends State<EditTugasPage> {
  final formKey = GlobalKey<FormState>();
  late String nama, deskripsi;
  DateTime? tanggalMulai;
  DateTime? tanggalTenggat;
  String status = 'Belum Selesai';
  final tugasService = TugasService();
  final dateFormat = DateFormat('yyyy-MM-dd');

  final List<String> statusOptions = [
    'Belum Selesai',
    'Sedang Mengerjakan',
    'Selesai'
  ];

  @override
  void initState() {
    super.initState();
    nama = widget.tugas.namaTugas;
    deskripsi = widget.tugas.deskripsi;
    tanggalMulai = DateTime.tryParse(widget.tugas.tanggalMulai);
    tanggalTenggat = DateTime.tryParse(widget.tugas.tanggalTenggat);
    if (statusOptions.contains(widget.tugas.status)) {
      status = widget.tugas.status;
    }
  }

  Future<void> selectDate(BuildContext context, DateTime? initialDate,
      Function(DateTime) onDatePicked) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) onDatePicked(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Tugas"),
        backgroundColor: Colors.lightBlue[300],
      ),
      backgroundColor: Colors.blue[50],
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              buildTextField("Nama Tugas", nama, (val) => nama = val!,
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Wajib diisi' : null),
              buildTextField("Deskripsi", deskripsi, (val) => deskripsi = val!,
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Wajib diisi' : null),
              buildDatePickerField(
                context,
                label: "Tanggal Mulai",
                date: tanggalMulai,
                onDatePicked: (picked) => setState(() => tanggalMulai = picked),
              ),
              buildDatePickerField(
                context,
                label: "Tanggal Tenggat",
                date: tanggalTenggat,
                onDatePicked: (picked) =>
                    setState(() => tanggalTenggat = picked),
              ),
              buildDropdownField("Status", statusOptions),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState?.validate() != true) return;

                  if (tanggalMulai == null || tanggalTenggat == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Pilih tanggal mulai dan tenggat")),
                    );
                    return;
                  }

                  formKey.currentState?.save();

                  await tugasService.updateTugas(TugasKuliah(
                    id: widget.tugas.id,
                    namaTugas: nama,
                    deskripsi: deskripsi,
                    tanggalMulai: dateFormat.format(tanggalMulai!),
                    tanggalTenggat: dateFormat.format(tanggalTenggat!),
                    status: status,
                  ));
                  Navigator.pop(context, true);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue[300]),
                child: const Text("Perbarui"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
    String label,
    String initialValue,
    Function(String?) onSaved, {
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        onSaved: onSaved,
        validator: validator,
      ),
    );
  }

  Widget buildDatePickerField(
    BuildContext context, {
    required String label,
    required DateTime? date,
    required Function(DateTime) onDatePicked,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () => selectDate(context, date, onDatePicked),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          child: Text(
            date != null ? dateFormat.format(date) : 'Pilih Tanggal',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget buildDropdownField(String label, List<String> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: status,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: items
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                ))
            .toList(),
        onChanged: (val) => setState(() => status = val!),
        onSaved: (val) => status = val ?? status,
      ),
    );
  }
}
