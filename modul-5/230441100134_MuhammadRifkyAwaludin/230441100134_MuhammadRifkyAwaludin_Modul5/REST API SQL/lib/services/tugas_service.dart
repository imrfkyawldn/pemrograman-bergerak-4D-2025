import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tugas_kuliah.dart';

class TugasService {
  final String baseUrl = "http://localhost/modul5/api/tugas.php";

  Future<List<TugasKuliah>> fetchTugas() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => TugasKuliah.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil data tugas');
    }
  }

  Future<void> addTugas(TugasKuliah tugas) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(tugas.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Gagal menambahkan tugas');
    }
  }

  Future<void> updateTugas(TugasKuliah tugas) async {
    final response = await http.put(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(tugas.toJsonWithId()),
    );
    if (response.statusCode != 200) {
      throw Exception('Gagal mengubah tugas');
    }
  }

  Future<void> deleteTugas(String id) async {
    final response = await http.delete(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"id": id}),
    );
    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus tugas');
    }
  }
}
